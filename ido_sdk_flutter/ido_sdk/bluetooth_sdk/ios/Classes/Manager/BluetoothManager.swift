//
//  IDOBluetoothManager.swift
//  flutter_blue_plus
//
//  Created by lux on 2022/8/24.
//

import UIKit
import CoreBluetooth

class BluetoothManager: NSObject {
    static let singleton = BluetoothManager();
    lazy var manager: CBCentralManager = {
        let options: [String : Any] = [
            CBCentralManagerOptionShowPowerAlertKey : true,
            CBCentralManagerOptionRestoreIdentifierKey : "IDOBluetoothStrapRestoreIdentifier"
        ]
        let manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main, options: options)
        return manager
    }();
    
    // 平台
    var platform = 0;
    // 设备芯片平台
    var devicePlatform = 0;
    var serviceIndex = 0;

    //    扫描到的设备
    var peripheralDic: [String:CBPeripheral] = [:]
    // 通知服务特征集合
    var notifyCharacteristics: [CBCharacteristic] = []
    //    var deviceCurrent : CBPeripheral?;
    let channel = SwiftFlutterBluetoothPlugin.channel
    var characteristic: Characteristic? = Characteristic()
    //    本地保存设备
    let localDevices = LocalScan()
    private var commandQueue: [(Data,CBPeripheral?,CBCharacteristic,CBCharacteristicWriteType)] = [] // 保存要发送的指令队列
    private var sendTimer: Timer? // 定时器用于控制发送间隔
    private let sendInterval: TimeInterval = 0.01 // 10ms
    private var isNeedPair = false // 是否需要配对
    private var isHas0AF8 = false // 特征值是否有0AF8
    private var isBind = false // 设备是否绑定
    private(set) var setNotifyValueSuccess = false //设置通知使能成功
    private var set0AF7NotifyValueSuccess = false //设置0AF7通知使能成功
    private var set0AF2NotifyValueSuccess = false //设置0AF2通知使能成功

    private var isIntercept = false // 是否拦截取消断连回调
    
    // 定义响应结构体
    struct IDOReadChar0AF8Response {
        var enc_enable: UInt8 = 0
        var pair_magic: UInt32 = 0
        var pair_flag: UInt8 = 0
        var is_support_repeat_pair: UInt8 = 0
    }
    
    
    func addCommandToQueue(_ command: Data,peripheral:CBPeripheral?,characteristic:CBCharacteristic,writeType:CBCharacteristicWriteType) {
        // 将指令加入发送队列
        commandQueue.append((command,peripheral,characteristic,writeType))
    }
    
    func startSendingCommands() {
        // 停止之前的定时器
        stopSendingCommands()
        
        // 创建定时器
        sendTimer = Timer.scheduledTimer(withTimeInterval: sendInterval, repeats: true) { [weak self] _ in
            self?.sendNextCommand()
        }
    }
    
    
    func stopSendingCommands() {
        // 停止定时器
        sendTimer?.invalidate()
        sendTimer = nil
    }
    
    private func sendNextCommand() {
        guard !commandQueue.isEmpty else {
            stopSendingCommands()
            return
        }
        // 从队列中取出第一个指令并发送
        let command = commandQueue.removeFirst()
        let (data,peripheral,characteristic,writeType) = command
        processNextCommand(data: data, peripheral: peripheral, characteristic: characteristic, writeType: writeType)
    }
    
    func send(data: Data,peripheral:CBPeripheral?,characteristic:CBCharacteristic,writeType:CBCharacteristicWriteType) {
        addCommandToQueue(data,peripheral: peripheral,characteristic: characteristic,writeType: writeType)
        startSendingCommands()
    }
    
    func processNextCommand(data: Data,peripheral:CBPeripheral?,characteristic:CBCharacteristic,writeType:CBCharacteristicWriteType) {
        
        peripheral?.writeValue(data, for: characteristic, type: writeType)
        var msg = ""
        if (data.count > 30) {
            msg = data.prefix(30).hexString + "..."
        }else {
            msg = data.hexString
        }
        writeLog("processNextCommand:  \(msg) commandWriteType: \(writeType)",method: "processNextCommand",className:"BluetoothManager")
        
    }
    
    func scan(_ mac: String?){
        systemScan(mac)
        manager.delegate = self
        if manager.isScanning {stopScan()}
        let option = [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber.init(value: false)]
        manager.scanForPeripherals(withServices: Information.singleton.servicesUUID, options: option)
    }
    
    private func systemScan(_ mac: String?){
        writeLog("getKeychainList  \(String(describing: localDevices.getKeychainList()))", method: "systemScan", className:"BluetoothManager")
        localDevices.findSystemList(mac)?.forEach({
            writeLog("findSystemDevice " + String(describing: $0.name) + $0.identifier.uuidString,method: "systemScan",className:"BluetoothManager")
            peripheralDic[$0.identifier.uuidString] = $0
            if let macAdr = localDevices.getKeychainList()?[$0.identifier.uuidString]{
                peripheralDic[macAdr] = $0
            }
            let device = Device.init(peripheral: $0, macAdr: localDevices.keychainList?[$0.identifier.uuidString])
            let deviceDic = device.toDict()
            if let _ = device.macAddress,let _ = device.name {
                writeLog("systemScan name = " + device.name! + "macAddress = " + device.macAddress!, method: "systemScan", className:"BluetoothManager")
                channel?.invokeMethod("scanResult", arguments: deviceDic)
            }
        })
    }
    
    func stopScan(){
        manager.stopScan()
    }
    
    func connect(_ device: Device){
        self.isIntercept = false
        guard let p = getPeripheral(device) else{
            writeLog("connect no device find", method: "connect", className:"BluetoothManager")
            return
        }
        self.devicePlatform = device.platform ?? 0
        // 查询设备绑定状态
        self.isBind = device.isBind ?? false
        writeLog("connect device name = " + String(describing: device.name) + " macAddress = " + String(describing: device.macAddress) + " devicePlatform: \(self.devicePlatform)  isBind:\(self.isBind)", method: "connect", className:"BluetoothManager")
        manager.delegate = self;
        manager.connect(p, options: nil)
        
    }
    
    func cancelConnect(_ device: Device){
        guard let p = getPeripheral(device) else{
            writeLog("cancelConnect no device find", method: "cancelConnect", className:"BluetoothManager")
            return
        }
        self.devicePlatform = 0
        manager.cancelPeripheralConnection(p)
        writeLog("cancel connection device name = " + String(describing: device.name) + " macAddress = " + String(describing: device.macAddress) , method: "cancelConnect", className:"BluetoothManager")

    }

    private func disConnect (_ peripheral: CBPeripheral ){
        self.devicePlatform = 0
        manager.cancelPeripheralConnection(peripheral)
        writeLog("disConnect peripheral uuidString = \(peripheral.identifier.uuidString)" , method: "disConnect", className:"BluetoothManager")
    }

    
    func deviceState(_ device: Device) -> CBPeripheralState{
        guard let p = getPeripheral(device) else{
            writeLog("deviceState no device find", method: "deviceState", className:"BluetoothManager")
            return CBPeripheralState.disconnected
        }
        
        if p.state == .connected {
            return self.setNotifyValueSuccess ? .connected : .disconnected

        }
        return p.state
    }
    
    func getServicesUUID(dict: Dictionary<String, Any>){
        guard let u = dict["UUID"] as? [String: Any], let uuids = u["UUID"] as? [String] else {
            writeLog("Null servicesUUID", method: "getServicesUUID", className:"BluetoothManager")
            return
        }
        Information.singleton.servicesUUID = uuids.map{CBUUID.init(string: $0)}
    }
    
    func getCharacteristics(dict: Dictionary<String, Any>){
        guard let uuids = dict["CharacteristicsUUID"] as? Dictionary<String,Any> else {
            writeLog("Null CharacteristicsUUID", method: "getCharacteristics", className:"BluetoothManager")
            return
        }
        characteristic?.uuid = uuids.toModel(CharacteristicUUID.self)
    }
    
    //    通过services判断是否OTA
    func isOtaWithServices(peripheral: CBPeripheral){
        if  let uuids = peripheral.services?.map({$0.uuid.uuidString}){
            channel?.invokeMethod(MethodChannel.isOtaWithServices.rawValue, arguments: ["uuid":peripheral.identifier.uuidString,"macAddress":"","servicesUUID":uuids])
        }
    }
    
    func setCharacteristics(_ p: CBPeripheral, _ c: CBService) {

        c.characteristics?.forEach{
            if let command = characteristic?.uuid?.command, $0.uuid.isEqual(CBUUID.init(string:command)) {
                writeLog("设置IDO命令服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                characteristic?.command = $0
            }else if let health = characteristic?.uuid?.health, $0.uuid.isEqual(CBUUID.init(string:health)){
                writeLog("设置IDO健康服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                characteristic?.health = $0
            }else if let read = characteristic?.uuid?.read, $0.uuid.isEqual(CBUUID.init(string:read)){
                writeLog("设置IDO读取服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                p.readValue(for: $0)
            }else if let henxuan = characteristic?.uuid?.henXuanSend, $0.uuid.isEqual(CBUUID.init(string:henxuan)) {
                writeLog("设置为恒玄的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                characteristic?.henXuan = $0
                platform = 1
            }else if let vc = characteristic?.uuid?.vcSend, $0.uuid.isEqual(CBUUID.init(string:vc)) {
                writeLog("设置为vc的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                characteristic?.vc = $0
                platform = 2
            }else if checkHadCharacteristic($0.uuid){
                writeLog("设置为通知的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                p.setNotifyValue(true, for: $0)
                notifyCharacteristics.append($0)
            }
        }
    }
    
    func checkHadCharacteristic(_ uuid: CBUUID) -> Bool {
        if let result = (characteristic?.uuid?.notify?.map({CBUUID.init(string: $0)}).contains(uuid)){
            return result
        }
        return false
    }
    
    // 关闭所有蓝牙通知 （固件需要知道已杀死App）
    func setCloseNotifyCharacteristic(_ device: Device) {
        guard let p = getPeripheral(device) else{
            writeLog("set close notify characteristic no device find",
                     method: "setCloseNotifyCharacteristic", className:"BluetoothManager")
            return
        }
        notifyCharacteristics.forEach({
            writeLog("关闭通知的服务 \($0)", method: "setCloseNotifyCharacteristic", className:"BluetoothManager")
            p.setNotifyValue(false, for: $0)
        })
    }
    
    func write(_ message: WriteMessage) {
        let p = getPeripheral(Device.init(uuid: message.uuid, macAddress: message.macAddress))
        guard message.writeType == 1 || message.writeType == 0 else {
            writeLog("null write characteristic", method: "write", className:"BluetoothManager")
            return
        }
        if (message.platform == 1) {
            // 走恒玄服务发送数据
            guard let command = characteristic?.henXuan else {
                writeLog("null hen xuan command characteristic", method: "write", className:"BluetoothManager")
                return
            }
            if let data = message.data {
                let writeType = CBCharacteristicWriteType.withoutResponse
                //p?.writeValue(data, for: command, type: writeType)
                send(data: data, peripheral: p, characteristic: command, writeType: writeType)
            }
        } else if (message.platform == 2) {
            // 走vc服务发送数据
            guard let command = characteristic?.vc else {
                writeLog("null vc command characteristic", method: "write", className:"BluetoothManager")
                return
            }
            if let data = message.data {
                let writeType =  CBCharacteristicWriteType(rawValue: message.writeType) ?? CBCharacteristicWriteType.withoutResponse
                p?.writeValue(data, for: command, type: writeType)
            }
        } else {
            // 走爱都服务发送数据
            guard let command = message.command == 0 ? characteristic?.command : characteristic?.health else{
                writeLog("null ido command characteristic", method: "write", className:"BluetoothManager")
                return
            }
            if let data = message.data {
                let writeType =  CBCharacteristicWriteType(rawValue: message.writeType) ?? CBCharacteristicWriteType.withoutResponse
                p?.writeValue(data, for: command, type: writeType)
                //#if DEBUG
                var msg = ""
                if (data.count > 30) {
                    msg = data.prefix(30).hexString + "..."
                }else {
                    msg = data.hexString
                }
                writeLog("\(msg)", method: "write", className:"BluetoothManager")
                //#endif
                
            }
        }
    }
    
    func getPeripheral(_ device: Device) -> CBPeripheral? {
        if peripheralDic.isEmpty {
            writeLog("peripheral list is null", method: "getPeripheral", className:"BluetoothManager")
            systemScan(device.macAddress)
            return nil;
        }
        if let p = getOnePeripheral(device) {
            return p
        }
        writeLog("not find peripheral == \(String(describing: device.macAddress))", method: "getPeripheral", className:"BluetoothManager")
        systemScan(device.macAddress)
        return getOnePeripheral(device)
    }
    
    func getOnePeripheral(_ device: Device) -> CBPeripheral? {
        if let uuid = device.uuid, let p = peripheralDic[uuid] {
            return p;
        }
        if let macAddress = device.macAddress, let p = peripheralDic[macAddress] {
            return p;
        }
        return nil
    }
    
    func requestMacAddress(uuid: String, macAddress: String){
        localDevices.keychainList?[uuid] = macAddress
        localDevices.save()
        if let p = getPeripheral(Device.init(uuid: uuid, macAddress: macAddress)) {
            peripheralDic[macAddress] = p;
        }
    }
}

extension BluetoothManager : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        writeLog("centralManagerDidUpdateState = " + String(central.state.rawValue), method: "centralManagerDidUpdateState", className:"BluetoothManager");
        if let sink = SwiftFlutterBluetoothPlugin.instance.eventSink{
            sink(["state": NSNumber(value: central.state.rawValue)])
        }
        //        if central.state == .poweredOff {
        //            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(nil,.bluetoothOff))
        //        }
        if(central.state == .poweredOff)
        {
            self.setNotifyValueSuccess = false
            self.set0AF2NotifyValueSuccess = false
            self.set0AF7NotifyValueSuccess = false
            self.isIntercept = false
            commandQueue.removeAll()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let _ = peripheral.name else{
            return;
        }
        peripheralDic[peripheral.identifier.uuidString] = peripheral
        let model = Device.init(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI)
        if let arg = model.toDictExpand(advertisementData: advertisementData){
            writeLog("ios scanResult = " + String(describing: model.name) + String(describing: model.macAddress) + String(describing: model.uuid), method: "didDiscover", className: "BluetoothManager_ios");
            channel?.invokeMethod("scanResult", arguments: arg)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        if self.isBind && (self.devicePlatform == 98 || self.devicePlatform == 99)
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                peripheral.discoverServices(nil)
            }
            writeLog("didConnect asyncAfter discoverServices", method: "didConnect", className: "BluetoothManager_ios");
        }else
        {
            peripheral.discoverServices(nil)
        }
        
        platform = 0;
        self.isIntercept = false
        writeLog("didConnect = " + String(describing: peripheral.name) + String(describing: peripheral.identifier.uuidString), method: "didConnect", className: "BluetoothManager_ios");
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        var errorType: ConnectError = .fail
        if let localizedDescription = error?.localizedDescription{
            writeLog("didFailToConnect - " + peripheral.identifier.uuidString + " - " + localizedDescription, method: "didFailToConnect", className:"BluetoothManager")
        }
        if error?.localizedDescription == "Peer removed pairing information" {
            errorType = .pairFail
        }
        self.devicePlatform = 0
        channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,errorType,platform))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        writeLog("didDisconnectPeripheral - " + peripheral.identifier.uuidString + " - " + (error?.localizedDescription ?? ""), method: "didDisconnectPeripheral", className:"BluetoothManager")
        commandQueue.removeAll()
        self.devicePlatform = 0
        self.setNotifyValueSuccess = false
        self.set0AF2NotifyValueSuccess = false
        self.set0AF7NotifyValueSuccess = false
        if let _ = error{
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.fail,platform))
        }else{
            if self.isIntercept {
                self.isIntercept = false
                self.writeLog("不支持重复绑定，主动调用了断连，拦截断连回调" + " isIntercept:\(self.isIntercept)", method: "didDisconnectPeripheral", className:"BluetoothManager")
            }else{
                channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.Conectcancel,platform))

            }

        }
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
}

