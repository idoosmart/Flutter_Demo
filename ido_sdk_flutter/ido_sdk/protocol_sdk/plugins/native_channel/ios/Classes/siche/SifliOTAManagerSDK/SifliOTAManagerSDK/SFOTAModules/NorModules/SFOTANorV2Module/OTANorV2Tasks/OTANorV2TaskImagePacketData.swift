import UIKit

class OTANorV2TaskImagePacketData: OTANorV2TaskBase {
    
    let imageID:NorImageID
    
    let imageOrderNumber:UInt16
    
    let data:Data
    
    let completion:NorV2ResultCompletion?
    
    override func name() -> String {
        return "NorV2ImagePacketData"
    }

    override func marshalMsgPayloadData() -> Data {
        var imageIdValue = UInt16(self.imageID.rawValue)
        let imageIdData = Data.init(bytes: &imageIdValue, count: 2)
        
        var order = self.imageOrderNumber
        let orderData = Data.init(bytes: &order, count: 2)
        
        var len = UInt16(self.data.count)
        let lenData = Data.init(bytes: &len, count: 2)
        
        return imageIdData + orderData + lenData + data
    }
    
    init(imageID: NorImageID, imageOrderNumber: UInt16, data: Data, completion: NorV2ResultCompletion?) {
        self.imageID = imageID
        self.imageOrderNumber = imageOrderNumber
        self.data = data
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_PACKET_DATA)
        
        if self.completion != nil {
            self.baseCompletion = {[weak self] (tsk, msg, error) in
                guard let s = self else {
                    return
                }
                if let err = error {
                    s.completion?(s,-1,err)
                    return
                }
                
                let payload = msg!.payloadData
                if payload.count < 2{
                    LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: payload.count)
                    let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                    s.completion?(s, -1, err)
                    return
                }
                
                let pd = NSData.init(data: payload)
                var result:UInt16 = 0
                pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
                s.completion?(s,Int(result), nil)
            }
        }
        
    }
}
