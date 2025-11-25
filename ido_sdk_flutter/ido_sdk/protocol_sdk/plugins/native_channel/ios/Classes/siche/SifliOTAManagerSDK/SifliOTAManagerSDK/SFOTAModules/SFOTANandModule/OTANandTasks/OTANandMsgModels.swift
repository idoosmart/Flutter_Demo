import Foundation

class OTANandMessageBaseModel: NSObject {
    let messageType:NandMessageType
    let payloadData:Data
    
    init(messageType: NandMessageType, payloadData:Data) {
        self.messageType = messageType
        self.payloadData = payloadData
        super.init()
    }
}
