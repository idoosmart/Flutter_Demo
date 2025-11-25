import UIKit

class OTANorV1TaskImageResumeComplete: OTANorV1TaskBase {
    
    let flag:UInt8

    override func name() -> String {
        return "NorV1ImageResumeComplete"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var f = self.flag
        let fData = Data.init(bytes: &f, count: 1)
        return fData
    }
    
    init(flag:UInt8) {
        self.flag = flag
        super.init(messageType: .Resume_Completed)
    }

}
