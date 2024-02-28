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
    
//   从系统列表里查找
    @discardableResult func findSystemList() -> [CBPeripheral]?{
        systemList = BluetoothManager.singleton.manager.retrieveConnectedPeripherals(withServices: Information.singleton.servicesUUID)
        return systemList
    }
    
    func getMacAddress(uuid: String) -> String {
        return keychainList?[uuid] ?? ""
    }
    
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
}
