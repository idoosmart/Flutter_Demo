import UIKit

class NorV1ResumeInfos {
    /// 0是OK，其他是其他错误.
    var result:Int
    
    /// 1-对端会重启，0-对端不重启
    var needReboot:Bool
    
    /// 1-从第一个image重新传输，0-从后面给定的image序号和ID恢复传输
    var resumeRestart:Bool
    
    /// 已经正常处理的包数
    var completedCount:UInt32
    
    /// 恢复传输的image ID
    var imageIDValue:UInt8
    
    var numOfRsp:UInt8?
    
    init(result: Int, needReboot: Bool, resumeRestart: Bool, completedCount: UInt32, imageIDValue: UInt8, numOfRsp: UInt8? = nil) {
        self.result = result
        self.needReboot = needReboot
        self.resumeRestart = resumeRestart
        self.completedCount = completedCount
        self.imageIDValue = imageIDValue
        self.numOfRsp = numOfRsp
    }
}

typealias NorV1ImageResumeRequestCompletion = (_ task:OTANorV1TaskImageResumeRequest, _ infos:NorV1ResumeInfos?,_ error:SFOTAError?) -> Void

class OTANorV1TaskImageResumeRequest: OTANorV1TaskBase {

    let ctrlFile:Data
    
    let completion:NorV1ImageResumeRequestCompletion
    
    override func name() -> String {
        return "NorV1ImageResumeRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        let d = ctrlFile
        return d
    }
    
    init(ctrlFile: Data, completion:@escaping NorV1ImageResumeRequestCompletion) {
        self.ctrlFile = ctrlFile
        self.completion = completion
        super.init(messageType: .Resume_Request)
        self.baseCompletion = {[weak self] tsk, message, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,nil,err)
                return
            }
            let payload = message!.payloadData
            let pd = NSData.init(data: payload)
            
            if pd.count < 8 {
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 8, actual: pd.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 8, actualCount: pd.count)
                s.completion(s,nil,err)
                return
            }
            
            var r:UInt16 = 0
            pd.getBytes(&r, range: NSRange.init(location: 0, length: 2))
            let result = Int(r)
            
            var boot:UInt8 = 0
            pd.getBytes(&boot, range: NSRange.init(location: 2, length: 1))
            let needReboot = boot != 0
            
            var start:UInt8 = 0
            pd.getBytes(&start, range: NSRange.init(location: 3, length: 1))
            let isResumeReStart = start != 0
            
            var completedCount:UInt32 = 0
            var imageIDValue:UInt8 = 0
            var numOfRsp:UInt8?
            if (pd.count == 8) {
                var num:UInt16 = 0
                pd.getBytes(&num, range: NSRange.init(location: 4, length: 2))
                completedCount = UInt32(num)
                
                var id:UInt8 = 0
                pd.getBytes(&id, range: NSRange.init(location: 6, length: 1))
                imageIDValue = id
                
            } else if pd.count >= 10 {
                var num:UInt32 = 0
                pd.getBytes(&num, range: NSRange.init(location: 4, length: 4))
                completedCount = UInt32(num)
                
                var id:UInt8 = 0
                pd.getBytes(&id, range: NSRange.init(location: 8, length: 1))
                imageIDValue = id
                
                var rsp:UInt8 = 0
                pd.getBytes(&rsp, range: NSRange.init(location: 9, length: 1))
                numOfRsp = rsp
            }else {
                OLog("❌Invalid Message Payload Length:\(pd.count)")
                let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Message Payload Length")
                s.completion(s,nil,err)
                return
            }
            
            let infos = NorV1ResumeInfos.init(result: result, needReboot: needReboot, resumeRestart: isResumeReStart, completedCount: completedCount, imageIDValue: imageIDValue, numOfRsp: numOfRsp)
            
            s.completion(s,infos,nil)
        }
    }
}
