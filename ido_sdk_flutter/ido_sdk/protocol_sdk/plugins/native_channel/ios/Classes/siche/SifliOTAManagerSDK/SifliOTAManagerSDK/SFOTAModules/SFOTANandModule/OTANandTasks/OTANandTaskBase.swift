import UIKit

typealias ResultCompletion = (_ task:OTANandTaskBase, _ result:Int, _ error:SFOTAError?) -> Void


typealias BaseTaskCompletion = (_ task:OTANandTaskBase,_ msgModel:OTANandMessageBaseModel?, _ error:SFOTAError?)->Void

protocol OTANandBaseTaskDelegate:NSObjectProtocol {
    func nandBaseTaskTimeout(task:OTANandTaskBase)
}

class OTANandTaskBase: NSObject {
        
    let messageType:NandMessageType
    
    var baseCompletion:BaseTaskCompletion?
    
    weak var delegate:OTANandBaseTaskDelegate?
    
    var timeout = 60.0
    private var timer:Timer?
        
    init(messageType: NandMessageType) {
        self.messageType = messageType
        super.init()
    }
    
    func name() -> String {
        return "NandTaskBase"
    }
    
    /// NandMessage的Data部分
    func marshalMsgPayloadData() -> Data{
        fatalError("\(self.classForCoder).marshalMsgPayloadData Not Implement!")
    }
    
    func toNandMessageData() -> Data {
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
        self.delegate?.nandBaseTaskTimeout(task: self)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimeoutMin180(fileLength: UInt32){
        let timeoutf = (Double(fileLength) / (1024 * 1024)) * 0.7
        if timeoutf < 180 {
            self.timeout = 180.0
        }else{
            self.timeout = timeoutf
        }
        OLog("updateTimeoutMin180 \(self.timeout)")
    }
}
