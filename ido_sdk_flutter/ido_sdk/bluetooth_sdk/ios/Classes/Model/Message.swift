//
//  Message.swift
//  flutter_bluetooth
//
//  Created by lux on 2022/9/2.
//

import UIKit

struct Message {
    var data: Data?
    var uuid: String
    var macAddress: String
    
    func toDict() -> Dictionary<String,Any> {
        return ["data": FlutterStandardTypedData.init(bytes: data ?? Data()),
                "uuid": uuid,
                "macAddress": macAddress]
    }
}

struct WriteMessage{
    var data: Data?
    var uuid: String = ""
    var macAddress: String = ""
    var command: Int = 0
    var writeType: Int = 1
    
    init(dict: Dictionary<String,Any>) {
        if let value = dict["data"] as? FlutterStandardTypedData{
            data = value.data
        }
        if let value = dict["uuid"] as? String{
            uuid = value
        }
        if let value = dict["macAddress"] as? String{
            macAddress = value
        }
        if let value = (dict["command"] as? NSNumber)?.intValue {
            command = value
        }
        if let value = (dict["writeType"] as? NSNumber)?.intValue {
            writeType = value
        }
    }
}


