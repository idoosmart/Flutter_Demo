//
//  Information.swift
//  flutter_blue_plus
//
//  Created by lux on 2022/8/24.
//

import UIKit
import CoreBluetooth

class Information {
    static let singleton = Information();
    var servicesUUID : [CBUUID] = {
        let uuid1 = CBUUID.init(string: "00001530-1212-EFDE-1523-785FEABCD123")
        let uuid2 = CBUUID.init(string: "00000af0-0000-1000-8000-00805f9b34fb")
        let uuid3 = CBUUID.init(string: "FE59")
        return [uuid1,uuid2,uuid3]
    }()
    
}

