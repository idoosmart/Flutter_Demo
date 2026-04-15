//
//  ToolImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/9/18.
//

import Foundation

private var _tool: Tool? {
    return SwiftProtocolChannelPlugin.shared.tools
}

private var _cache: Cache? {
    return SwiftProtocolChannelPlugin.shared.cache
}

class ToolImpl: IDOToolsInterface {
    func png2Bmp(inPath: String, outPath: String, format: Int, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _tool?.png2Bmp(inPath: inPath, outPath: outPath, format: format.int64, completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func compressToPNG(inputFilePath: String, outputFilePath: String, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _tool?.compressToPNG(inputFilePath: inputFilePath, outputFilePath: outputFilePath, completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func makeEpoFile(dirPath: String, epoFilePath: String, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _tool?.makeEpoFile(dirPath: dirPath, epoFilePath: epoFilePath, completion: { rs in
                completion(rs)
            })
        }
    }
    
    func gpsInitType(motionTypeIn: Int, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _tool?.gpsInitType(motionTypeIn: motionTypeIn.int64, completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func gpsAlgProcessRealtime(json: String, completion: @escaping (String) -> Void) {
        _runOnMainThread {
            _tool?.gpsAlgProcessRealtime(json: json, completion: { rs in
                completion(rs)
            })
        }
    }
    
    func gpsSmoothData(json: String, completion: @escaping (String) -> Void) {
        _runOnMainThread {
            _tool?.gpsSmoothData(json: json, completion: { rs in
                completion(rs)
            })
        }
    }
    
    func logPath(completion: @escaping (String) -> Void) {
        _runOnMainThread {
            _cache?.logPath(completion: completion)
        }
    }
    
    func currentDevicePath(completion: @escaping (String) -> Void) {
        _runOnMainThread {
            _cache?.currentDevicePath(completion: completion)
        }
    }
    
    func exportLog(completion: @escaping (String) -> Void) {
        _runOnMainThread {
            _cache?.exportLog(completion: completion)
        }
    }
    
    func lastConnectDevice(completion: @escaping (String?) -> Void) {
        _runOnMainThread {
            _cache?.lastConnectDevice(completion: { json in
                completion(json?.count ?? 0 > 2 ? json : nil)
            })
        }
    }
    
    func loadDeviceExtListByDisk(sortDesc: Bool, completion: @escaping ([String]) -> Void) {
        _runOnMainThread {
            _cache?.loadDeviceExtListByDisk(sortDesc: sortDesc, completion: { rs in
                completion(rs ?? [])
            })
        }
    }
    
    func mp3SamplingRate(mp3FilePath: String, completion: @escaping (Int) -> Void) {
        _runOnMainThread {
            _tool?.mp3SamplingRate(mp3FilePath: mp3FilePath, completion: { rs in
                completion(rs.int)
            })
        }
    }
}


func _logNative(_ msg: String) {
    _runOnMainThread {
        SwiftProtocolChannelPlugin.shared.tools?.logNative(msg: msg, completion: { })
    }
}
