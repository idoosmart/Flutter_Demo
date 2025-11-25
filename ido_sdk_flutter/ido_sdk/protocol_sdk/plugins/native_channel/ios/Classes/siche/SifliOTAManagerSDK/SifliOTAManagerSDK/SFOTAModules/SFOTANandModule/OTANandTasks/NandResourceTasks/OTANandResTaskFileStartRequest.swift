import UIKit


class OTANandResTaskFileStartRequest: OTANandTaskBase {
    
    
    /// 协议中对应的file index字段。
    /// 因为从1计数，避免混淆，在这里命名为OrderNumber
    let fileOrderNumber:UInt16
    
    
    /// 与设备端约定回复频率。
    let rspFrequnecy:UInt16
    
    
    /// 即将发送的文件的长度
    let fileLength:UInt32
    
    
    /// 将文件按一定长度拆分为若干包后的包数量。
    let packetCount:UInt16
    
    /// 从zip包的order list中解析出的带相对路径的文件名
    let fileNameDataWithPath:Data
    
    let completion:ResultCompletion
    
    override func name() -> String {
        return "ResFileStartRequest"
    }
    
    
    init(fileOrderNumber: UInt16, rspFrequnecy: UInt16, fileLength: UInt32, packetCount: UInt16, fileNameDataWithPath: Data, completion:@escaping ResultCompletion) {
        self.fileOrderNumber = fileOrderNumber
        self.rspFrequnecy = rspFrequnecy
        self.fileLength = fileLength
        self.packetCount = packetCount
        self.fileNameDataWithPath = fileNameDataWithPath
        self.completion = completion
        super.init(messageType: .DFU_FILE_START_REQUEST)
        self.timeout = 120;
        self.baseCompletion = {[weak self](task:OTANandTaskBase, msgModel:OTANandMessageBaseModel?, error:SFOTAError?) in
            guard let s = self else {
                return
            }
            if let err = error {
                s.completion(s,0,err)
                return
            }
            let payload = msgModel!.payloadData
            if payload.count < 2 {
                OLog("❌FILE_START_RESPONSE的Payload字节长度不足:payload.length=\(payload.count)")
                let err = SFOTAError.init(errorType: .InsufficientBytes, errorDes: "字节数异常")
                s.completion(s,0,err)
                return
            }
            if payload.count > 2{
                OLog("⚠️FILE_START_RESPONSE的Payload字节数大于2: length=\(payload.count)")
            }
            let d = NSData.init(data: payload)
            var resultValue:UInt16 = 0
            d.getBytes(&resultValue, range: NSRange.init(location: 0, length: 2))
            s.completion(s,Int(resultValue),nil)
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        
        var orderNum = self.fileOrderNumber
        let orderData = Data.init(bytes: &orderNum, count: 2)
        
        var freq = self.rspFrequnecy
        let freqData = Data.init(bytes: &freq, count: 2)
        
        var fileLen = self.fileLength
        let fileLenData = Data.init(bytes: &fileLen, count: 4)
        
        var count = self.packetCount
        let countData = Data.init(bytes: &count, count: 2)
        
        var nameLen = UInt16(fileNameDataWithPath.count)
        let nameLenData = Data.init(bytes: &nameLen, count: 2)
        
        let totalData = orderData + freqData + fileLenData + countData + nameLenData + fileNameDataWithPath
        
        return totalData
    }
}
