import UIKit

typealias NorV1ImageStartRequestCompletion = (_ tsk:OTANorV1TaskImageStartRequest, _ result:Int, _ endMode:NorEndMode?, _ error:SFOTAError?) -> Void

class OTANorV1TaskImageStartRequest: OTANorV1TaskBase {
    
    let fileSize:UInt32
    let sliceCount:UInt32
    let frequency:UInt8
    let imageID:NorImageID
    let completion:NorV1ImageStartRequestCompletion
    
    override func name() -> String {
        return "NorV1ImageStartRequest"
    }
    
    override func marshalMsgPayloadData() -> Data {
        let data = NSMutableData.init()
        var size:UInt32 = fileSize
        var count:UInt32 = sliceCount
        var f:UInt8 = frequency
        var id:UInt8 = imageID.rawValue
        data.append(&size, length: 4)
        data.append(&count, length: 4)
        data.append(&f, length: 1)
        data.append(&id, length: 1)
        return Data.init(referencing: data)
    }
    
    init(fileSize: UInt32, sliceCount: UInt32, frequency: UInt8, imageID: NorImageID, completion:@escaping NorV1ImageStartRequestCompletion) {
        self.fileSize = fileSize
        self.sliceCount = sliceCount
        self.frequency = frequency
        self.imageID = imageID
        self.completion = completion
        super.init(messageType: .Image_Send_Start)
        self.baseCompletion = {[weak self] tsk,msg,error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: s.name(), error: err)
                s.completion(s,-1,nil,err)
                return
            }
            
            let payload = msg!.payloadData
            let pd = NSData.init(data: payload)
            if pd.count < 2 {
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: pd.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: pd.count)
                s.completion(s, -1, nil, err)
                return
            }
            var r:UInt16 = 0
            pd.getBytes(&r, length: 2)
            
            var endMode:NorEndMode = .noSend
            if pd.count >= 3 {
                var modeValue:UInt8 = 0
                pd.getBytes(&modeValue, range: NSRange.init(location: 2, length: 1))
                guard let m = NorEndMode.init(rawValue: modeValue) else {
                    QPrint("❌Unknown DFUEndMode Value:\(modeValue)")
                    let err = SFOTAError.init(errorType: .General, errorDes: "Unknown DFUEndMode:\(modeValue)")
                    s.completion(s,-1,nil,err)
                    return
                }
                endMode = m
            }else{
                QPrint("⚠️Old Image Start Response, Set DFUEndMode With 'noSend'")
            }
            s.completion(s,Int(r), endMode, nil)
        }
    }
}
