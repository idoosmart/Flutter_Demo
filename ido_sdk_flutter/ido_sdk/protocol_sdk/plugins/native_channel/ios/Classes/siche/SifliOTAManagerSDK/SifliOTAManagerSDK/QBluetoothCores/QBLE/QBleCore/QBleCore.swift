import UIKit
import CoreBluetooth

extension CBPeripheral{
    private struct AssociationKeys {
        static var CentralIdentifierKey:String = "CentralIdentifierKey"
        static var RSSIKey:String = "RSSIKey"
    }
    var centralIdentifierId:String?{
        get{
            (objc_getAssociatedObject(self, &AssociationKeys.CentralIdentifierKey) as? String)
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.CentralIdentifierKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    func getRssi() -> NSNumber?{
        return objc_getAssociatedObject(self, &AssociationKeys.RSSIKey) as? NSNumber
    }
    
    func setRssi(rssi:NSNumber?){
        objc_setAssociatedObject(self, &AssociationKeys.RSSIKey, rssi, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

protocol QBleCoreDelegate:NSObjectProtocol {
    
    
    /// 蓝牙状态改变
    func bleCore(core:QBleCore,didUpdateState state:BleCoreManagerState)
    
    /// 发现了外设
    func bleCore(core:QBleCore,didDiscover peripheral:CBPeripheral)
    
    /// 连接失败
    func bleCore(core:QBleCore, failedToConnectPeripheral peripheral:CBPeripheral,error:QError)
    
    /// 断开连接
    func bleCore(core:QBleCore, didDisconnectPeripheral peripheral:CBPeripheral, error:QError)
    
    /// 连接成功
    func bleCore(core:QBleCore,successToConnect peripheral:CBPeripheral,handeShaked:Bool)
    
    /// 收到数据
    func bleCore(core:QBleCore,characteristic:CBCharacteristic,didUpdateValue value:Data)
    
    func bleCore(core:QBleCore,didWriteValue writeCharacteristic:CBCharacteristic,error:Error?)
}


class QBleCore: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    
    static let sharedInstance = QBleCore()
    
    var isShakedHands:Bool{
        
        return (tempPeripheral?.state == .connected && readCharacteristic != nil && writeCharacteristic != nil)
    }
    
    var isConnected:Bool{
        return tempPeripheral?.state == .connected
    }
    
    var state:BleCoreManagerState{
        return convertManagerState(stateValue: centralManager.state.rawValue)
    }
    
    var timeout = 20.0
    
    weak var delegate:QBleCoreDelegate?
    
    
    private let centralManager = CBCentralManager()
    private let uuid = UUID.init().uuidString
    
    private(set) var tempPeripheral :CBPeripheral?

    
    private(set) var writeCharacteristic:CBCharacteristic?
    private(set) var readCharacteristic:CBCharacteristic?
    
    private var shouldShakeHands:Bool = false
    private var shouldNotify:Bool = false
    private var connectTimer:Timer?
    
    // 防止因为modify service时重新开启搜索，导致重复触发连接成功的回调
    private var hasCallBackSuccess = false
    
    private var errPool = Array<QError>.init()
    
    
    func retrievePairedPeripherals() ->  [CBPeripheral]{
        let uuid = CBUUID.init(string: DeviceServiceUUID)
        QPrint("通过service(\(uuid))获取到如下已连接设备:")
        let pers = centralManager.retrieveConnectedPeripherals(withServices: [uuid])
        for p in pers{
            p.centralIdentifierId = self.uuid
            QPrint("已连接设备:\(p.identifier.uuidString)")
        }
        return pers
    }
    
    func startScan(withServicesFilter:Bool) {
        centralManager.stopScan()
        //开启搜索
        let uuids = [CBUUID(string: DeviceServiceUUID)]
        
        if withServicesFilter {
            centralManager.scanForPeripherals(withServices: uuids, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }else{
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
        
    }
    
    func stopScan() {
        centralManager.stopScan()
        
//        let allBunldes = Bundle.allBundles
//        for b in allBunldes {
//            QPrint("bundleIdentifier:\(b.bundleIdentifier ?? "空")")
//        }
        
//        let mainDic = Bundle.main.infoDictionary!
//        QPrint("main.infos:\(mainDic)")
//        let version = mainDic["CFBundleShortVersionString"]
//        let buildV = mainDic["CFBundleVersion"]
//        QPrint("main.CFBundleShortVersionString:\(version!)")
//        QPrint("main.CFBundleVersion:\(buildV!)")
//        QPrint("main.kCFBundleIdentifierKey:\(Bundle.main.bundleIdentifier!)")
    }
    
        
    func cancelConnection() {
        if let temp = tempPeripheral,(temp.state == .connected || temp.state == .connecting) {
            let err = QError.init()
            err.errType = .Canceled
            err.errInfo = "调用了cancelConnection主动断开链接"
            errPool.append(err)
            centralManager.cancelPeripheralConnection(temp)
        }
    }
    
    func connect(peripheral:CBPeripheral,withShakeHands shakeHands:Bool,withNotify notify:Bool){
        QPrint("✅握手过程(0):准备发起BLE连接（Reset CallBackSuccessTag from '\(hasCallBackSuccess)' ---> 'false'）")
        hasCallBackSuccess = false
        
        if peripheral.centralIdentifierId != self.uuid {
            let err = QError.init()
            err.errType = .Unknown
            err.errInfo = "试图连接的外设对象不是由本CenralManager管理的"
            QPrint("❌终止连接:\(err.errInfo)")
            delegate?.bleCore(core: self, failedToConnectPeripheral: peripheral, error: err)
            return
        }
        shouldShakeHands = shakeHands
        shouldNotify = notify
        readCharacteristic = nil
        writeCharacteristic = nil
        if let per = tempPeripheral,per === peripheral {
            if peripheral.state == .connected {
                peripheral.delegate = self
                if shouldShakeHands{
                    //已经链接，直接从搜索服务开始
                    QPrint("✅握手过程(0): discover services")
                    _startConnectionTimer()
                    peripheral.discoverServices(nil)
                }else{
                    //不需要握手，，直接回调成功
                    QPrint("✅握手过程(0): callBack success")
                    _stopConnTimer()
                    delegate?.bleCore(core: self, successToConnect: peripheral, handeShaked: shouldShakeHands)
                }
                
            }else if peripheral.state == .disconnected{
                QPrint("✅握手过程(0): reconnect")
                _startConnectionTimer()
                centralManager.connect(per, options: nil)
            }else{
                //不做处理
                QPrint("⚠️握手过程(0): Do Nothing!")
            }
        }else{
            if let per = tempPeripheral{
                tempPeripheral = peripheral
                if per.state == .connected || per.state == .connecting{
                    centralManager.cancelPeripheralConnection(per)
                    QPrint("✅握手过程(0): Connect Regular, But Cancel First")
                }else{
                    QPrint("✅握手过程(0): Connect Regular, But Existed Per.state=\(per.state.rawValue)")
                }
            }else {
                QPrint("✅握手过程(0): Connect Regular")
                tempPeripheral = peripheral
            }
            _startConnectionTimer()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func writeValueForWriteCharateristic(value:Data){
        if self.isShakedHands {
//            QPrint("尝试向BLE写入数据:\(NSData.init(data: value).debugDescription)")
            self.tempPeripheral?.writeValue(value, for: self.writeCharacteristic!, type: .withoutResponse)
        }else{
            QPrint("❌向'写'特征写入数据失败:没有握手")
        }
    }
    
    //MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        QPrint("蓝牙状态改变:\(central.state.rawValue)")
        let coreState = convertManagerState(stateValue: central.state.rawValue)
        delegate?.bleCore(core: self, didUpdateState: coreState)
        
        // 调用一次断开连接
        if central.state != .poweredOn && tempPeripheral != nil{
            
            var err = QError.init()
            err.errType = .Disconnected
            err.errInfo = "蓝牙被关闭了(state=\(central.state.rawValue))"
            if let e = errPool.last{
                err = e
            }
            QPrint("❌当前设备断开了连接(蓝牙状态发生改变,state=\(central.state.rawValue)):name=\(tempPeripheral!.name ?? ""),identifier=\(tempPeripheral!.identifier.uuidString)")
            delegate?.bleCore(core: self, didDisconnectPeripheral: tempPeripheral!, error: err)
            _disconnectedClearWorks()
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        QPrint("搜索到蓝牙设备, identifier=\(peripheral.identifier.uuidString)")
        peripheral.centralIdentifierId = uuid
        delegate?.bleCore(core: self, didDiscover: peripheral)
    }
    
    
    //MARK:-CBCentralManagerDelegate:连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let `tempPer` = tempPeripheral,tempPer === peripheral {
            //连接失败
            let err = QError.init()
            err.errType = .FailedToConnect
            err.errInfo = "连接失败:\(error.debugDescription)"
            errPool.append(err)
            QPrint("❌连接失败:建立BLE连接失败,\(error.debugDescription)")
            delegate?.bleCore(core: self, failedToConnectPeripheral: tempPer, error: err)
            _disconnectedClearWorks()
        }
    }
    
    //MARK:-CBCentralManagerDelegate:成功连接
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        if let `tempPer` = tempPeripheral, tempPer === peripheral {
            //开始搜索service
            tempPer.delegate = self
            if shouldShakeHands {
                QPrint("✅握手过程(1):成功建立BLE连接，开始搜索services")
                tempPer.discoverServices(nil)
            }else{
                QPrint("✅成功建立BLE连接，连接成功(不需要握手)!")
                _stopConnTimer()
                delegate?.bleCore(core: self, successToConnect: tempPer, handeShaked: false)
            }
            
        }else{
            //不是当前的设备,直接断开
            QPrint("尝试断开链接: 已连接设备(\(peripheral.identifier.uuidString)不是当前设备")
            central.cancelPeripheralConnection(peripheral)
        }
    }
    
    //MARK:-CBCentralManagerDelegate:断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        let name = peripheral.name ?? ""
        let identifier = peripheral.identifier.uuidString
        
        if let e = error {
            QPrint("[蓝牙断开SysError]\(e)")
        }else{
            QPrint("[蓝牙断开SysError] 空")
        }
        
        //断开了链接
        if let tempPer = tempPeripheral, tempPer === peripheral {
            
            var err = QError.init()
            err.errType = .Disconnected
            err.errInfo = "断开了蓝牙连接"
            if let e = error {
                err.errInfo = "\(err.errInfo)(\(e))"
            }
            if let e = errPool.last{
                err = e
            }
            QPrint("❌当前设备断开了连接:name=\(name),identifier=\(identifier),reason:\(err)")
            _disconnectedClearWorks()
            delegate?.bleCore(core: self, didDisconnectPeripheral: tempPer, error: err)
        }else{
            QPrint("⚠️非当前设备断开了连接:name=\(name),identifier=\(identifier)")
        }
    }
    
    //MARK:-CBPeripheralDelegate:找到service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let `tempPer` = tempPeripheral, tempPer === peripheral{
            QPrint("✅握手过程(2):发现services,开始搜索Characteristics")
            for service in peripheral.services ?? []{
                tempPer.discoverCharacteristics(nil, for: service)
            }
        }else{
            //其它设备的回调，直接断开
            QPrint("⚠️尝试断开链接: 其它外设(\(peripheral.identifier.uuidString))didDiscoverServices")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for ch in service.characteristics ?? []{
            QPrint("All Discovered: service:\(service.uuid.uuidString),characteristic:\(ch.uuid.uuidString)")
        }

        
        if let `tempPer` = tempPeripheral, tempPer === peripheral{

            for ch in service.characteristics ?? []{
                QPrint("service:\(service.uuid.uuidString),characteristic:\(ch.uuid.uuidString)")
                if ch.uuid.uuidString == WriteCharacteristicUUID {
                    self.writeCharacteristic = ch
                    self.readCharacteristic = ch
                    if shouldNotify == true {
                        QPrint("✅握手过程(3):已成功获取到'读'、'写'，准备监听'读'特征:\(ch.briefDes())")
                        if ch.isNotifying {
                            // 已经处于Notifying状态直接回调连接成功
                            QPrint("✅✅Core握手成功(isNotifying=\(ch.isNotifying))")
                            if let timer = self.connectTimer {
                                timer.invalidate()
                            }
                            self.connectTimer = nil
                            if hasCallBackSuccess{
                                QPrint("⚠️⚠️已经触发过连接成功回调，忽略该握手成功(已订阅)的消息")
                            }else {
                                hasCallBackSuccess = true
                                delegate?.bleCore(core: self, successToConnect: peripheral, handeShaked: shouldShakeHands)
                            }
                        }else{
                            tempPer.setNotifyValue(true, for: ch)
                        }
                    }else{
                        QPrint("✅✅Core握手成功(未订阅)")
                        if let timer = self.connectTimer {
                            timer.invalidate()
                        }
                        self.connectTimer = nil
                        if hasCallBackSuccess{
                            QPrint("⚠️⚠️已经触发过连接成功回调，忽略该握手成功(未订阅)的消息")
                        }else {
                            hasCallBackSuccess = true
                            delegate?.bleCore(core: self, successToConnect: peripheral, handeShaked: shouldShakeHands)
                        }
                    }
                }
            }
        }else{
            QPrint("⚠️尝试断开链接:其它外设(\(peripheral.identifier.uuidString))的特征回调")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let writeCh = self.writeCharacteristic {
            self.delegate?.bleCore(core: self, didWriteValue: writeCh, error: error)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let `tempPer` = tempPeripheral,tempPer === peripheral{

            if characteristic === self.readCharacteristic {
                if characteristic.isNotifying {
                    if characteristic.properties.rawValue & CBCharacteristicProperties.notify.rawValue != 0 {
                        QPrint("✅✅Core握手成功:成功订阅'读'特征!!!")
                        if let timer = self.connectTimer {
                            timer.invalidate()
                        }
                        self.connectTimer = nil
                        if hasCallBackSuccess{
                            QPrint("⚠️⚠️已经触发过连接成功回调，忽略该握手成功的消息")
                        }else {
                            hasCallBackSuccess = true
                            delegate?.bleCore(core: self, successToConnect: peripheral, handeShaked: shouldShakeHands)
                        }
                    }
//                    if characteristic.properties.rawValue & CBCharacteristicProperties.read.rawValue != 0{
//                        //有数据更新
//                        tempPer.readValue(for: characteristic)
//                    }
                }else{
                    //读特征关闭了广播，发起断开链接
                    if tempPer.state == .connected || tempPer.state == .connecting{
                        QPrint("⚠️尝试断开链接:外设(\(tempPer.identifier.uuidString))的读特征停止了广播")
                        centralManager.cancelPeripheralConnection(tempPer)
                    }else if tempPer.state == .disconnected{
                        _disconnectedClearWorks()
                    }
                }
            }

        }else{
            //其它外设，直接断开
            QPrint("⚠️尝试断开链接:其它外设(\(peripheral.identifier.uuidString))didUpdateNotificationState")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let per = tempPeripheral,per === peripheral {

            if characteristic === self.readCharacteristic {
                if let value = characteristic.value {
                    let data = NSData.init(data: value)
                    QPrint("📩'读'特征收到数据:\(data.debugDescription)")
                    delegate?.bleCore(core: self, characteristic: characteristic, didUpdateValue: value)
                }else{
                    QPrint("⚠️'读'特征收到数据为nil")
                }
            }else{
                var dataDes = "空"
                if let value = characteristic.value {
                    let data = NSData.init(data: value)
                    dataDes = data.debugDescription
                }
                QPrint("⚠️其它特征(\(characteristic.uuid.uuidString))收到数据:\(dataDes)")
            }
        }else{
            QPrint("⚠️尝试断开链接:其它外设(\(peripheral.identifier.uuidString))didUpdateValue")
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        QPrint("更新数据:\(descriptor.value.debugDescription)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        QPrint("改变service:\(invalidatedServices)")
        let isCurrentPer = (peripheral === tempPeripheral)
        if (isCurrentPer && peripheral.state == .connected) {
            QPrint("尝试重新搜索Service")
            peripheral.discoverServices(nil)
        }else{
            QPrint("⚠️忽略Service Modify事件。(isCurrentPer=\(isCurrentPer), state=\(state)(\(state.rawValue))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        QPrint("didDiscoverDescriptorsFor:\(characteristic)")
        if let e = error{
            QPrint("didDiscoverDescriptorsFor Error:\(e)")
        }
    }
    
    private override init() {
        super.init()
        centralManager.delegate = self
    }
    
    
    private func _startConnectionTimer() {
        if connectTimer != nil{
            connectTimer!.invalidate()
        }
        if timeout>0{
            connectTimer = Timer.init(timeInterval: timeout, target: self, selector: #selector(connectTimeout(timer:)), userInfo: nil, repeats: false)
            RunLoop.main.add(connectTimer!, forMode: RunLoop.Mode.default)
        }
    }
    
    private func _stopConnTimer(){
        if self.connectTimer != nil{
            self.connectTimer?.invalidate()
        }
        self.connectTimer = nil
    }
    
    @objc private func connectTimeout(timer:Timer) {
        
        if let temp = tempPeripheral {
            let err = QError.init()
            err.errType = .Timeout
            err.errInfo = "连接超时了(大于了\(timeout)秒)"
            errPool.append(err)
            
            if temp.state == .connected || temp.state == .connecting {
                //正在连接或者已经连接的情况下，需要调用断连方法，在didDisconnect里面进行回调
                QPrint("❌连接超时(\(timeout)秒),尝试断开已经连接(或正在连接)的外设,state=\(temp.state)")
                centralManager.cancelPeripheralConnection(temp)
            }else{
                //直接回调
                QPrint("❌连接超时(\(timeout)秒),当前外设state=\(temp.state)")
                delegate?.bleCore(core: self, failedToConnectPeripheral: temp, error: err)
                _disconnectedClearWorks()
            }
        }
    }
    
    private func convertManagerState(stateValue:Int) -> BleCoreManagerState {
        switch stateValue{
        case 0:
            return .unknown
        case 1:
            return .resetting
        case 2:
            return .unsupported
        case 3:
            return .unauthorized
        case 4:
            return .poweredOff
        case 5:
            return .poweredOn
        default:
            fatalError("❌没有被匹配到的CBManagerStateValue:\(state.rawValue)")
        }
    }
    
    private func _disconnectedClearWorks() {
        tempPeripheral = nil
        writeCharacteristic = nil
        readCharacteristic = nil
        hasCallBackSuccess = false
        errPool.removeAll()
    }
    
    

}
