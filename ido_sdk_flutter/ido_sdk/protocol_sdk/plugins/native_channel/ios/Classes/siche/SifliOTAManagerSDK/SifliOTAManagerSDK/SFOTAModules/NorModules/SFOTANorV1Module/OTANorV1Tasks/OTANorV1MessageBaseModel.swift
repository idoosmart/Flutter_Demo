import UIKit

class OTANorV1MessageBaseModel: NSObject {
    let messageType:NorV1MessageType
    let payloadData:Data
    
    init(messageType: NorV1MessageType, payloadData:Data) {
        self.messageType = messageType
        self.payloadData = payloadData
        super.init()
    }
}
