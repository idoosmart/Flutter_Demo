import UIKit

class OTANorV2TaskLoseCheckResponse: OTANorV2TaskBase {
    
    let result:UInt16
    
    override func name() -> String {
        return "NorV2LoseCheckResponse"
    }
    override func marshalMsgPayloadData() -> Data {
        var r = result
        var rData = Data.init(bytes: &r, count: 2)
        return rData
    }
    
    init(result: UInt16) {
        self.result = result
        super.init(messageType: .LINK_LOSE_CHECK_RESPONSE)
    }
    


}
