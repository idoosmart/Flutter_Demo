import UIKit

class OTANandTaskLoseCheckResponse: OTANandTaskBase {
    
    let result:UInt16
    
    init(result: UInt16) {
        self.result = result
        super.init(messageType: .LINK_LOSE_CHECK_RESPONSE)
    }
    
    override func marshalMsgPayloadData() -> Data {
        var r = result
        var rData = Data.init(bytes: &r, count: 2)
        return rData
    }

}
