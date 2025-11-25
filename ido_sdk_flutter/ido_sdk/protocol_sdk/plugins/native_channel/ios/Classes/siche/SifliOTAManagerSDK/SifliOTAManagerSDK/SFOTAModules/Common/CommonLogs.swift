import Foundation

func LogInsufficientMsgBytes(taskDes:String,expect:Int, actual:Int) {
    OLog("❌\(taskDes)的Payload字节长度不足: expect '\(expect)' bytes, but '\(actual)'")
}
func LogDevErrorCode(taskDes:String, errorCode:Int) {
    OLog("❌\(taskDes)设备返回错误码:\(errorCode)")
}
func LogTaskError(taskDes:String, error:SFOTAError) {
    OLog("❌\(taskDes)错误:\(error.debugDescription)")
}
