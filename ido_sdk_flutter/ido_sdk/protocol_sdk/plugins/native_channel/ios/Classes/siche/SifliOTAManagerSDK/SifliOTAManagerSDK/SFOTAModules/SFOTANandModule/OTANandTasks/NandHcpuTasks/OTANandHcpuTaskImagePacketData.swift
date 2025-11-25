import UIKit

class OTANandHcpuTaskImagePacketData: OTANandTaskBase {
    
    let imageID:NandImageID
    
    let imageOrderNumber:UInt32
    
    let data:Data
    let otaVersion:UInt32
    
    let completion:ResultCompletion?
    
    override func name() -> String {
        return "ImagePacketData"
    }
    
    init(imageID: NandImageID, imageOrderNumber: UInt32, data: Data,otaVersion:UInt32, completion: ResultCompletion?) {
        self.imageID = imageID
        self.imageOrderNumber = imageOrderNumber
        self.data = data
        self.completion = completion
        self.otaVersion = otaVersion
        super.init(messageType: .DFU_IMAGE_PACKET_DATA)
        
        if self.completion != nil {
            self.baseCompletion = {[weak self] (tsk, msg, error) in
                guard let s = self else {
                    return
                }
                if let err = error {
                    LogTaskError(taskDes: s.name(), error: err)
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
    
    override func marshalMsgPayloadData() -> Data {
        
        var imageIdValue = self.imageID.rawValue
        let imageIdData = Data.init(bytes: &imageIdValue, count: 2)
        
        var order = self.imageOrderNumber
        let orderData = Data.init(bytes: &order, count: 4)
        
        var len = UInt16(self.data.count)
        let lenData = Data.init(bytes: &len, count: 2)
        
        if self.otaVersion >= 2 {
            return orderData + imageIdData + lenData + data
        }else{
            var order16 = UInt16(self.imageOrderNumber)
            let order16Data = Data.init(bytes: &order16, count: 2)
            return imageIdData + order16Data + lenData + data
        }
        
    }

}
