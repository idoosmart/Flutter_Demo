import UIKit

class RetransmissionRsp{
    let result:Int
    let frequency:UInt16
    let completedCount:UInt32
    
    init(result: Int, frequency: UInt16, completedCount: UInt32) {
        self.result = result
        self.frequency = frequency
        self.completedCount = completedCount
    }
}

typealias NorV1RetransmissionRequestCompletion = (_ tsk:OTANorV1TaskRetransmissionRequest, _ retransRsp:RetransmissionRsp?, _ error:SFOTAError?) -> Void

class OTANorV1TaskRetransmissionRequest: OTANorV1TaskBase {
    let completion:NorV1RetransmissionRequestCompletion
    
    override func name() -> String {
        return "NorV1RetransmissionRequest"
    }
    override func marshalMsgPayloadData() -> Data {
        return Data.init()
    }
    
    init(completion:@escaping NorV1RetransmissionRequestCompletion) {
        self.completion = completion
        super.init(messageType: .Retransmit_Request)
        self.baseCompletion = {[weak self] (baseTask, message ,error) -> (Void) in
            guard let s = self else {
                return
            }
            if let err = error {
                s.completion(s, nil, err)
                return
            }
            let payload = message!.payloadData
            let pd = NSData.init(data: payload)
            
            if pd.count < 8 {
                let err = SFOTAError.InsufficientBytes(expectCount: 8, actualCount: pd.count)
                s.completion(s,nil,err)
                return
            }
            
            var r:UInt16 = 0
            pd.getBytes(&r, range: NSRange.init(location: 0, length: 2))
            
            var newF:UInt16 = 0
            pd.getBytes(&newF, range: NSRange.init(location: 2, length: 2))
            
            var completedCount:UInt32 = 0
            pd.getBytes(&completedCount, range: NSRange.init(location: 4, length: 4))
            
            let retrans = RetransmissionRsp.init(result: Int(r), frequency: newF, completedCount: completedCount)
            s.completion(s,retrans,nil)
        }
    }
}
