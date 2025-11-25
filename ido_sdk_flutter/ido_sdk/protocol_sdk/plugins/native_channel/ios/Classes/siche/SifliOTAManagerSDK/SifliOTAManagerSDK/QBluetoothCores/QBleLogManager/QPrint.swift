
import Foundation



func QPrint<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line,enableToDelegate:Bool = true){
    let msgDes = NSString.init(string: "\(message)")
    let fileDes = NSString.init(string: "\(file)")
    let funcDes = NSString.init(string: "\(funcName)")
    let lineDes = NSString.init(string: "\(lineNum)")
    
    if QBleLogManager.share.openLog {
        print("\n")
        NSLog("[SifliOTA][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
//        let timeString = QBleLogManager.share.logFormatTime(date: Date.init())
//        print("\(timeString)[SifliOTA][\(fileDes.lastPathComponent) \(funcDes)][\(lineDes)]\n\(msgDes)\n")
    }
    
}
