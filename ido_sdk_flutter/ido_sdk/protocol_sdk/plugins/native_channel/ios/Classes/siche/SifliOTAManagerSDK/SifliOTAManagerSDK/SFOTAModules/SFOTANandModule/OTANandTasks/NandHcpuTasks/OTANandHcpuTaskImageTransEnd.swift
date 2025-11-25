import UIKit

class OTANandHcpuTaskImageTransEnd: OTANandTaskBase {
    
    
    /// 固定为0
    private let value:UInt8 = 0
    
    
    let completion:ResultCompletion
    
    override func name() -> String {
        return "ImageTransmissionEnd"
    }
    
    init(completion:@escaping ResultCompletion){
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_TRANSMISSION_END)
        
        self.baseCompletion = {[weak self] (tsk,msg,error) in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,-1,err)
                return
            }
            
            let payload = msg!.payloadData
            if payload.count < 1{
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 1, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s, -1, err)
                return
            }
            
            let pd = NSData.init(data: payload)
            var result:UInt8 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 1))
            s.completion(s,Int(result), nil)
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        var v = value
        let vData = Data.init(bytes: &v, count: 1)
        return vData
    }

}
