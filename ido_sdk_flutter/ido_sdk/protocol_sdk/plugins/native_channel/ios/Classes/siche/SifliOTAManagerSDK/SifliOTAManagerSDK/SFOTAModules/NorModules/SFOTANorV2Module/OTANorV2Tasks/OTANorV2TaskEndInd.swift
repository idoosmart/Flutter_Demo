import UIKit

class OTANorV2TaskEndInd: OTANorV2TaskBase {
    
    let result:UInt8
    
    override func name() -> String {
        return "NorV2EndInd"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var r = result
        let d = Data.init(bytes: &r, count: 1)
        return d
    }

    init(result: UInt8) {
        self.result = result
        super.init(messageType: .DFU_IMAGE_END)
    }
}
