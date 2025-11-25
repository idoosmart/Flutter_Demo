import UIKit

typealias NorV1ResultCompletion = (_ task:OTANorV1TaskBase, _ result:Int, _ error:SFOTAError?) -> Void


typealias NorV1BaseTaskCompletion = (_ task:OTANorV1TaskBase,_ msgModel:OTANorV1MessageBaseModel?, _ error:SFOTAError?)->Void

protocol OTANorV1BaseTaskDelegate:NSObjectProtocol {
    func norV1BaseTaskTimeout(task:OTANorV1TaskBase)
}

class OTANorV1TaskBase: NSObject {
    let messageType:NorV1MessageType
    
    var baseCompletion:NorV1BaseTaskCompletion?
    
    weak var delegate:OTANorV1BaseTaskDelegate?
    
    var timeout = 60.0
    private var timer:Timer?
        
    init(messageType: NorV1MessageType) {
        self.messageType = messageType
        super.init()
    }
    
    func name() -> String {
        return "NorV1TaskBase"
    }
    
    /// NandMessage的Data部分
    func marshalMsgPayloadData() -> Data{
        fatalError("\(self.classForCoder).marshalMsgPayloadData Not Implement!")
    }
    
    func toNorV1MessageData() -> Data {
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
        self.delegate?.norV1BaseTaskTimeout(task: self)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
