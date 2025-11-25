
import Foundation

@objc enum QErrorType:Int {
    case Unknown = 0
    case Timeout
    case Canceled
    case Disconnected
    case FailedToConnect
}

@objc class QError:NSObject{
    
    /// 错误类型
    @objc public var errType:QErrorType = .Unknown
    
    /// 错误信息
    @objc public var errInfo = ""
    
    /// 错误码
    @objc public var errCode:Int = -1
    @objc override public var description: String {
        return "errType=\(self.errType.rawValue),errInfo=\(self.errInfo)"
    }
    
    @objc override public init(){
        super.init()
    }
}
