import UIKit
import CoreBluetooth

//fileprivate let SDKVersion = "1.0"

/// OTA类型
@objc public enum SFOTAType:Int {
    case none
    case nand
    case norV2
    case norV1
}

@objc public enum SFOTANorV1Mode:Int {
    /// 普通模式
    case normal = 0
    
    /// 强制启动
    case force
    
    /// 续传
    case resume
}

@objc public class SFNandImageFileInfo:NSObject {
    @objc public let path:URL
    @objc public let imageID:NandImageID
    @objc public init(path: URL, imageID: NandImageID) {
        self.path = path
        self.imageID = imageID
        super.init()
    }
    
    public override var description: String {
        return "{path=\(path), imageID=\(imageID)(\(imageID.rawValue))}"
    }
}

@objc public class SFNorImageFileInfo:NSObject {
    @objc public let path:URL
    @objc public let imageID:NorImageID
    @objc public init(path: URL, imageID: NorImageID) {
        self.path = path
        self.imageID = imageID
        super.init()
    }
    
    public override var description: String {
        return "{path=\(path), imageID=\(imageID)}"
    }

}


enum ManagerStatus {
    
    case leisure // 空闲
    case searching // 搜索外设
    case connecting // 连接外设
    case moduleWorking // 模块工作
}

@objc public protocol SFOTAManagerDelegate: NSObjectProtocol {
    
    
    /// 蓝牙状态改变回调。当state为poweredOn时才能启动升级，否则会启动失败。
    /// state还可以通过manager的bleState属性来主动获取。
    /// - Parameters:
    ///   - manager: 管理器
    ///   - state: 新蓝牙状态
    func otaManager(manager:SFOTAManager, updateBleState state:BleCoreManagerState)
    
    
    /// 进度回调
    /// - Parameters:
    ///   - manager: 管理器
    ///   - stage: 当前所处的发送阶段
    ///   - totalBytes: 当前阶段总字节数
    ///   - completedBytes: 当前阶段已完成字节数
    func otaManager(manager:SFOTAManager, stage:SFOTAProgressStage, totalBytes:Int, completedBytes:Int)
    
    
    /// OTA流程结束
    /// - Parameters:
    ///   - manager: 管理器
    ///   - error: nil-表示成功，否则表示失败
    func otaManager(manager:SFOTAManager, complete error:SFOTAError?)
}

@objc public class SFOTAManager: NSObject, QBleCoreDelegate, SFOTAModuleDelegate {
    
    @objc static public var SDKVersion:String {
        return Const_SDKVersion
    }
    
    @objc public static let share = SFOTAManager.init()
    
    @objc public weak var delegate:SFOTAManagerDelegate?
    
    /// 搜索目标外设时的超时时间(秒)，默认20秒
    @objc public var searchingTimeout:Int = 20
    
    @objc public func logTest() {
    #if DEBUG
        NSLog("Log Test:\(bleCore.isConnected)")
    #endif
    }
    
    
    /// 当前蓝牙状态
    @objc public var bleState:BleCoreManagerState{
        return bleCore.state
    }
    
    
    /// true-当前manager正在执行其它任务，开始新的OTA流程的行为会被忽略。false-处于空闲状态
    @objc public var isBusy:Bool {
        return currentModule != nil
    }
    
