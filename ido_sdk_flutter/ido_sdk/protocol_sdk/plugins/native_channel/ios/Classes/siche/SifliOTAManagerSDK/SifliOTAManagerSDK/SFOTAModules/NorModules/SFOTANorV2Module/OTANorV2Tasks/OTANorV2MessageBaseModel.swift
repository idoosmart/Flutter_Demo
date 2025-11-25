import UIKit

class OTANorV2MessageBaseModel: NSObject {

    let messageType:NorV2MessageType
    let payloadData:Data
    
    init(messageType: NorV2MessageType, payloadData:Data) {
        self.messageType = messageType
        self.payloadData = payloadData
        super.init()
    }

}
