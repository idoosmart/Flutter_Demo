//
//  Device.swift
//  flutter_bluetooth
//
//  Created by lux on 2022/9/1.
//

import UIKit
import CoreBluetooth

func deviceStateData(_ peripheral: CBPeripheral?,_ errorState: ConnectError,_ platform: Int) -> Dictionary<String,Any>{
    if let p = peripheral {
        return ["uuid": p.identifier.uuidString,
                "macAddress":"",
                "platform": NSNumber(value: platform),
                "state": NSNumber(value: p.state.rawValue),
                "errorState": NSNumber(value: errorState.rawValue)
        ]
    }
    return ["uuid": "",
            "macAddress":"",
            "platform": NSNumber(value: 0),
            "state": NSNumber(value: 0),
            "errorState": NSNumber(value: errorState.rawValue)
    ]
}


struct Device: SSCoadble {
    var rssi: Int?
    var name: String?
    var state: Int?
    var platform: Int?
    var uuid: String? = ""
    var macAddress: String? = ""
    var serviceUUIDs: [String]? = []
    var dataManufacturerData: Data?

//  扫描调用
    init(peripheral: CBPeripheral , advertisementData: Dictionary<String, Any> , RSSI: NSNumber) {
        name = advertisementData["kCBAdvDataLocalName"] as? String
        if (name == nil || name!.isEmpty){
            name = peripheral.name;
        }
        uuid = peripheral.identifier.uuidString
        rssi = abs(RSSI.intValue)
        state = peripheral.state.rawValue
        if let arr = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
            serviceUUIDs = arr.map{$0.uuidString}
        }
    }
    
//    已连接设备调用
    init(peripheral: CBPeripheral, macAdr: String?){
        name = peripheral.name
        uuid = peripheral.identifier.uuidString
        state = peripheral.state.rawValue
        rssi = 1
        macAddress = macAdr
        serviceUUIDs = peripheral.services?.map({$0.uuid.uuidString})
    }
    
    init(uuid: String, macAddress: String) {
        self.uuid = uuid
        self.macAddress = macAddress
    }
    
    func toDictExpand(advertisementData: Dictionary<String, Any>) -> Dictionary<String, Any>? {
        var dict = toDict();
        let data = advertisementData["kCBAdvDataManufacturerData"] as? Data
        dict?["dataManufacturerData"] = FlutterStandardTypedData.init(bytes:data ?? Data())
        return dict
    }
}