    /// 当前正在执行的OTA类型。none表示当前没有OTA流程
    @objc public var otaType:SFOTAType{
        if currentModule === self.nandModule {
            return .nand
        }else if currentModule === self.norV2Module {
            return .norV2
        }else if currentModule === self.norV1Module {
            return .norV1
        }else {
            return .none
        }
    }
    
    
    /// 开启NAND升级
    /// - Parameters:
    ///   - targetDeviceIdentifier: 目标设备的identifier字符串。通过CBPeripheral.identifier.uuidString获取
    ///   - resourcePath: 1.可以输入一个zip格式的资源文件本地路径,sdk将会解压后检索orderFile;2.可以输入资源路径本地根目录,sdk将会在那里检索orderFile,传输过程不可变动目录内容。为nil表示本次升级不涉及资源文件
    ///   - controlImageFilePath: 与Image升级文件对应的control文件的本地路径。
    ///   - imageFileInfos: Image文件本地地址与类型信息。如果controlImageFilePath为nil则忽略该参数
    ///   - tryResume: 是否尝试启用续传功能。
    ///   - 发送Image部分时，设备的回复频率。默认4（即SDK发送20包数据，设备进行一次回复），数值越大理论上速度越快，但超过设备的处理能力反而会因为重发而降低整体的发送速度，因此该值需要依据具体的设备性能而定。
    @objc public func startOTANand(targetDeviceIdentifier:String,resourcePath:URL?, controlImageFilePath:URL?, imageFileInfos:[SFNandImageFileInfo], tryResume:Bool, imageResponseFrequnecy:UInt8 = 4){
        if let module = currentModule {
            OLog("⚠️Manager正忙: \(module.name) is Working !!!")
            return
        }
        
        if imageResponseFrequnecy == 0 {
            OLog("❌参数异常: imageResponseFrequnecy=\(imageResponseFrequnecy)")
            let error = SFOTAError.init(errorType: .InvalidParams, errorDes: "非法的参数: responseFrequency=\(imageResponseFrequnecy)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        if bleCore.state != .poweredOn {
            let error = SFOTAError.init(errorType: .UnavailableBleStatus, errorDes: "蓝牙不可用:\(bleCore.state)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        // 容错
        self.clearCaches()
        self.nandModule.clear()
        
        self.targetDevIdentifier = targetDeviceIdentifier
        self.currentModule = self.nandModule
        self.nandModule.start(resourcePath: resourcePath, controlImageFilePath: controlImageFilePath, imageFileInfos: imageFileInfos, tryResume: tryResume, imageRspFrequency: imageResponseFrequnecy)
    }
    
    
    
    /// 开启NorV2升级
    /// - Parameters:
    ///   - targetDeviceIdentifier: 目标设备的identifier字符串。通过CBPeripheral.identifier.uuidString获取
    ///   - controlImageFilePath: 与Image升级文件对应的control文件的本地路径。
    ///   - imageFileInfos: image文件信息列表。包含image文件本地路径以及image文件类型。
    ///   - tryResume: 是否尝试启用续传功能。
    ///   - 发送Image时，设备的回复频率。默认20（即SDK发送20包数据，设备进行一次回复），数值越大理论上速度越快，但超过设备的处理能力反而会因为重发而降低整体的发送速度，因此该值需要依据具体的设备性能而定。
    @objc public func startOTANorV2(targetDeviceIdentifier:String, controlImageFilePath:URL, imageFileInfos:[SFNorImageFileInfo], tryResume:Bool, responseFrequency:UInt8 = 20) {
        if let module = currentModule {
            OLog("⚠️Manager正忙: \(module.name) is Working !!!")
            return
        }
        
        if responseFrequency == 0 {
            OLog("❌参数异常: responseFrequency=\(responseFrequency)")
            let error = SFOTAError.init(errorType: .InvalidParams, errorDes: "非法的参数: responseFrequency=\(responseFrequency)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        if bleCore.state != .poweredOn {
            OLog("❌蓝牙不可用，回调失败")
            let error = SFOTAError.init(errorType: .UnavailableBleStatus, errorDes: "蓝牙不可用:\(bleCore.state)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        // 容错
        self.clearCaches()
        self.norV2Module.clear()
        
        self.targetDevIdentifier = targetDeviceIdentifier
        self.currentModule = self.norV2Module
        self.norV2Module.start(controlImageFilePath: controlImageFilePath, imageFileInfos: imageFileInfos, tryResume: tryResume, rspFrequency: responseFrequency)
    }
    
    
    /// 启动NorV1升级
    /// - Parameters:
    ///   - targetDeviceIdentifier: 目标设备的identifier字符串。通过CBPeripheral.identifier.uuidString获取
    ///   - ctrlFilePath: 与Image升级文件对应的control文件的本地路径。
    ///   - imageFileInfos: image文件信息列表。包含image文件本地路径以及image文件类型。
    ///   - triggerMode: 升级的触发模式。
    ///   - 发送Image时，设备的回复频率。默认20（即SDK发送20包数据，设备进行一次回复），数值越大理论上速度越快，但超过设备的处理能力反而会因为重发而降低整体的发送速度，因此该值需要依据具体的设备性能而定。
    @objc public func startOTANorV1(targetDeviceIdentifier:String,ctrlFilePath:URL, imageFileInfos:[SFNorImageFileInfo], triggerMode:NorV1TriggerMode, responseFrequency:UInt8 = 20) {
        if let module = currentModule {
            OLog("⚠️Manager正忙: \(module.name) is Working !!!")
            return
        }
        
        if bleCore.state != .poweredOn {
            let error = SFOTAError.init(errorType: .UnavailableBleStatus, errorDes: "蓝牙不可用:\(bleCore.state)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        // 容错
        self.clearCaches()
        self.norV1Module.clear()
        
        self.targetDevIdentifier = targetDeviceIdentifier
        self.currentModule = self.norV1Module
        self.norV1Module.start(controlImageFilePath: ctrlFilePath, imageFileInfos: imageFileInfos, triggerMode: triggerMode, rspFrequency: responseFrequency)
    }
    
    
    /// OTA Nor Offlie 单文件传输
    /// - Parameters:
    ///   - targetDeviceIdentifier: 目标设备
    ///   - offlineFilePath: offline file path
    @objc public func startOTANorOffline(targetDeviceIdentifier:String,offlineFilePath:URL){
        if let module = currentModule {
            OLog("⚠️Manager正忙: \(module.name) is Working !!!")
            return
        }
        
        if bleCore.state != .poweredOn {
            let error = SFOTAError.init(errorType: .UnavailableBleStatus, errorDes: "蓝牙不可用:\(bleCore.state)")
            self.delegate?.otaManager(manager: self, complete: error)
            return
        }
        
        // 容错
        self.clearCaches()
        self.norOfflineModule.clear()
        
        self.targetDevIdentifier = targetDeviceIdentifier
        self.currentModule = self.norOfflineModule
      
        self.norOfflineModule.start(offlineFilePath: offlineFilePath)
    }
    
    /// 终止升级流程
    @objc public func stop(){
        let busy = self.isBusy
        self.clearCaches()
        if busy {
            let error = SFOTAError.init(errorType: .General, errorDes: "Manager主动终止了升级")
            self.delegate?.otaManager(manager: self, complete: error)
        }
        self.bleCore.cancelConnection()
    }
    
    /// 初始化SDK
    /// 尽量提前执行，避免在调用ota方法时蓝牙状态未就绪失败.
    @objc public func initSDK(){
        
    }
    
    private let bleCore = QBleCore.sharedInstance
    
    private let nandModule = SFOTANandModule.share
    
    private let norV2Module = SFOTANorV2Module.share
    
    private let norV1Module = SFOTANorV1Module.share
    
    private let norOfflineModule = SFOTANorOfflineModule.share
    
    private override init() {
        super.init()
        bleCore.delegate = self
        nandModule.delegate = self
        norV2Module.delegate = self
        norV1Module.delegate = self
        norOfflineModule.delegate = self;
    }
    
    
    /// 记录当前目标外设的信息，以备重连
    private var targetDevIdentifier:String?
    /// 搜索外设时的超时定时器
    private var searchTimer:Timer?
    /// 当前的工作模块
    private var currentModule:SFOTAModuleBase?
    /// 连接成功后初始化该mtu值
    private var mtu:Int?
    /// manager的工作状态，内部使用，便于进行某些行为的判断
    private var status:ManagerStatus = .leisure
    
    
    
    
    /// 搜索目标设备超时
    private func searchTimeout(timer:Timer) {
        
        self.clearCaches()
        let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索设备超时")
        self.delegate?.otaManager(manager: self, complete: error)
    }
    
    // 状态改变
    func bleCore(core: QBleCore, didUpdateState state: BleCoreManagerState) {

        guard let curModule = currentModule else {
            OLog("蓝牙状态变化:\(state), ⚠️当前没有工作模块")
            return
        }
        curModule.bleEventHandler(bleCore: core, event: .updateState, object: state)
//        let bleState = transToBleState(state: state)
        delegate?.otaManager(manager: self, updateBleState: state)
    }
    // 找到外设
    func bleCore(core: QBleCore, didDiscover peripheral: CBPeripheral) {

        if self.status != .searching {
            OLog("⚠️[异常]没有处于搜索状态，停止搜索。")
            bleCore.stopScan()
            return
        }
        if peripheral.identifier.uuidString.uppercased() == targetDevIdentifier?.uppercased() {
            // 找到外设
            OLog("✅找到外设(\(peripheral.name ?? "nil"), \(peripheral.identifier.uuidString))，准备连接...")
            self.searchTimer?.invalidate()
            self.searchTimer = nil
            self.status = .connecting
            bleCore.stopScan()
            bleCore.connect(peripheral: peripheral, withShakeHands: true, withNotify: true)
        }
    }
    /// 连接失败
    func bleCore(core: QBleCore, failedToConnectPeripheral peripheral: CBPeripheral, error: QError) {
        OLog("连接失败, \(error)")
        currentModule?.bleEventHandler(bleCore: core, event: .failedToConnect, object: error)
    }
    /// 连接成功
    func bleCore(core: QBleCore, successToConnect peripheral: CBPeripheral, handeShaked: Bool) {
        OLog("✅连接成功:\(peripheral.name ?? ""),\(peripheral.identifier.uuidString)")
        let maxLength = peripheral.maximumWriteValueLength(for: .withoutResponse)
        if maxLength > 247 {
            OLog("⚠️获取到的mtu（\(maxLength)）大于247，强制设置为247")
            self.mtu = 247
        }else{
            OLog("✅获取到mtu=\(maxLength)")
            self.mtu = maxLength
        }
        if(self.mtu! > 190){
            NandResFile.sliceLength = NandResFile.sliceLengthMtuMoreThan190
        }else{
            NandResFile.sliceLength = NandResFile.sliceLengthMtuLessThan190
        }
        currentModule?.bleEventHandler(bleCore: core, event: .shakedHands, object: nil)
    }
    /// 断开连接
    func bleCore(core: QBleCore, didDisconnectPeripheral peripheral: CBPeripheral, error: QError) {
        currentModule?.bleEventHandler(bleCore: core, event: .disconnected, object: error)
    }
    /// 收到数据
    func bleCore(core: QBleCore, characteristic: CBCharacteristic, didUpdateValue value: Data) {
        // 统一解析成SerialTransport包
        if value.count < 4{
            OLog("⚠️收到的ble数据长度小于4，忽略")
            return
        }
        let serialPack = SFSerialTransportPack.init(cateID: value[0], flag: value[1])
        if value.count > 4 {
            serialPack.payloadData = value[4..<value.count]
        }
        OLog("解析出SerialTransportPack: \(serialPack)")
        
        // 将payload传入module进行处理
        if let module = self.currentModule {
            module.bleDataHandler(bleCore: core, data: serialPack.payloadData)
        }else{
            OLog("⚠️当前没有工作模块，放弃对SerialPack的处理")
        }
    }
    /// 写入成功
    func bleCore(core: QBleCore, didWriteValue writeCharacteristic: CBCharacteristic, error: Error?) {
        OLog("写入蓝牙数据成功")
    }
    
    
    /// 模块向Manager发出‘断连请求’
    func otaModuleDisconnectRequest(module: SFOTAModuleBase) {
        OLog("⚠️模块'\(module.name)'发起断连请求")
        bleCore.cancelConnection()
    }
    /// 模块向Manager发出‘重连请求’
    func otaModuleReconnectRequest(module: SFOTAModuleBase) {
        if let targetId = targetDevIdentifier {
            OLog("ℹ️模块'\(module.name)'发起连接请求(targetDevIdentifier=\(targetId))。准备开启设备搜索....")
            let connectedDevices = bleCore.retrievePairedPeripherals()
            for device in connectedDevices {
                if device.identifier.uuidString.uppercased() == targetId.uppercased() {
                    OLog("✅找到外设(connected)(\(device.name ?? "nil"), \(device.identifier.uuidString))，准备连接...")
                    self.searchTimer?.invalidate()
                    self.searchTimer = nil
                    self.status = .connecting
                    bleCore.stopScan()
                    bleCore.connect(peripheral: device, withShakeHands: true, withNotify: true)
                    return
                }
            }
            self.status = .searching
            /// 在搜索回调中执行重连
            bleCore.stopScan()
            searchTimer?.invalidate()
            let timer = Timer.init(timeInterval: TimeInterval.init(searchingTimeout), target: self, selector: #selector(searchTimeoutHandler(timer:)), userInfo: nil, repeats: false)
            self.searchTimer = timer
            RunLoop.main.add(timer, forMode: .default)
            bleCore.startScan(withServicesFilter: false)
        }else{
            OLog("❌模块'\(module.name)'发起重连请求，但targetIdentifier为nil，准备终止流程)")
            clearCaches()
            let error = SFOTAError.init(errorType: .Unknown, errorDes: "targetIdentifier is nil When Reconnect")
            delegate?.otaManager(manager: self, complete: error)
        }
    }
    
    @objc private func searchTimeoutHandler(timer:Timer) {
        OLog("⚠️搜索设备即将超时，再次尝试从已连接设备中获取...")
        let connectedDevices = self.bleCore.retrievePairedPeripherals()
        for device in connectedDevices {
            if device.identifier.uuidString.uppercased() == self.targetDevIdentifier?.uppercased() {
                // 找到目标外设
                OLog("✅找到外设(retry connected)(\(device.name ?? "nil"), \(device.identifier.uuidString))，准备连接...")
                self.searchTimer?.invalidate()
                self.searchTimer = nil
                self.status = .connecting
                self.bleCore.stopScan()
                self.bleCore.connect(peripheral: device, withShakeHands: true, withNotify: true)
                return
            }
        }
        OLog("⚠️搜索设备超时: timeout=\(self.searchingTimeout)")
        let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索设备超时")
        self.currentModule?.bleEventHandler(bleCore: self.bleCore, event: .disconnected, object: error)
    }
    
    /// 模块向Manager发出'数据发送请求'
    func otaModuleSendDataRequest(module: SFOTAModuleBase, data: Data) {
        let logData = NSData.init(data: data)
        OLog("📨模块'\(module.name)'发送数据请求: data=\(logData.customDescription)")
        if bleCore.isShakedHands == false {
            OLog("⚠️蓝牙未握手，忽略")
            return
        }
        guard let `mtu` = self.mtu else {
            OLog("⚠️MTU为nil，忽略发送请求")
            return
        }
        let packs = SFSerialTransportPack.Packs(mtu: mtu, msgData: data)
        for pack in packs {
            let packData = pack.marshal()
            bleCore.writeValueForWriteCharateristic(value: packData)
        }

    }
    /// 模块向Manager回调进度信息
    func otaModuleProgress(module: SFOTAModuleBase, stage: SFOTAProgressStage, stageTotalBytes: Int, stageCompletedBytes: Int) {
        self.delegate?.otaManager(manager: self, stage: stage, totalBytes: stageTotalBytes, completedBytes: stageCompletedBytes)
    }
    /// 模块向Manager回调完成信息
    func otaModuleCompletion(module: SFOTAModuleBase, error: SFOTAError?) {
        clearCaches()
        self.delegate?.otaManager(manager: self, complete: error)
    }
    /// 模块通过该代理函数获取是否握手
    func otaModuleShakedHands() -> Bool {
        return bleCore.isShakedHands
    }
    
//    private func transToBleState(state:BleCoreManagerState) -> CBManagerState {
//        switch state {
//        case .unknown:
//            return .unknown
//        case .resetting:
//            return .resetting
//        case .unsupported:
//            return .unsupported
//        case .unauthorized:
//            return .unauthorized
//        case .poweredOff:
//            return .poweredOff
//        case .poweredOn:
//            return .poweredOn
//        }
//    }
    
    private func clearCaches() {
        
        bleCore.stopScan()
        currentModule?.clear()
        currentModule = nil
        targetDevIdentifier = nil
        searchTimer?.invalidate()
        searchTimer = nil
        currentModule = nil
        mtu = nil
        status = .leisure
        
    }
}
