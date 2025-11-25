import Foundation

func OLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line,enableToDelegate:Bool = true){
    let msgDes = NSString.init(string: "\(message)")
    let fileDes = NSString.init(string: "\(file)")
    let funcDes = NSString.init(string: "\(funcName)")
    let lineDes = NSString.init(string: "\(lineNum)")
    
    if SFOTALogManager.share.logEnable {
//        print("\n")
        NSLog("[SifliOTA][V\(Const_SDKVersion)][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
    }
    
    if enableToDelegate {
        if (SFOTALogManager.share.delegate != nil) {
            let now = Date.init()
            let ms = Int(now.timeIntervalSince1970 * 1000)
            let msg = String.init(format: "[SifliOTA][V\(Const_SDKVersion)][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
            let model = SFOTALogModel.init(timestamp: ms, message: msg)
            SFOTALogManager.share.delegate?.otaLogManager(manager: SFOTALogManager.share, onLog: model, logLevel: .info)
        }
    }
}
