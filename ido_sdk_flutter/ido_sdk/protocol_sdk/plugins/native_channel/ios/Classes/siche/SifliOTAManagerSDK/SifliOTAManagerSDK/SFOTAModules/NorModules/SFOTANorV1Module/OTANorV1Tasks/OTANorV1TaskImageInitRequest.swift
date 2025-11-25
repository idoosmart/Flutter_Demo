import UIKit

typealias NorV1ImageInitRequestCompletion = (_ task:OTANorV1TaskImageInitRequest, _ result:Int,_ reboot:Bool, _ error:SFOTAError?) -> Void

class OTANorV1TaskImageInitRequest: OTANorV1TaskBase {
    
    let ctrlFile:Data
    
    let force:Bool
    
    let completion:NorV1ImageInitRequestCompletion
    
    override func name() -> String {
        return "NorV1ImageInitRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        let d = self.ctrlFile
        return d
    }
    
    init(ctrlFile: Data, force: Bool, completion:@escaping NorV1ImageInitRequestCompletion) {
        self.ctrlFile = ctrlFile
        self.force = force
        self.completion = completion
        let type:NorV1MessageType = force ? .Force_Init_Request:.Init_Request
        super.init(messageType: type)
        
        self.baseCompletion = {[weak self] tsk, message, error in
            
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,-1,false,err)
                return
            }
            let payload = message!.payloadData
            let pd = NSData.init(data: payload)
            
            var r:UInt16 = 0
            pd.getBytes(&r, length: 2)
            let result = Int(r)
            
            var boot:UInt8 = 0
            pd.getBytes(&boot, range: NSRange.init(location: 2, length: 1))
            let reboot = (boot == 1)
            
            s.completion(s, result, reboot, nil)
        }
    }
    
}
