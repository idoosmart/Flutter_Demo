import UIKit

class NorV2ResumeInfos:NSObject {
    
    let imageReview:Bool
    
    let resumeRestart:Bool
    
    let completedPacketCount:UInt32
    
    let imageIdValue:UInt8
    
    /// 在ImageStartRequest中需要与设备约定该值为回复频率
    let rspFrequency:UInt8
    
    init(imageReview:Bool,resumeRestart: Bool, completedPacketCount: UInt32, imageIdValue: UInt8, rspFrequency: UInt8) {
        self.imageReview = imageReview
        self.resumeRestart = resumeRestart
        self.completedPacketCount = completedPacketCount
        self.imageIdValue = imageIdValue
        self.rspFrequency = rspFrequency
    }
    
    override var debugDescription: String {
        return "{ imageReview=\(imageReview), resumeRestart=\(resumeRestart),  completedPacketCount=\(completedPacketCount), imageIdValue=\(imageIdValue), frequency=\(rspFrequency) }"
    }
}

class NorV2ImageInitRequestMsg:NSObject {
    let result:Int
    let needReboot:Bool
    let resumeInfos:NorV2ResumeInfos?
    
    init(result: Int, needReboot: Bool,resumeInfos: NorV2ResumeInfos?) {
        self.result = result
        self.needReboot = needReboot
        self.resumeInfos = resumeInfos
        super.init()
    }
}

typealias NorV2ImageInitRequestCompletion = (_ task:OTANorV2TaskImageInitRequestExt, _ msg:NorV2ImageInitRequestMsg?, _ error:SFOTAError?) -> Void

class OTANorV2TaskImageInitRequestExt: OTANorV2TaskBase {
    
    let ctrlPacketData:Data
    
    let completion:NorV2ImageInitRequestCompletion
    
    override func name() -> String {
        return "NorV2ImageInitRequestExt"
    }
    
    override func marshalMsgPayloadData() -> Data {
        let data = ctrlPacketData
        return data
    }
    
    init(ctrlPacketData: Data, completion:@escaping NorV2ImageInitRequestCompletion) {
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
            let pd = NSData.init(data: payload)
            if pd.count < 11 {
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 11, actual: pd.count)
                let e = SFOTAError.InsufficientBytes(expectCount: 11, actualCount: pd.count)
                s.completion(s,nil,e)
                return
            }
            
            var otaVersion:UInt8 = 0
            if pd.count > 11 {
                // 含有Version信息
                pd.getBytes(&otaVersion, range: NSRange.init(location: 11, length: 1))
            }
            
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            var resumeStatus:UInt8 = 0
            pd.getBytes(&resumeStatus, range: NSRange.init(location: 2, length: 1))
            
            var resumeInfos:NorV2ResumeInfos?
            if resumeStatus != 0 {
                var restart:UInt8 = 0
                pd.getBytes(&restart, range: NSRange.init(location: 3, length: 1))
                
                var count:UInt32 = 0
                pd.getBytes(&count, range: NSRange.init(location: 4, length: 4))
                
                var imageIdValue:UInt8 = 0
                pd.getBytes(&imageIdValue, range: NSRange.init(location: 8, length: 1))
                
                var freq:UInt8 = 0
                pd.getBytes(&freq, range: NSRange.init(location: 9, length: 1))
                
                var imageReview = (otaVersion >= 1) && (resumeStatus == 2)
                
                if imageReview {
                    OLog("⚠️启用’重传+续传‘：otaVersion=\(otaVersion), resumeStatus=\(resumeStatus)")
                }else{
                    OLog("ℹ️未启用‘重传+续传’: otaVersion=\(otaVersion), resumeStatus=\(resumeStatus)")
                }
                
                resumeInfos = NorV2ResumeInfos.init(imageReview: imageReview,resumeRestart: restart != 0, completedPacketCount: count, imageIdValue: imageIdValue, rspFrequency: freq)
            }
            
            var reboot:UInt8 = 0
            pd.getBytes(&reboot, range: NSRange.init(location: 10, length: 1))
            
            
            let msgModel = NorV2ImageInitRequestMsg.init(result: Int(result), needReboot: reboot != 0, resumeInfos: resumeInfos)
            
            s.completion(s, msgModel, nil)
        }
    }

}
