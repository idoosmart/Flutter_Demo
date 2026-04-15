class SyncDataDelegateImpl: SyncDataDelegate {
    static let shared = SyncDataDelegateImpl()
    private init() {}
    

    var callbackProgress: BlockDataSyncProgress?
    var callbackSyncData: BlockDataSyncData?
    var callbackSyncCompleted: BlockDataSyncCompleted?
    private(set) var syncStatus: IDOSyncStatus = .`init`
    
    func callbackSyncProgress(progress: Double) throws {
        callbackProgress?(progress)
    }
    
    func callbackSyncData(type: ApiSyncDataType, jsonStr: String, errorCode: Int64) throws {
        callbackSyncData?(IDOSyncDataType(rawValue: type.rawValue)!, jsonStr, errorCode.int)
    }
    
    func callbackSyncCompleted(errorCode: Int64) throws {
        // 由于状态是异步从flutter传过来的,可能会有延迟，此处手动赋值
        syncStatus = .finished
        callbackSyncCompleted?(errorCode.int)
    }
    
    func listenSyncStatus(status: ApiSyncStatus) throws {
        syncStatus = IDOSyncStatus(rawValue: status.rawValue)!
    }
}
