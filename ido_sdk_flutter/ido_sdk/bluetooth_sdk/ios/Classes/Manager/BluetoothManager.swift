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
    
    var serviceIndex = 0;
//    扫描到的设备
    var peripheralDic: [String:CBPeripheral] = [:]
//    var deviceCurrent : CBPeripheral?;
    let channel = SwiftFlutterBluetoothPlugin.channel
    var characteristic: Characteristic? = Characteristic()
//    本地保存设备
    let localDevices = LocalScan()
    
    func scan(){
        systemScan()
        manager.delegate = self
        if manager.isScanning {stopScan()}
        let option = [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber.init(value: false)]
        manager.scanForPeripherals(withServices: Information.singleton.servicesUUID, options: option)
    }
    
    private func systemScan(){
        writeLog("getKeychainList  \(String(describing: localDevices.getKeychainList()))", method: "systemScan", className:"BluetoothManager")
        localDevices.findSystemList()?.forEach({
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
        writeLog("connect device name = " + String(describing: device.name) + "macAddress = " + String(describing: device.macAddress), method: "connect", className:"BluetoothManager")
        manager.delegate = self;
        manager.connect(p, options: nil)
    }
    
    func cancelConnect(_ device: Device){
        guard let p = getPeripheral(device) else{
            writeLog("cancelConnect no device find", method: "cancelConnect", className:"BluetoothManager")
            return
        }
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
                characteristic?.command = $0
            }else if let health = characteristic?.uuid?.health, $0.uuid.isEqual(CBUUID.init(string:health)){
                characteristic?.health = $0
            }else if let read = characteristic?.uuid?.read, $0.uuid.isEqual(CBUUID.init(string:read)){
                p.readValue(for: $0)
            }else if checkHadCharacteristic($0.uuid){
                p.setNotifyValue(true, for: $0)
            }
        }
    }
    
    func checkHadCharacteristic(_ uuid: CBUUID) -> Bool {
        if let result = (characteristic?.uuid?.notify?.map({CBUUID.init(string: $0)}).contains(uuid)){
            return result
        }
        return false
    }
    
    func write(_ message: WriteMessage){
        let p = getPeripheral(Device.init(uuid: message.uuid, macAddress: message.macAddress))
        guard let command = message.command == 0 ? characteristic?.command : characteristic?.health else{
            writeLog("null command characteristic", method: "write", className:"BluetoothManager")
            return
        }
        guard message.writeType == 1 || message.writeType == 0 else{
            writeLog("null write characteristic", method: "write", className:"BluetoothManager")
            return
        }
        if let data = message.data {
            p?.writeValue(data, for: command, type: CBCharacteristicWriteType(rawValue: message.writeType) ?? CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    func getPeripheral(_ device: Device) -> CBPeripheral? {
        if peripheralDic.isEmpty{
            return nil;
        }
        if let uuid = device.uuid, let p = peripheralDic[uuid]{
            return p;
        }
        if let macAddress = device.macAddress, let p = peripheralDic[macAddress]{
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
        peripheral.discoverServices(nil)
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
        channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,errorType))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        writeLog("didDisconnectPeripheral - " + peripheral.identifier.uuidString + " - " + (error?.localizedDescription ?? ""), method: "didDisconnectPeripheral", className:"BluetoothManager")
        if let _ = error{
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.fail))
        }else{
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.Conectcancel))
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
}

extension BluetoothManager : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let e = error {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didDiscoverServices", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.ServiceFial))
            return
        }else if peripheral.services?.count == 0 {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + "error: services.count = 0", method: "didDiscoverServices", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.ServiceFial))
            return
        }
        serviceIndex = 0;
        writeLog("didDiscoverServices", method: "didDiscoverServices", className: nil)
        peripheral.services?.forEach{peripheral.discoverCharacteristics(nil, for: $0)}
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let e = error {
            writeLog("didDiscoverCharacteristicsFor - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didDiscoverCharacteristicsFor", className: nil)
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.CharacteristicsFial))
            return
        }
        serviceIndex += 1
        
        // 此处才算正在连接设备成功，要不然前面连接成功设备，特征服务未发现无法操作数据
        setCharacteristics(peripheral, service)
        isOtaWithServices(peripheral: peripheral)
        if peripheral.services?.count == serviceIndex {
            channel?.invokeMethod(MethodChannel.deviceState.rawValue, arguments: deviceStateData(peripheral,.none))
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
        let message = Message.init(data: characteristic.value, uuid: peripheral.identifier.uuidString, macAddress: localDevices.getMacAddress(uuid: peripheral.identifier.uuidString))
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
