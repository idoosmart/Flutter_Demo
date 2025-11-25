import UIKit

class NorV2ImageStartRequestRspMsg {
    var result:Int
    var endMode:NorEndMode
    var skip:Bool?
    init(result: Int, endMode: NorEndMode, skip:Bool? = nil) {
        self.result = result
        self.endMode = endMode
        self.skip = skip
    }
}

typealias NorV2ImageStartRequestCompletion = (_ tsk:OTANorV2TaskImageStartRequest, _ msg:NorV2ImageStartRequestRspMsg?, _ error:SFOTAError?) -> Void

class OTANorV2TaskImageStartRequest: OTANorV2TaskBase {
    
    let fileLength:UInt32
    
    let sliceCount:UInt32
    
    
    /// 如果是进行续传，应当当使用IMAGE_INIT_RESPONSE_EXT中的Response Frequency
    let rspFreq:UInt8
    
    let imageId:NorImageID
    
    let completion:NorV2ImageStartRequestCompletion
    
    override func name() -> String {
        return "NorV2ImageStartRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var fileLen = self.fileLength
        let fileLenData = Data.init(bytes: &fileLen, count: 4)
        
        var count = self.sliceCount
        let countData = Data.init(bytes: &count, count: 4)
        
        var freq = self.rspFreq
        let freqData = Data.init(bytes: &freq, count: 1)
        
        var idValue = self.imageId.rawValue
        
        let idValueData = Data.init(bytes: &idValue, count: 1)
        
        return fileLenData + countData + freqData + idValueData
    }

    init(fileLength: UInt32, sliceCount: UInt32, rspFreq: UInt8, imageId: NorImageID, completion:@escaping NorV2ImageStartRequestCompletion) {
        self.fileLength = fileLength
        self.sliceCount = sliceCount
        self.rspFreq = rspFreq
        self.imageId = imageId
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_START_REQUEST)
        
        self.baseCompletion = {[weak self] (tsk,msg,error) in
            
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,nil, err)
                return
            }
            let payload = msg!.payloadData
            if payload.count < 2{
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s, nil, err)
                return
            }
                        
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            let message = NorV2ImageStartRequestRspMsg.init(result: Int(result), endMode: .noSend)
            
            if pd.count >= 3 {
                var modeValue:UInt8 = 0
                pd.getBytes(&modeValue, range: NSRange.init(location: 2, length: 1))
                switch modeValue{
                case 0:
                    message.endMode = .noSend
                case 1:
                    message.endMode = .waitRsp
                case 2:
                    message.endMode = .sendCmd
                default:
                    OLog("❌Unknown DFUEndMode Value:\(modeValue)")
                    let err = SFOTAError.init(errorType: .General, errorDes: "未知的end Mode=\(modeValue)")
                    s.completion(s, nil, err)
                    return
                }
                
                if pd.count >= 4 {
                    // 含有Skip信息
                    var skip:UInt8 = 0
                    pd.getBytes(&skip, range: NSRange.init(location: 3, length: 1))
                    message.skip = skip != 0
                }
            }else{
                OLog("⚠️Old Image Start Response, Set DFUEndMode With 'noSend'")
                message.endMode = .noSend
            }
            
            s.completion(s,message, nil)
        }
    }

}
