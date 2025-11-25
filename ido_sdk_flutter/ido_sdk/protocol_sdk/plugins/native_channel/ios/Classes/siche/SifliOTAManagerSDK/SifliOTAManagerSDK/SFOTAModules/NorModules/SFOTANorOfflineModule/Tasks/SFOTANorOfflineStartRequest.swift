//
//  SFOTANorOfflineStartRequest.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/12/24.
//

import UIKit
class NorOfflineStartRequestMsg:NSObject {
    let result:UInt16
    let reserved:UInt16
    let completeCount:UInt32
    init(result: UInt16, reserved: UInt16, completeCount: UInt32) {
        self.result = result
        self.reserved = reserved
        self.completeCount = completeCount
    }
}
typealias SFOTANorOfflineStartRequestCompletion = (_ task:SFOTANorOfflineStartRequest, _ msg:NorOfflineStartRequestMsg?, _ error:SFOTAError?) -> Void
class SFOTANorOfflineStartRequest: OTANorV2TaskBase {
    let completion:SFOTANorOfflineStartRequestCompletion
    let fileLength:UInt32
    let packetCount:UInt32
    let crc32:UInt32
    init(fileLength: UInt32, packetCount: UInt32, crc32: UInt32,completion: @escaping SFOTANorOfflineStartRequestCompletion) {
        self.completion = completion
        self.fileLength = fileLength
        self.packetCount = packetCount
        self.crc32 = crc32
        super.init(messageType: .DFU_IMAGE_OFFLINE_START_REQ)
        
        self.baseCompletion = {[weak self] (tsk, msg, error) in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,nil,err)
                return
            }
            let payload = msg!.payloadData
            let pd = NSData.init(data: payload)
            if pd.count < 8 {
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 8, actual: pd.count)
                let e = SFOTAError.InsufficientBytes(expectCount: 8, actualCount: pd.count)
                s.completion(s,nil,e)
                return
            }
            
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            var reserved:UInt16 = 0
            pd.getBytes(&reserved, range: NSRange.init(location: 2, length: 2))
            
            var completedCount:UInt32 = 0
            pd.getBytes(&completedCount, range: NSRange.init(location: 4, length: 4))
            
            let msgModel = NorOfflineStartRequestMsg.init(result: result, reserved: reserved, completeCount: completedCount)
            
            s.completion(s, msgModel, nil)
        }
    }
    
    override func name() -> String {
        return "SFOTANorOfflineStartRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var fileLen = self.fileLength
        let fileLenData = Data.init(bytes: &fileLen, count: 4)
        
        var count = self.packetCount
        let countData = Data.init(bytes: &count, count: 4)
        
        var crcVar = self.crc32
        let crcData = Data.init(bytes: &crcVar, count: 4)
        
        return fileLenData + countData + crcData
    }
}
