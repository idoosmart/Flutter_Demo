import UIKit

class OTANandHcpuTaskImageStartRequest: OTANandTaskBase {
    
    let fileLength:UInt32
    
    let sliceCount:UInt32
    
    
    /// 如果是进行续传，应当当使用IMAGE_INIT_RESPONSE_EXT中的Response Frequency
    let rspFreq:UInt8
    
    let imageId:NandImageID
    
    let completion:ResultCompletion
    
    override func name() -> String {
        return "ImageStartRequest"
    }
    
    init(fileLength: UInt32, sliceCount: UInt32, rspFreq: UInt8, imageId: NandImageID, completion:@escaping ResultCompletion) {
        self.fileLength = fileLength
        self.sliceCount = sliceCount
        self.rspFreq = rspFreq
        self.imageId = imageId
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_START_REQUEST)
        self.updateTimeoutMin180(fileLength: fileLength)
        self.baseCompletion = {[weak self] (tsk,msg,error) in
            
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,-1, err)
                return
            }
            let payload = msg!.payloadData
            if payload.count < 2{
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s, -1, err)
                return
            }
            
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            s.completion(s,Int(result), nil)
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        var fileLen = self.fileLength
        let fileLenData = Data.init(bytes: &fileLen, count: 4)
        
        var count = self.sliceCount
        let countData = Data.init(bytes: &count, count: 4)
        
        var freq = self.rspFreq
        let freqData = Data.init(bytes: &freq, count: 1)
        
        var idValue = UInt8(self.imageId.rawValue)
        let idValueData = Data.init(bytes: &idValue, count: 1)
        
        return fileLenData + countData + freqData + idValueData
    }
    


}
