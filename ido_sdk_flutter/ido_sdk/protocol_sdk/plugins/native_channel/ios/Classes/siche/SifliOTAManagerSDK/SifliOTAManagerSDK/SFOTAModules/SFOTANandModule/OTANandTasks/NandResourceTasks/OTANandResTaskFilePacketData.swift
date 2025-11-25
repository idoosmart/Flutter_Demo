import UIKit

typealias ResFilePacketdataCompletion = (_ task:OTANandResTaskFilePacketData, _ result:Int, _ newRspFreq:Int,_ remoteCompletedPacketCount:Int, _ error:SFOTAError?) -> Void

class OTANandResTaskFilePacketData: OTANandTaskBase {
    
    
    /// 与协议中的packet index对应。
    /// 从1开始计数，避免混淆用OrderNumber命名
    let packetOrderNumber:UInt16
    
    
    let packetData:Data
    
    let completion:ResFilePacketdataCompletion?
    
    override func name() -> String {
        return "ResFilePacketData"
    }
    
    init(packetOrderNumber: UInt16, packetData: Data, completion: ResFilePacketdataCompletion?) {
        self.packetOrderNumber = packetOrderNumber
        self.packetData = packetData
        self.completion = completion
        super.init(messageType: .DFU_FILE_PACKET_DATA)
        if completion != nil {
            /// 不为空时才设置baseCompletion。这样为nil时不会占用Manager中的等待response的队列
    
            self.baseCompletion = {[weak self](task:OTANandTaskBase, msgModel:OTANandMessageBaseModel?, error:SFOTAError?) in
                guard let s = self else {
                    return
                }
                if let err = error {
                    s.completion?(s,-1,-1,-1,err)
                    return
                }
                let payload = msgModel!.payloadData
                if payload.count < 8 {
                    LogInsufficientMsgBytes(taskDes: "FILE_PACKET_DATA", expect: 8, actual: payload.count)
                    let err = SFOTAError.InsufficientBytes(expectCount: 8, actualCount: payload.count)
                    s.completion?(s, -1, -1, -1, err)
                    return
                }
                
                let pd = NSData.init(data: payload)
                
                var result:UInt16 = 0
                pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
                
                var newRspFreq:UInt16 = 0
                pd.getBytes(&newRspFreq, range: NSRange.init(location: 2, length: 2))
                
                var completedCount:UInt32 = 0
                pd.getBytes(&completedCount, range: NSRange.init(location: 4, length: 4))
                
                s.completion?(s,Int(result), Int(newRspFreq), Int(completedCount), nil)
            }
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        var number = self.packetOrderNumber
        let numberData = Data.init(bytes: &number, count: 2)
        
        var length = UInt16(packetData.count)
        let lengthData = Data.init(bytes: &length, count: 2)
        
        return numberData + lengthData + packetData
    }

}
