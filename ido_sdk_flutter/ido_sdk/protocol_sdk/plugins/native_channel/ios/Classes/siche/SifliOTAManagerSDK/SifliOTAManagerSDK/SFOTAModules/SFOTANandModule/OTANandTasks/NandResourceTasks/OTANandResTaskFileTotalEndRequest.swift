import UIKit

class OTANandResTaskFileTotalEndRequest: OTANandTaskBase {
    
    let hcpuUpdate:Bool
    
    let completion:ResultCompletion
    
    override func name() -> String {
        return "ResFileTotalEndRequest"
    }
    
    init(hcpuUpdate: Bool, completion:@escaping ResultCompletion) {
        self.hcpuUpdate = hcpuUpdate
        self.completion = completion
        super.init(messageType: .DFU_FILE_TOTAL_END_REQUEST)
        
        self.timeout = 60.0
        
        self.baseCompletion = {[weak self] (tsk, msg, error) in
            guard let s = self else {
                return
            }
            if let err = error {
                s.completion(s,-1,err)
                return
            }
            let payload = msg!.payloadData
            if payload.count < 2 {
                LogInsufficientMsgBytes(taskDes: "FileTotalEnd", expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s,-1,err)
                return
            }
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            s.completion(s,Int(result), nil)
        }
    }

    override func marshalMsgPayloadData() -> Data {
        var update:UInt16 = self.hcpuUpdate ? 1:0
        let updateData = Data.init(bytes: &update, count: 2)
        return updateData
    }
}
