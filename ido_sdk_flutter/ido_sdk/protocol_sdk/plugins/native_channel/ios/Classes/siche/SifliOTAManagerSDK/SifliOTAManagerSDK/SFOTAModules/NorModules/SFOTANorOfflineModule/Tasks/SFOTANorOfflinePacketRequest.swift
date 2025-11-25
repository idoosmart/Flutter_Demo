//
//  SFOTANorOfflinePacketRequest.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/12/24.
//

import UIKit
class NorOfflinePacketMsg:NSObject {
    let result:UInt16
    let retransmission:UInt8
    let completeCount:UInt32
    init(result: UInt16, retransmission: UInt8, completeCount: UInt32) {
        self.result = result
        self.retransmission = retransmission
        self.completeCount = completeCount
    }
}
typealias SSFOTANorOfflinePacketRequestCompletion = (_ task:SFOTANorOfflinePacketRequest, _ msg:NorOfflinePacketMsg?, _ error:SFOTAError?) -> Void

class SFOTANorOfflinePacketRequest: OTANorV2TaskBase {
    let packetOrder:UInt32
    let dataLength:UInt32
    let crc:UInt32
    let packetData:Data
    let completion:SSFOTANorOfflinePacketRequestCompletion?
    init(packetOrder: UInt32, dataLength: UInt32, crc: UInt32, packetData: Data,completion: @escaping SSFOTANorOfflinePacketRequestCompletion) {
        self.completion = completion
        self.packetOrder = packetOrder
        self.dataLength = dataLength
        self.crc = crc
        self.packetData = packetData
        super.init(messageType: .DFU_IMAGE_OFFLINE_PACKET_REQ)
        
        if self.completion != nil {
            self.baseCompletion = {[weak self] (tsk, msg, error) in
                guard let s = self else {
                    return
                }
                if let err = error {
                    s.completion?(s,nil,err)
                    return
                }
                
                let payload = msg!.payloadData
                if payload.count < 8{
                    LogInsufficientMsgBytes(taskDes: s.name(), expect: 8, actual: payload.count)
                    let err = SFOTAError.InsufficientBytes(expectCount: 8, actualCount: payload.count)
                    s.completion?(s, nil, err)
                    return
                }
                
                let pd = NSData.init(data: payload)
                var result:UInt16 = 0
                pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
                
                var retransmission:UInt8 = 0
                pd.getBytes(&retransmission, range: NSRange.init(location: 2, length: 1))
                
                var completeCount:UInt32 = 0
                pd.getBytes(&completeCount, range: NSRange.init(location: 4, length: 4))
                
                let packetMsg = NorOfflinePacketMsg.init(result: result, retransmission: retransmission, completeCount: completeCount)
                s.completion?(s,packetMsg, nil)
            }
        }
    }
    
    override func name() -> String {
        return "SFOTANorOfflinePacketRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var packetOrder = self.packetOrder
        let packetOrderData = Data.init(bytes: &packetOrder, count: 4)
        
        var dataLengthVar = self.dataLength
        let dataLengthData = Data.init(bytes: &dataLengthVar, count: 4)
        
        var crcVar = self.crc
        let crcData = Data.init(bytes: &crcVar, count: 4)
        
        return packetOrderData + dataLengthData + crcData + packetData
    }
}
