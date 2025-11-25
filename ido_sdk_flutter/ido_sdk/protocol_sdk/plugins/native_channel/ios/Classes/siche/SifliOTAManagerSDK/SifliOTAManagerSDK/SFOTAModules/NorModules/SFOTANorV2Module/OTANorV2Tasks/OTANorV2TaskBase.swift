import UIKit

typealias NorV2ResultCompletion = (_ task:OTANorV2TaskBase, _ result:Int, _ error:SFOTAError?) -> Void


typealias NorV2BaseTaskCompletion = (_ task:OTANorV2TaskBase,_ msgModel:OTANorV2MessageBaseModel?, _ error:SFOTAError?)->Void

protocol OTANorV2BaseTaskDelegate:NSObjectProtocol {
    func norV2BaseTaskTimeout(task:OTANorV2TaskBase)
}

class OTANorV2TaskBase: NSObject {
    
    let messageType:NorV2MessageType
    
    var baseCompletion:NorV2BaseTaskCompletion?
    
    weak var delegate:OTANorV2BaseTaskDelegate?
    
    var timeout = 60.0
    private var timer:Timer?
        
    init(messageType: NorV2MessageType) {
        self.messageType = messageType
        super.init()
    }
    
    func name() -> String {
        return "NorV2TaskBase"
    }
    
    /// NandMessage的Data部分
    func marshalMsgPayloadData() -> Data{
        fatalError("\(self.classForCoder).marshalMsgPayloadData Not Implement!")
    }
    
    func toNorV2MessageData() -> Data {
        var messageId = self.messageType.rawValue
        let messageIdData = Data.init(bytes: &messageId, count: 2)
        
        let payloadData = self.marshalMsgPayloadData()
        
        var length = UInt16(payloadData.count)
        let lengthData = Data.init(bytes: &length, count: 2)
        
        let packData = messageIdData + lengthData + payloadData
        
        return packData
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.init(timeInterval: timeout, target: self, selector: #selector(timeoutHandler(timer:)), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    @objc private func timeoutHandler(timer:Timer) {
        self.delegate?.norV2BaseTaskTimeout(task: self)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}
