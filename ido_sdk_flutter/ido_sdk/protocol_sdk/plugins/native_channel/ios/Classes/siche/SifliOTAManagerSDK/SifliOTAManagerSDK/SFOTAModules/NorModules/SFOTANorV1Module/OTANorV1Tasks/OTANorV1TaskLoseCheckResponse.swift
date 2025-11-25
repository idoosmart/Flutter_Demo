import UIKit

class OTANorV1TaskLoseCheckResponse: OTANorV1TaskBase {
    
    let result:UInt16
    
    override func name() -> String {
        return "NorV1LoseCheckResponse"
    }
    override func marshalMsgPayloadData() -> Data {
        var r = result
        var rData = Data.init(bytes: &r, count: 2)
        return rData
    }
    
    init(result: UInt16) {
        self.result = result
        super.init(messageType: .Link_Lose_Check_Response)
    }

}
