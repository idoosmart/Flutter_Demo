import UIKit


class NorProgressRecord: NSObject {
    
    
    /// 资源文件的总大小
    var totalBytes = 0
    
    /// 当前正在发送的文件索引
    var currentFileIndex = 0
    
    /// 当前已经完成的文件数据片段
    var completedFileSliceCount = 0
    
    /// 默认的回复频率，用于reset时
    var defaultFrequnecy = 20 {
        didSet{
            OLog("⚠️修改defaultFrequnecy: \(oldValue) ====> \(defaultFrequnecy)")
        }
    }

    
    var responseFrequency = 1{
        didSet{
            OLog("⚠️修改responseFrequency: \(oldValue) ====> \(responseFrequency)")
        }
    }
    
    
    /// 连续发送无响应Packet的数量
    var continueSendNoResponsePacketCount = 0
    
    func reset(){
        totalBytes = 0
        currentFileIndex = 0
        completedFileSliceCount = 0
        responseFrequency = defaultFrequnecy
        continueSendNoResponsePacketCount = 0
    }

}
