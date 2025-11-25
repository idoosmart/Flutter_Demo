import UIKit

class OTANorV1TaskEndInd: OTANorV1TaskBase {

    let result:UInt8
    
    override func name() -> String {
        return "NorV1EndInd"
    }
    
    override func marshalMsgPayloadData() -> Data {
        var r = result
        let d = Data.init(bytes: &r, count: 1)
        return d
    }

    init(result: UInt8) {
        self.result = result
        super.init(messageType: .Transmission_End_Response)
    }
}
