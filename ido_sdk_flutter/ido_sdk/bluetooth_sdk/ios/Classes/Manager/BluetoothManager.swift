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
        guard let p = getPeripheral(device) else{
            writeLog("connect no device find", method: "connect", className:"BluetoothManager")
            return
        }
        self.devicePlatform = device.platform ?? 0
        writeLog("connect device name = " + String(describing: device.name) + " macAddress = " + String(describing: device.macAddress) + " devicePlatform: \(self.devicePlatform)", method: "connect", className:"BluetoothManager")
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
    }
    
    func deviceState(_ device: Device) -> CBPeripheralState{
        guard let p = getPeripheral(device) else{
            writeLog("deviceState no device find", method: "deviceState", className:"BluetoothManager")
            return CBPeripheralState.disconnected
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
        if self.devicePlatform == 98 || self.devicePlatform == 99 
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
        if let _ = error{
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.fail,platform))
        }else{
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.Conectcancel,platform))
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
}

extension BluetoothManager : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
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
        // 此处才算正在连接设备成功，要不然前面连接成功设备，特征服务未发现无法操作数据
        setCharacteristics(peripheral, service)
        if peripheral.services?.count == serviceIndex {
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.none,platform))
            writeLog("didDiscoverCharacteristicsFor - connectSucceed", method: "didDiscoverCharacteristicsFor", className: nil)
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
        //#endif
        let message = Message.init(data: characteristic.value,
                                   uuid: peripheral.identifier.uuidString,
                                   macAddress: localDevices.getMacAddress(uuid: peripheral.identifier.uuidString),
                                   platform: platform)
        channel?.invokeMethod(MethodChannel.receiveData.rawValue, arguments: message.toDict())
        
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
