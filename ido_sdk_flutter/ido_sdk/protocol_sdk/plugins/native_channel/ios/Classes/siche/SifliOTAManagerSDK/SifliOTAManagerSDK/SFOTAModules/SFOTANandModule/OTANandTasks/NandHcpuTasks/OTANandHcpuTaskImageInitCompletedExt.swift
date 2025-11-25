import UIKit

class OTANandHcpuTaskImageInitCompletedExt: OTANandTaskBase {
    
    
    /// 是否进行续传
    let resume:Bool
    
    override func name() -> String {
        return "ImageInitCompletedExt"
    }
    
    init(resume: Bool) {
        self.resume = resume
        super.init(messageType: .DFU_IMAGE_INIT_COMPLETED_EXT)
    }
    
    override func marshalMsgPayloadData() -> Data {
        var resumeValue:UInt8 = resume ? 1:0
        var resumeData = Data.init(bytes: &resumeValue, count: 1)
        return resumeData
    }

}
