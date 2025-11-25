import UIKit

class HcpuImageInitResponseMsg{
    
    let result:UInt16
    
    /// nil表示不支持续传
    let resumeInfos:HcpuResumeInfos?
    
    init(result: UInt16, resumeInfos: HcpuResumeInfos?) {
        self.result = result
        self.resumeInfos = resumeInfos
    }
}

class HcpuResumeInfos {
    // true-需要从指定的ImageID的第一个包重新开始；false-需要从指定的ImageID用completedPacketCount重新开始
    let resumeRestart:Bool
    
    let completedPacketCount:UInt32
    
    let imageIdValue:UInt8
    
    /// 在ImageStartRequest中需要与设备约定该值为回复频率
    let rspFrequency:UInt8
    
    init(resumeRestart: Bool, completedPacketCount: UInt32, imageIdValue: UInt8, rspFrequency: UInt8) {
        self.resumeRestart = resumeRestart
        self.completedPacketCount = completedPacketCount
        self.imageIdValue = imageIdValue
        self.rspFrequency = rspFrequency
    }
    
    func toString() -> String {
        return "{resumeRestart=\(resumeRestart), completedPacketCount=\(completedPacketCount), imageIdValue=\(imageIdValue), rspFrequency=\(rspFrequency)}"
    }
}

typealias HcpuImageInitRequestCompletion = (_ task:OTANandHcpuTaskImageInitRequestExt,_ msg:HcpuImageInitResponseMsg?, _ error:SFOTAError?) -> Void

class OTANandHcpuTaskImageInitRequestExt: OTANandTaskBase {
    
    let ctrlPacketData:Data
    
    let completion:HcpuImageInitRequestCompletion
    
    override func name() -> String {
        return "ImageInitRequestExt"
    }
    
    init(ctrlPacketData: Data, completion:@escaping HcpuImageInitRequestCompletion) {
        self.ctrlPacketData = ctrlPacketData
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_INIT_REQUEST_EXT)
        
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
            if payload.count < 10 {
                // 只解析前10字节
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 10, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 10, actualCount: payload.count)
                s.completion(s,nil,err)
                return
            }
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            var resumeStatus:UInt8 = 0
            pd.getBytes(&resumeStatus, range: NSRange.init(location: 2, length: 1))
            var resumeInfos:HcpuResumeInfos?
            if resumeStatus != 0 {
                
                var resumeRestart:UInt8 = 0
                pd.getBytes(&resumeRestart, range: NSRange.init(location: 3, length: 1))
                
                var resumeCount:UInt32 = 0
                pd.getBytes(&resumeCount, range: NSRange.init(location: 4, length: 4))
                
                var imageIdValue:UInt8 = 0
                pd.getBytes(&imageIdValue, range: NSRange.init(location: 8, length: 1))
                
                var freq:UInt8 = 0
                pd.getBytes(&freq, range: NSRange.init(location: 9, length: 1))
                
                resumeInfos = HcpuResumeInfos.init(resumeRestart: resumeRestart != 0, completedPacketCount: resumeCount, imageIdValue: imageIdValue, rspFrequency: freq)
            }
            
            let message = HcpuImageInitResponseMsg.init(result: result, resumeInfos: result != 0 ? nil:resumeInfos)
            s.completion(s,message,nil)
            
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        return self.ctrlPacketData
    }

}
