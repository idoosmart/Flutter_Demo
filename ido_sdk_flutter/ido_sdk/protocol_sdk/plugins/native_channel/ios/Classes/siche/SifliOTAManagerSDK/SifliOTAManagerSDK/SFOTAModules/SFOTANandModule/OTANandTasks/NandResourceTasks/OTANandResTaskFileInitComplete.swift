import UIKit

class OTANandResTaskFileInitComplete: OTANandTaskBase {
    
    let resume:Bool
    let needBlockCount:UInt32
    let otaVersion:Int
    
    override func name() -> String {
        return "ResFileInitComplete"
    }
    
    init(resume:Bool,totalBlockCount:Int,otaVersion:Int) {
        self.resume = resume
        self.needBlockCount = UInt32(totalBlockCount)
        self.otaVersion = otaVersion;
        super.init(messageType: .DFU_FILE_INIT_COMLETED)
    }
    
    override func marshalMsgPayloadData() -> Data {
        var resumeValue:UInt8 = resume ? 1:0
        let resumeData = Data.init(bytes: &resumeValue, count: 1)
        if otaVersion == 0{
            return resumeData;
        }else{
            //version 1
            var needBlockCountValue = needBlockCount
            let blockSizeData = Data.init(bytes: &needBlockCountValue, count: 4)
            return resumeData + blockSizeData
        }
      
    }

}
