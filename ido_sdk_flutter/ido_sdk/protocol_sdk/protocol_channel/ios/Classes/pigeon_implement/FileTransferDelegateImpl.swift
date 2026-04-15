class FileTransferDelegateImpl: FileTransferDelegate {
    static let shared = FileTransferDelegateImpl()
    private init() {}
    
    var callbackFileTrasnStatus: BlockFileTransStatus?
    var callbackFileTransProgress: BlockFileTransProgress?
    
    var callbackDeviceFileTransTask: BlockDeviceFileToAppTask?
    var callbackDeviceFileTransProgress: ((_ progress :Double) -> Void)?
    var callbackDeviceFileTransComplete: ((_ isCompleted: Bool, _ receiveFilePath: String?) -> Void)?
    var deviceFileToAppTask: IDODeviceFileToAppTask?
    
    private var lastTransStatus: ApiTransStatus?
    private(set) var currentTransType: IDOTransType?
    
    func listenTransFileTypeChanged(fileType: ApiTransType?) throws {
        guard let fileType = fileType else {
            currentTransType = nil
            return
        }
        currentTransType = IDOTransType(rawValue: fileType.rawValue)
    }
    
    func fileTransStatusMultiple(index: Int64, status: ApiTransStatus) throws {
        //print("fileTransStatusMultiple - idx:\(index) status:\(status)")
        lastTransStatus = status
        //callbackFileTrasnStatus?(index.int, IDOTransStatus(rawValue: status.rawValue), nil, nil)
    }
    
    func fileTransProgressMultiple(currentIndex: Int64, totalCount: Int64, currentProgress: Double, totalProgress: Double) throws {
        callbackFileTransProgress?(currentIndex.int, totalCount.int, Float(currentProgress), Float(totalProgress))
    }
    
    func fileTransErrorCode(index: Int64, errorCode: Int64, errorCodeFromDevice: Int64, finishingTime: Int64) throws {
        //print("fileTransErrorCode - idx:\(index) errorCode:\(errorCode) errorCodeFromDevice:\(errorCodeFromDevice) finishingTime:\(finishingTime)")
        let errCode = errorCode.int
        let finishingTime = (errCode == 24 || errCode == 25) ? finishingTime.int : 0
        let status = lastTransStatus != nil ? IDOTransStatus(rawValue: lastTransStatus!.rawValue)! : IDOTransStatus.none
        callbackFileTrasnStatus?(index.int, status, errorCode.int, finishingTime)
    }
    
    func deviceToAppTransItem(deviceTransItem: ApiDeviceTransItem) throws {
        var fileType: IDODeviceTransType = .accLog
        if let type = IDODeviceTransType.init(rawValue: Int(deviceTransItem.fileType ?? 0x15)) {
            fileType = type
        }else {
            _logNative("异常：设备返回不支持的文件类型：\(deviceTransItem.fileType ?? 0)")
        }
        let item = IDODeviceTransItem(fileType: fileType,
                                      fileSize: Int(deviceTransItem.fileSize ?? 0),
                                      fileCompressionType: Int(deviceTransItem.fileCompressionType ?? 0),
                                      fileName: deviceTransItem.fileName ?? "unkonw",
                                      filePath: deviceTransItem.filePath)
        let task = IDODeviceFileToAppTask(deviceTransItem: item);
        deviceFileToAppTask = task
        callbackDeviceFileTransTask?(task)
    }
    
    func deviceToAppTransProgress(progress: Double) throws {
        callbackDeviceFileTransProgress?(progress)
    }
    
    func deviceToAppTransStatus(isCompleted: Bool, receiveFilePath: String?) throws {
        callbackDeviceFileTransComplete?(isCompleted, receiveFilePath)
    }
    
}
