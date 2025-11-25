import UIKit

class OTANandResTaskFileEndRequest: OTANandTaskBase {
    
    
    /// 协议中的file index是从1计数，避免混淆，命名为orderNumber
    let fileOrderNumber:UInt16
    
    let completion:ResultCompletion
    
    override func name() -> String {
        return "ResFileEndRequest"
    }
    
    init(fileOrderNumber: UInt16, completion:@escaping ResultCompletion) {
        self.fileOrderNumber = fileOrderNumber
        self.completion = completion
        super.init(messageType: .DFU_FILE_END_REQUEST)
        self.baseCompletion = {[weak self] (tsk,msg,error) in
            
            guard let s = self else {
                return
            }
            
            if let err = error {
                s.completion(s,-1, err)
                return
            }
            let payload = msg!.payloadData
            if payload.count < 2 {
                LogInsufficientMsgBytes(taskDes: "FileEndRequest", expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s,-1, err)
                return
            }
            
            let d = NSData.init(data: payload)
            var result:UInt16 = 0
            d.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            s.completion(s,Int(result),nil)
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        var order = self.fileOrderNumber
        let orderData = Data.init(bytes: &order, count: 2)
        return orderData
    }

}
