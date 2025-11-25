
import UIKit


public class QBleLogManager: NSObject {
    @objc public static let share = QBleLogManager.init()
    
//    private let dateFormat = DateFormatter.init()
    
    /// SDK内部日志开关。当关闭时，控制台不再打印内容，但QBleLogManagerDelegate的回调不受影响。
    @objc public var openLog:Bool = true
        
    private override init() {
//        dateFormat.dateFormat = "YYYY-MM-DD HH:mm:ss.sss"
        super.init()
    }
    
//    func logFormatTime(date:Date) -> String {
//        return dateFormat.string(from: date)
//    }

}
