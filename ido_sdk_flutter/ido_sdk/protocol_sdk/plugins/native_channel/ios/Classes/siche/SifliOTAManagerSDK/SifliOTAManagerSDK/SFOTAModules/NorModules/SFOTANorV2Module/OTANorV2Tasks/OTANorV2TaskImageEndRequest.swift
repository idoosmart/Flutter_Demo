import UIKit

class OTANorV2TaskImageEndRequest: OTANorV2TaskBase {
    
    let imageId:NorImageID
    
    let moreImage:Bool
    
    let completion:NorV2ResultCompletion
    
    override func name() -> String {
        return "NorV2ImageEndRequest"
    }

    override func marshalMsgPayloadData() -> Data {
        var imageIdValue = self.imageId.rawValue
        let imageIdData = Data.init(bytes: &imageIdValue, count: 1)
        
        var moreValue:UInt8 = self.moreImage ? 1:0
        let moreData = Data.init(bytes: &moreValue, count: 1)
        
        return imageIdData + moreData
    }
    
    init(imageId: NorImageID, moreImage: Bool, completion: @escaping NorV2ResultCompletion) {
        self.imageId = imageId
        self.moreImage = moreImage
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_END_REQUEST)
        
        self.baseCompletion = {[weak self] (tsk,msg,error) in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,-1,err)
                return
            }
            
            let payload = msg!.payloadData
            if payload.count < 2{
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s, -1, err)
                return
            }
            
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            s.completion(s,Int(result), nil)
        }
    }
}