extension BluetoothManager : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        self.isNeedPair = false
        self.isHas0AF8 = false
        if let e = error {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didDiscoverServices", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.ServiceFial,platform))
            return
        }else if peripheral.services?.count == 0 {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + "error: services.count = 0", method: "didDiscoverServices", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.ServiceFial,platform))
            return
        }
        notifyCharacteristics.removeAll()
        serviceIndex = 0;
        writeLog("didDiscoverServices", method: "didDiscoverServices", className: nil)
        peripheral.services?.forEach({ service in
            print("【QCFit】【发现服务】\(service) \(service.uuid.uuidString)")
            writeLog("didDiscoverServices - " + "【QCFit】【发现服务】\(service) \(service.uuid.uuidString)" , method: "didDiscoverServices", className: nil)
        })
        peripheral.services?.forEach{peripheral.discoverCharacteristics(nil, for: $0)}
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let e = error {
            writeLog("didDiscoverCharacteristicsFor - " + peripheral.identifier.uuidString + "   service:" + service.uuid.uuidString + " - " + e.localizedDescription, method: "didDiscoverCharacteristicsFor", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.CharacteristicsFial,platform))
            return
        }
        serviceIndex += 1
        isOtaWithServices(peripheral: peripheral)
       
        // 查找0AF8 读取特征值
        if let characteristics = service.characteristics {
            for chars in characteristics {
                if chars.uuid.isEqual(CBUUID(string: "0AF8")){
                    isHas0AF8 = true
                    peripheral.readValue(for: chars)
                    break
                }
            }
        }
        if isHas0AF8 {
           
        }else
        {
            self.setNotifyValueSuccess = false
            // 此处才算正在连接设备成功，要不然前面连接成功设备，特征服务未发现无法操作数据
            setCharacteristics(peripheral, service)
            if peripheral.services?.count == serviceIndex {
                self.setNotifyValueSuccess = true
                channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.none,platform))
                writeLog("didDiscoverCharacteristicsFor - connectSucceed", method: "didDiscoverCharacteristicsFor", className: nil)
            }
        }
        
    }
    
    func callDevicePair(_ pair:Bool,peripheral:CBPeripheral) {
        if pair {
            self.isNeedPair = true
            self.setNotifyValueSuccess = false
            self.set0AF2NotifyValueSuccess = false
            self.set0AF7NotifyValueSuccess = false
            //设置通知使能
            if let services = peripheral.services {
                for service in services{
                    self.setCharacteristics(peripheral, service)
                }
            }
            
        }else
        {
            self.setNotifyValueSuccess = false
            // 此处才算正在连接设备成功，要不然前面连接成功设备，特征服务未发现无法操作数据
            if let services = peripheral.services {
                for service in services{
                    self.setCharacteristics(peripheral, service)
                }
            }
            if peripheral.services?.count == self.serviceIndex {
                self.setNotifyValueSuccess = true
                self.channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.none,self.platform))
                self.writeLog("didDiscoverCharacteristicsFor - connectSucceed", method: "didDiscoverCharacteristicsFor", className: nil)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        if !isNeedPair {
            return;
        }
            
        if characteristic.uuid.isEqual(CBUUID(string: "0AF7")){
            if let er = error {
                self.set0AF7NotifyValueSuccess = false
                self.setNotifyValueSuccess = false
                // 通知使能失败，断线重新发起连接
                writeLog("didUpdateNotificationStateFor [0AF7] - fail", method: "didUpdateNotificationStateFor", className: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.disConnect(peripheral)
                }
                //                 channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.fail,platform))
            }else{
                self.set0AF7NotifyValueSuccess = true
                writeLog("didUpdateNotificationStateFor [0AF7] - success", method: "didUpdateNotificationStateFor", className: nil)

            }
        }
        
        if characteristic.uuid.isEqual(CBUUID(string: "0AF2")){
            if let er = error {
                self.set0AF2NotifyValueSuccess = false
                self.setNotifyValueSuccess = false
                // 通知使能失败，断线重新发起连接
                writeLog("didUpdateNotificationStateFor [0AF2] - fail", method: "didUpdateNotificationStateFor", className: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.disConnect(peripheral)
                }
                //                 channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.fail,platform))
            }else{
                self.set0AF2NotifyValueSuccess = true
                writeLog("didUpdateNotificationStateFor [0AF2] - success", method: "didUpdateNotificationStateFor", className: nil)

            }
        }

        if self.set0AF7NotifyValueSuccess && self.set0AF2NotifyValueSuccess {
        
            self.setNotifyValueSuccess = true
            // 通知使能成功
            writeLog("didUpdateNotificationStateFor - success", method: "didUpdateNotificationStateFor", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.none,platform))
            
            
        }

      
    }
    
    //数据接收
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            writeLog("didUpdateValueFor error - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didUpdateValueFor", className: nil)
            return
        }
        if characteristic.value == nil || characteristic.value!.isEmpty{
            writeLog("didUpdateValueFor empty data", method: "didUpdateValueFor", className: nil);
            return
        }
        var platform = 0
        if let notify = self.characteristic?.uuid?.henXuanNotify, characteristic.uuid.isEqual(CBUUID.init(string:notify)) {
            platform = 1
        }else if let notify1 = self.characteristic?.uuid?.vcNotify, characteristic.uuid.isEqual(CBUUID.init(string:notify1)) {
            platform = 2
        }
        //#if DEBUG
        if (platform == 0) {
            var msg = ""
            if (characteristic.value!.count > 30) {
                msg = characteristic.value!.prefix(30).hexString + "..."
            }else {
                msg = characteristic.value!.hexString
            }
            writeLog("\(msg)", method: "receiveData", className:"BluetoothManager")
        }
        
        if characteristic.uuid.isEqual(CBUUID(string: "0AF8")){
            
            
            // 获取特征值数据
            guard let data = characteristic.value else { return }
            let dataLength = data.count
            
            // 构建日志字符串
            var logStr = ""
            data.forEach { byte in
                logStr += String(format: "%02X ", byte)
            }
            logStr = "{length = \(dataLength), bytes = \(logStr)}"
            self.writeLog("\(logStr)", method: "receiveData 0AF8:", className:"BluetoothManager")
            // 解析字节数据
            let bytes = [UInt8](data)
            
            
            var resp = IDOReadChar0AF8Response()
            
            // 解析数据 (注意小端模式)
            resp.enc_enable = bytes[0]
            resp.pair_magic = UInt32(bytes[1])        // LSB (最低有效字节)
            | (UInt32(bytes[2]) << 8)
            | (UInt32(bytes[3]) << 16)
            | (UInt32(bytes[4]) << 24)            // MSB (最高有效字节)
            resp.pair_flag = bytes[5]
            resp.is_support_repeat_pair = bytes[6]
            
            // 打印解析结果
            let respLogStr = String(format: "enc_enable: 0x%02X pair_magic: 0x%08X pair_flag: %d is_support_repeat_pair: %d",
                                    resp.enc_enable, resp.pair_magic, resp.pair_flag, resp.is_support_repeat_pair)
            self.writeLog("\(respLogStr)", method: "receiveData 0AF8:", className:"BluetoothManager")
            
            // 处理业务逻辑
            if resp.enc_enable == 0 {
                if resp.pair_magic == 0x14725836 {
                    if resp.pair_flag == 0 {
                        if isBind {
                            // 通知删除设备
                            self.writeLog("app 端设备是绑定状态，但是设备端重置了 通知删除设备", method: "receiveData 0AF8:", className:"BluetoothManager")
                            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.deviceHasBeenReset,platform))
                            
                        } else {
                            // 触发配对
                            self.callDevicePair(true, peripheral: peripheral)
                            self.writeLog("触发配对", method: "receiveData 0AF8:", className:"BluetoothManager")
                            
                        }
                    } else {
                        if isBind || (!isBind && resp.is_support_repeat_pair != 0) {
                            // 已绑定或支持重复绑定
                            self.callDevicePair(true, peripheral: peripheral)
                            self.writeLog("已绑定或支持重复绑定 不触发配对", method: "receiveData 0AF8:", className:"BluetoothManager")
                            
                            return
                        }
                        
                        if !isBind && resp.is_support_repeat_pair == 0 {
                            
                            // 不支持重复绑定
                            self.isIntercept = true
                            self.writeLog("不支持重复绑定" + " isIntercept:\(self.isIntercept)", method: "receiveData 0AF8:", className:"BluetoothManager")
                            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.deviceAlreadyBindAndNotSupportRebind,platform))
                            disConnect(peripheral)
                            return
                        }

                    }
                } else {
                    // 使用旧模式，不配对
                    self.callDevicePair(false, peripheral: peripheral)
                    self.writeLog("使用旧模式，不配对", method: "receiveData 0AF8:", className:"BluetoothManager")
                    
                }
            }
            
            
        }else
        {
            //#endif
            let message = Message.init(data: characteristic.value,
                                       uuid: peripheral.identifier.uuidString,
                                       macAddress: localDevices.getMacAddress(uuid: peripheral.identifier.uuidString),
                                       platform: platform)
            channel?.invokeMethod(MethodChannel.receiveData.rawValue, arguments: message.toDict())
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        var isSuccess: Bool = true
        if let e = error {
            isSuccess = false
            writeLog("didWriteValueFor error - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didWriteValueFor", className: nil);
        }
        channel?.invokeMethod(MethodChannel.sendState.rawValue, arguments: ["uuid":peripheral.identifier.uuidString, "macAddress":localDevices.getMacAddress(uuid: peripheral.identifier.uuidString), "state":NSNumber.init(value: isSuccess)])
    }
    
    //    写日志
    func writeLog(_ detail: String, method: String,className: String?){
        let json: [String : Any] = [
            "platform" : 1, //1 ios  2 android 3 flutter;
            "className" : className ?? "BluetoothManager",
            "method" : method,
            "detail" : detail,]
        channel?.invokeMethod(MethodChannel.writeLog.rawValue, arguments: json);
    }
}
