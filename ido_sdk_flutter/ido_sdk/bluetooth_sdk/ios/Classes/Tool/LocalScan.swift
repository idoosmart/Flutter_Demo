//
//  LocationScan.swift
//  flutter_bluetooth
//
//  Created by lux on 2022/9/30.
//

import Foundation
import CoreBluetooth

private var key: Void?
class LocalScan{
    var keychainList: Dictionary<String,String>? = [String: String]();
    var systemList: [CBPeripheral]?
    private var keychain: Keychain = Keychain(service: "BluetoothUUID")
    
    //从系统列表里查找
    @discardableResult func findSystemList(_ mac: String?) -> [CBPeripheral]?{
        systemList = BluetoothManager.singleton.manager.retrieveConnectedPeripherals(withServices: Information.singleton.servicesUUID)
        let uuidStr = getUuid(mac: mac)
        systemList?.forEach({
            BluetoothManager.singleton.writeLog("retrieveConnectedPeripherals" + String(describing: $0.name) + $0.identifier.uuidString + "连接状态 === \($0.state)" + "macAddress == \(String(describing: mac))",method: "findSystemList",className:"LocalScan")
        })
        if isContainDevice(uuidStr) {
            BluetoothManager.singleton.writeLog("Device is found in the system Bluetooth list == \(String(describing: mac))",method: "findSystemList",className:"LocalScan")
            return systemList
        }
        if uuidStr.isEmpty {
            return systemList
        }
        if isContainDevice(uuidStr) == false {
            if let uuid = UUID(uuidString: uuidStr) {
                let list = BluetoothManager.singleton.manager.retrievePeripherals(withIdentifiers: [uuid])
                list.forEach({
                    BluetoothManager.singleton.writeLog("retrievePeripherals" + String(describing: $0.name) + $0.identifier.uuidString + "连接状态 === \($0.state)" + "macAddress == \(String(describing: mac))",method: "findSystemList",className:"LocalScan")
                })
                if list.count > 0 {
                    systemList?.append(list.first!)
                }
            }
        }
        return systemList
    }
    
    // 获取所有keychain UUID 集合
    func getKeychainUuidList() -> [UUID] {
        var uuidList = [UUID]()
        keychainList?.keys.forEach({ key in
            if let uuid = UUID(uuidString: key) {
                uuidList.append(uuid)
             }
        });
        return uuidList
    }
    
    // 通过UUID获取MAC地址
    func getMacAddress(uuid: String) -> String {
        return keychainList?[uuid] ?? ""
    }
    
    // 通过mac获取uuid
    func getUuid(mac: String?) -> String {
        var uuidStr = ""
        keychainList?.forEach({ key,value in
            if value == mac {
                uuidStr = key
            }
        })
        return uuidStr
    }
    
    // 是否包含设备
    func isContainDevice(_ uuid: String) -> Bool {
        var isContain = false
        systemList?.forEach({ p in
            if p.identifier.uuidString == uuid {
                isContain = true
            }
        })
        return isContain
    }
    
    // 获取keychain 保存的设备
    func getKeychainList() -> [String: String]?{
        let data = keychain[data:"UUID"]
        if let dic = data?.toDict() as? Dictionary<String, String>{
            keychainList = dic;
        }
        return keychainList
    }
    
    func save(){
        saveDevice(keychainList);
    }
    
    func saveDevice(_ device:Dictionary<String,Any>?){
//        print("saveDevice_KeychainList1 \(String(describing: device))");
        if let data = device?.toData(){
//            print("saveDevice_KeychainList2 \(String(describing: device))");
            keychain[data:"UUID"] = data
        }
    }
    
    func clearKeychainList() {
        keychain[data:"UUID"] = Dictionary<String,Any>().toData()
    }

}
