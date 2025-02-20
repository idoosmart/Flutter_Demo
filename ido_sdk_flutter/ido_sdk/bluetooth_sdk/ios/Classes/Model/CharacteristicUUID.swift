//
//  characteristicUUID.swift
//  flutter_bluetooth
//
//  Created by lux on 2022/9/2.
//

import UIKit
import CoreBluetooth

struct Characteristic{
    var command: CBCharacteristic?
    var health: CBCharacteristic?
    var henXuan: CBCharacteristic?
    var vc: CBCharacteristic?
    var uuid: CharacteristicUUID?
}

struct CharacteristicUUID: SSCoadble {
    var command: String?
    var health: String?
    var read: String?
    var henXuanSend: String?
    var henXuanNotify: String?
    var vcSend: String?
    var vcNotify: String?
    var notify: [String]?
}
