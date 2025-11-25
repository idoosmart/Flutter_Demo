import UIKit

typealias ResFileInitStartCompletion = (_ task:OTANandResTaskFileInitStart,
                                        _ result:UInt16,
                                        _ resumeState:UInt16,
                                        _ completedFileCount:UInt32,
                                        _ otaVersion:UInt32,
                                        _ fsBlock:UInt16,
                                        _ error:SFOTAError?) -> Void

class OTANandResTaskFileInitStart: OTANandTaskBase {
    
    
    let fileCount:UInt32
    
    let totalBytes:UInt32
    
    let phoneType:UInt16 = 1
    
    let versionLength:UInt16 = 4
    
    let version:UInt32
    
    let completion:ResFileInitStartCompletion
    
    override func name() -> String {
        return "ResFileInitStart"
    }
    
    init(fileCount: UInt32, totalBytes:UInt32,version: UInt32, completion:@escaping ResFileInitStartCompletion) {
        self.fileCount = fileCount
        self.totalBytes = totalBytes
        self.version = version
        self.completion = completion
        super.init(messageType: .DFU_FILE_INIT_START)
        self.baseCompletion = {[weak self] (task, model, error) in
            guard let s = self else {
                return
            }
            if let err = error {
                s.completion(s,0,0,0,0,0,err)
                return
            }
            let payload = NSData.init(data: model!.payloadData)
            
            var result:UInt16 = 0
            payload.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            var state:UInt16 = 0
            payload.getBytes(&state, range: NSRange.init(location: 2, length: 2))
            
            var count:UInt32 = 0
            payload.getBytes(&count, range: NSRange.init(location: 4, length: 4))
            
            var otaVersion:UInt32 = 0;
            var fsBlock:UInt16 = 0;
            if(payload.count >= 9){
                payload.getBytes(&otaVersion, range: NSRange.init(location: 8, length: 1))
            }
            if(payload.count >= 12){
                payload.getBytes(&fsBlock, range: NSRange.init(location: 10, length: 2))
            }
            
            s.completion(s,result,state,count,otaVersion,fsBlock,nil)
        }
    }
    
    override func marshalMsgPayloadData() -> Data {
        
        var fileCount = self.fileCount
        let fileCountData = Data.init(bytes: &fileCount, count: 4)
        
        var fileLength = self.totalBytes
        let fileLengthData = Data.init(bytes: &fileLength, count: 4)
        
        var phoneType = self.phoneType
        let phoneTypeData = Data.init(bytes: &phoneType, count: 2)
        
        var versionLen = self.versionLength
        let versionLenData = Data.init(bytes: &versionLen, count: 2)
        
        var version = self.version
        let versionData = Data.init(bytes: &version, count: 4)
        
        return fileCountData + fileLengthData + phoneTypeData + versionLenData + versionData
    }

}
