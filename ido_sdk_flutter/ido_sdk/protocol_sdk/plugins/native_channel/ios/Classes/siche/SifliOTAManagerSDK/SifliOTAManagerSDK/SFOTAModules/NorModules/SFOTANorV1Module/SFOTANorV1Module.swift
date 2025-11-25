import UIKit
import CoreBluetooth

fileprivate enum NorV1MainStatus {
    case none
    case initialConnecting // 最开始的连接，包含了Manager的searching和connecting过程
    case initial   // 处于Image Init交互阶段
    case waitingDevReboot // 等待设备重启
    case imageConnecting // 发送image前的连接
    case image   // 发送image阶段
}

@objc public enum NorV1TriggerMode:Int {
    /// 普通模式
    case normal = 0
    
    /// 强制启动
    case force
    
    /// 续传
    case resume
}

class SFOTANorV1Module: SFOTAModuleBase,OTANorV1BaseTaskDelegate {
    
    /// 获取SFOTANorV1Module单例对象
    @objc static let share = SFOTANorV1Module.init(name: "Nor_V1")
    private override init(name: String) {
        super.init(name: name)
    }
    
    weak var delegate:SFOTAModuleDelegate?
    
    /// 升级Image时所需要首先发送的control文件
    private var controlFile:Data?
    
    /// image文件序列，根据id值升序排列，同id的文件只能有1个
    private var imageFileArray = Array<NorImageFile>.init()
    
    private var triggerMode:NorV1TriggerMode = .normal
    
    private var endMode:NorEndMode = .noSend {
        didSet{
            OLog("⚠️修改EndMode:\(oldValue) ==> \(endMode)")
        }
    }
    
    /// 当前正在等待响应的任务
    private var currentTask:OTANorV1TaskBase?
    
    private var delayRestartTimer:Timer?
    
    private let progress = NorProgressRecord.init()
    private var completedBytes:Int {
        if imageFileArray.count <= progress.currentFileIndex {
            return 0
        }
        let curFile = imageFileArray[progress.currentFileIndex]
        if curFile.dataSliceArray.count < progress.completedFileSliceCount {
            return 0
        }
        var completed = 0
        if progress.currentFileIndex > 0 {
            for i in 0..<progress.currentFileIndex {
                completed += imageFileArray[i].data.count
            }
        }
        if progress.completedFileSliceCount == curFile.dataSliceArray.count {
            // 最后一个包
            completed += curFile.data.count
        }else{
            completed += progress.completedFileSliceCount * NorImageFile.SliceLength
        }
        return completed
    }
    
    private let maxRetransCount = 5
    private var retransCount = 0
    
    /// 模块当前所处的主要状态
    private var mainStatus:NorV1MainStatus = .none {
        didSet{
            OLog("ℹ️设置NorV1MainStatus:\(oldValue) ==> \(mainStatus)")
        }
    }
    
    private var isLoseChecking = false {
        didSet{
            OLog("⚠️修改isLoseChecking状态: \(oldValue) ===> \(isLoseChecking)")
        }
    }

    override func bleEventHandler(bleCore: QBleCore, event: BleEvent, object: Any?) {
        var coreError:QError?
        if let err = object as? QError {
            coreError = err
        }
        var otaError:SFOTAError?
        if let err = object as? SFOTAError {
            otaError = err
        }
        if event == .searchingTimeout {
            // 搜索超时
            if self.mainStatus == .initialConnecting || self.mainStatus == .imageConnecting {
                // 只在该阶段才处理连接超时回调
                let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索目标外设超时")
                // Manager在该回调中统一对Module执行clear操作
                self.delegate?.otaModuleCompletion(module: self, error: error)
            }else {
                OLog("⚠️[异常]NorV1Module处于\(mainStatus)状态，收到了搜索超时的消息")
            }
        }else if event == .disconnected {
            if mainStatus == .waitingDevReboot {
                // 等待设备重启中，这里发起重连请求
                mainStatus = .imageConnecting
                self.delegate?.otaModuleReconnectRequest(module: self)
                return
            }
            var error:SFOTAError!
            if coreError != nil {
                error = SFOTAError.init(qError: coreError!)
            }else if otaError != nil {
                error = otaError
            }else{
                OLog("⚠️没有收到BleCore的断连描述信息")
                error = SFOTAError.init(errorType: .Disconnected, errorDes: "蓝牙断开")
            }
            /// 在Manager中处理clear等工作
            self.delegate?.otaModuleCompletion(module: self, error: error)
        }else if event == .shakedHands {
            // 仅在下面两个状态下才处理连接成功的阶段处理该事件，其它时候忽略该事件
            if mainStatus == .initialConnecting {
                self.norV1StepInitial()
            } else if mainStatus == .imageConnecting {
                self.norV1StepImageStartRequest()
            }else {
                OLog("⚠️收到连接成功的蓝牙事件,当前Module状态为\(self.mainStatus)")
            }
            
        }else if event == .updateState {
            // 手动关闭蓝牙会触发该状态；应发起主动断连的操作
            let state = object as! BleCoreManagerState
            if state == .poweredOff && self.mainStatus != .none {
                self.delegate?.otaModuleDisconnectRequest(module: self)
            }
        }else if event == .failedToConnect{
            var error:SFOTAError!
            if coreError != nil {
                error = SFOTAError.init(qError: coreError!)
            }else if otaError != nil {
                error = otaError
            }else{
                OLog("⚠️failedToConnect")
                error = SFOTAError.init(errorType: .FailedToConnect, errorDes: "蓝牙连接失败")
            }
            /// 在Manager中处理clear等工作
            self.delegate?.otaModuleCompletion(module: self, error: error)
        }else {
            // 预留
            OLog("⚠️未知的蓝牙Event:\(event)")
        }
    }
    
    override func bleDataHandler(bleCore: QBleCore, data: Data) {
        // data已经是从SerialTransport结构中解析出的Data部分
        
        //1、解析成NorV1的Message结构
        if data.count < 5{
            // 为保证Message的data部分一定有数据，长度至少为5字节
            OLog("❌解析NorV1Message失败: 数据长度(\(data.count))小于5字节。")
            return
        }
        let d = NSData.init(data: data)
        var messageIdValue:UInt16 = 0
        d.getBytes(&messageIdValue, range: NSRange.init(location: 0, length: 2))
        
        guard let messageType = NorV1MessageType.init(rawValue: messageIdValue) else {
            OLog("❌解析NorV1MessageType失败: 未知的message id = \(messageIdValue)")
            return
        }
        // 校验Length与Data长度是否匹配
        var length:UInt16 = 0
        d.getBytes(&length, range: NSRange.init(location: 2, length: 2))
        let messageData = d.subdata(with: NSRange.init(location: 4, length: d.length - 4))
        if messageData.count != length {
            OLog("❌MessageLength（\(length)）与MessageData实际长度(\(messageData.count))不等")
            return
        }
        let norV1Msg = OTANorV1MessageBaseModel.init(messageType: messageType, payloadData: messageData)
        if let curTsk = self.currentTask {
            // 当前有在等待响应的任务, 对比是否是req-rsp组合
            let isPaired = NorV1MessageUtils.IsPaired(request: curTsk.messageType, response: norV1Msg.messageType)
            if isPaired {
                // 移除当前任务，以及关闭超时计时器
                self.currentTask = nil
                curTsk.stopTimer()
                
                // 触发回调。在其子类各自的completion中去解析具体的数据
                curTsk.baseCompletion?(curTsk,norV1Msg,nil)
                return
            }
        }
        
        /// 可能是其它设备主动发来的消息
        if norV1Msg.messageType == .Link_Lose_Check_Request {
            // 调整发送序列的指令，需要SDK回复
            let payload = norV1Msg.payloadData
            if payload.count < 8 {
                OLog("⚠️收到设备的Link_Lose_Check_Request,但payload字节数不足8。")
                return
            }
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            var rspFreq:UInt16 = 0
            pd.getBytes(&rspFreq, range: NSRange.init(location: 2, length: 2))
            
            var completedCount:UInt32 = 0
            pd.getBytes(&completedCount, range: NSRange.init(location: 4, length: 4))
            OLog("⚠️收到LoseCheckRequest: result=\(result), rspFreq=\(rspFreq), completedCount=\(completedCount)")
            
            // 判断解析出的几个参数是否与当前状态有冲突
            if rspFreq == 0 {
                OLog("⚠️LoseCheckRequest.RspFreq==0，忽略LoseCheckRequest")
                return
            }
            
            if  mainStatus != .image{
                OLog("⚠️当前未在Image发送阶段，忽略LoseCheckRequest")
                return
            }
            
            let curFile = self.imageFileArray[self.progress.currentFileIndex]
            let sliceCount = curFile.dataSliceArray.count
            if sliceCount <= completedCount {
                OLog("⚠️completedCount(\(completedCount))大于等于imageFile(\(curFile.dataSliceArray.count))总包数，忽略LoseCheckRequest")
                return
            }
            progress.completedFileSliceCount = Int(completedCount)
            progress.responseFrequency = Int(rspFreq)
            progress.continueSendNoResponsePacketCount = Int(completedCount) % Int(rspFreq)
            
            self.isLoseChecking = true
            
            // 移除currentTask，即暂停发送
            self.currentTask?.stopTimer()
            self.currentTask = nil
            
            self.delayRestartTimer?.invalidate()
            self.delayRestartTimer = nil
            
            // 回复设备,协议中规定result暂时填0
            let rspTask = OTANorV1TaskLoseCheckResponse.init(result: 0)
            self.resume(task:rspTask)
            
            OLog("⚠️调整包序号，1秒后重发。。。")
            let timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(delayRestartTimeoutHandler(timer:)), userInfo: nil, repeats: false)
            self.delayRestartTimer = timer
            RunLoop.main.add(timer, forMode: .default)
        }else {
            OLog("⚠️未处理的NorV1-DevMessage: messageType=\(norV1Msg.messageType), payload=\(NSData.init(data: norV1Msg.payloadData).debugDescription)")
        }
    }
    
    @objc private func delayRestartTimeoutHandler(timer:Timer) {
        if !self.isLoseChecking {
            // 已经不在发送状态
            OLog("⚠️不在loseChecking状态，忽略针对LoseCheck的重发")
            return
        }
        self.isLoseChecking = false
        if self.mainStatus != .image {
            // 已经不在发送状态
            OLog("⚠️mainStatus=\(self.mainStatus)，不在image发送阶段，忽略针对LoseCheck的重发")
            return
        }
        let fileIndex = self.progress.currentFileIndex
        let sliceIndex = self.progress.completedFileSliceCount
        self.norV1StepImagePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
    }
    
    override func clear() {
        delayRestartTimer?.invalidate()
        delayRestartTimer = nil
        isLoseChecking = false
        controlFile = nil
        imageFileArray.removeAll()
        triggerMode = .normal
        currentTask?.stopTimer()
        currentTask = nil
        mainStatus = .none
        endMode = .noSend
        progress.reset()
        retransCount = 0
    }
    
    private func resume(task:OTANorV1TaskBase) {
        let msgPackData = task.toNorV1MessageData()

        if task.baseCompletion == nil {
            // 不需要等待响应的任务直接发送
            // 如果蓝牙未连接，会在Manager阻止发送，并产生Log
            self.delegate?.otaModuleSendDataRequest(module: self, data: msgPackData)
        }else {
            if self.currentTask != nil {
                // 异常状态
                fatalError("存在未完成的task: messageType=\(self.currentTask!.messageType)")
            }else{
                // 如果蓝牙未连接应该直接回调失败
                if self.delegate!.otaModuleShakedHands() == false {
                    OLog("⚠️蓝牙未连接，OTANorV1TaskBase直接回调失败")
                    let error = SFOTAError.init(errorType: .Disconnected, errorDes: "蓝牙未连接")
                    task.baseCompletion?(task,nil, error)
                    return
                }
                self.currentTask = task
                task.delegate = self
                task.startTimer()
                self.delegate?.otaModuleSendDataRequest(module: self, data: msgPackData)
            }
        }
    }
    
    func norV1BaseTaskTimeout(task: OTANorV1TaskBase) {
        if task != self.currentTask {
            var currentTypeDes = "nil"
            if let curTask = self.currentTask {
                currentTypeDes = "\(curTask.messageType)(\(curTask.messageType.rawValue))"
            }
            let timeoutTaskDes = "\(task.messageType)(\(task.messageType.rawValue))"
            OLog("⚠️[异常]收到非当前任务的超时回调: timeoutTask.messageType=\(timeoutTaskDes), currentTask.MessageType=\(currentTypeDes)")
        }else{
            // 超时任务确定是当前任务，置空当前任务
            self.currentTask = nil
        }
        let error = SFOTAError.init(errorType: .RequestTimeout, errorDes: "请求超时")
        task.baseCompletion?(task,nil,error)
    }
    
    /// 启动模块
    func start(controlImageFilePath:URL, imageFileInfos:[SFNorImageFileInfo], triggerMode:NorV1TriggerMode, rspFrequency:UInt8){
//        OLog("原始参数:, controlImageFilePath=\(controlImageFilePath), imageFileInfos=\(imageFileInfos), triggerMode=\(triggerMode), rspFrequency=\(rspFrequency)")
        OLog("原始参数: controlImageFilePath=\(controlImageFilePath)")
        OLog("原始参数: responseFrequency=\(rspFrequency)")
        OLog("原始参数: triggerMode=\(triggerMode)(\(triggerMode.rawValue))")
        OLog("原始参数: imageFileInfos.count=\(imageFileInfos.count)")
        for i in 0 ..< imageFileInfos.count {
            OLog("原始参数: ImageFileInfo[\(i)]=\(imageFileInfos[i])")
        }
        
        guard let controlFileData = try? Data.init(contentsOf: controlImageFilePath) else {
            let otaError = SFOTAError.init(errorType: .LoadControlFileFailed, errorDes: "加载NorV1 Control文件失败")
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        self.controlFile = controlFileData
        
        if imageFileInfos.count == 0 {
            OLog("❌加载Image失败:文件数量为0")
            let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "No Image Files!")
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        
        var imageFileArray = Array<NorImageFile>.init()
        var imageIDArray = Array<UInt8>.init()
        for index in 0..<imageFileInfos.count {
            let fileInfo = imageFileInfos[index]
            guard let fileData = try? Data.init(contentsOf: fileInfo.path) else {
                OLog("❌加载Image失败:path=\(fileInfo.path)")
                let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "加载Image文件失败")
                self.delegate?.otaModuleCompletion(module: self, error: otaError)
                return
            }
            let imageFile = NorImageFile.init(imageID: fileInfo.imageID, data: fileData)
            imageIDArray.append(fileInfo.imageID.rawValue)
            imageFileArray.append(imageFile)
        }
        let imageIDSet = Set(imageIDArray)
        if imageIDSet.count != imageFileArray.count {
            // 说明存在重复的image ID
            OLog("❌存在重复的ImageID")
            let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "Duplicated Image ID!")
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        let validator = CtrlFileValidator.init()
        let validateResult = validator.validateCtrlFile(ctrlFileData: controlFileData, imageIds: imageIDArray)
        if(!validateResult.Success){
            let msg = "❌CtrolFile - ImageID一致性校验失败。msg=\(String(describing: validateResult.Message))"
            OLog(msg)
            let otaError = SFOTAError.init(errorType: .InvalidParams, errorDes: msg)
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        // 根据Image ID值升序排列
        imageFileArray = imageFileArray.sorted { preFile, lastFile in
            return preFile.imageID.rawValue < lastFile.imageID.rawValue
        }
        self.imageFileArray = imageFileArray
        self.triggerMode = triggerMode
        
        progress.defaultFrequnecy = Int(rspFrequency)
        /// reset函数中会根据defaultFrequnecy重置responseFrequency
        progress.reset()
        
        /// 计算
        for file in self.imageFileArray {
            progress.totalBytes += file.data.count
        }
        
        self.mainStatus = .initialConnecting
        /// 发起连接请求，等待ble连接成功或者失败的bleEvent
        self.delegate?.otaModuleReconnectRequest(module: self)
    }
    
    private let NorV1StepLogPrefix = "ℹ️NorV1流程"
    
    
    private func norV1StepInitial() {
        OLog("\(NorV1StepLogPrefix)-Initial: triggerMode=\(triggerMode), ctrlFileSize=\(controlFile!.count)")
        
        self.mainStatus = .initial
        
        if triggerMode == .normal || triggerMode == .force {
            let force = triggerMode == .force
            let task =  OTANorV1TaskImageInitRequest.init(ctrlFile: controlFile!, force: force) {[weak self] tsk, result, reboot, error in
                guard let s = self else {
                    return
                }
                if let err = error {
                    LogTaskError(taskDes: tsk.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                OLog("✅\(tsk.name())响应: result=\(result), reboot=\(reboot)")
                if result != 0 {
                    LogDevErrorCode(taskDes: tsk.name(), errorCode: result)
                    let err = SFOTAError.DevErrorCode(errorCode: result)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                s.norV1StepInitialComplete(reboot: reboot, flag: 1)
            }
            self.resume(task: task)
        }else if triggerMode == .resume {
            let task = OTANorV1TaskImageResumeRequest.init(ctrlFile: controlFile!) { task, infos, error in
                let s = self
                var resume = false
                var reboot = false
                if let err = error {
                    LogTaskError(taskDes: task.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                if let resumeInfos = infos {
                    resume = true
                    let resumeRestart = resumeInfos.resumeRestart
                    let imageIdValue = resumeInfos.imageIDValue
                    var completedCount:UInt32 = 0
                    let frequency:UInt32 = UInt32(resumeInfos.numOfRsp ?? 0)
                    reboot = resumeInfos.needReboot
                    var startFileIndex = -1
                    
                    if resumeInfos.result != 0 {
                        LogDevErrorCode(taskDes: task.name(), errorCode: resumeInfos.result)
                        let err = SFOTAError.DevErrorCode(errorCode: resumeInfos.result)
                        s.delegate?.otaModuleCompletion(module: s, error: err)
                        return
                    }
                    
                    guard let imageId = NorImageID.init(rawValue:imageIdValue) else {
                        let err = SFOTAError.init(errorType: .General, errorDes: "Unknown ImageIDValue=\(imageIdValue)")
                        s.delegate?.otaModuleCompletion(module: s, error: err)
                        return
                    }
                    for i in 0 ..< s.imageFileArray.count {
                        let file = s.imageFileArray[i]
                        if file.imageID == imageId {
                            startFileIndex = i
                            break
                        }
                    }
                    
                    if startFileIndex < 0 {
                        // 没有找到对应的ImageID文件
                        OLog("❌Image列表中没有找到对应的ImageID(\(imageId.rawValue))")
                        let err = SFOTAError.init(errorType: .General, errorDes: "Expected Resume ImageID(\(imageId.rawValue)) Not Found In Image List")
                        s.delegate?.otaModuleCompletion(module: s, error: err)
                        return
                    }
                    
                    if resumeRestart {
                        completedCount = 0
                    }else {
                        completedCount = resumeInfos.completedCount
                        let startFile = s.imageFileArray[startFileIndex]
                        if startFile.dataSliceArray.count < completedCount {
                            // 数据异常
                            OLog("❌completedCount(\(completedCount) Over fileSliceCount(\(startFile.dataSliceArray.count): fileIndex=\(startFileIndex), fileImage=\(startFile.imageID.rawValue), fileSize=\(startFile.data.count)")
                            let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Completed Count From Device")
                            s.delegate?.otaModuleCompletion(module: s, error: err)
                            return
                        }
                    }
                    
                    if frequency == 0 {
                        OLog("⚠️Invalid Response Frequency Value From Device: freq=\(frequency)。")
                        resume = false
                        let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Response Frequency Value From Device: freq=\(frequency)。")
                        s.delegate?.otaModuleCompletion(module: s, error: err)
                        return
                    }else{
                        s.progress.currentFileIndex = startFileIndex
                        s.progress.responseFrequency = Int(frequency)
                        s.progress.completedFileSliceCount = Int(completedCount)
                        s.progress.continueSendNoResponsePacketCount = Int(completedCount) % Int(frequency)
                        OLog("▶️即将使用的resume条件: fileIndex=\(s.progress.currentFileIndex), completedCount=\(s.progress.completedFileSliceCount), ResponseFrequency=\(s.progress.responseFrequency)")
                    }
                }
                s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: s.completedBytes)
                s.norV1StepInitialComplete(reboot: reboot, flag: 1)
                
            }
            self.resume(task: task)
        }else {
            fatalError("❌未知的triggerMode")
        }
    }
    
    
    private func norV1StepInitialComplete(reboot:Bool, flag:UInt8) {

        OLog("ℹ️\(NorV1StepLogPrefix)-InitialComplete: triggerMode=\(triggerMode), flag=\(flag), reboot=\(reboot)")
        var task:OTANorV1TaskBase!
        if triggerMode == .force || triggerMode == .normal {
            task = OTANorV1TaskImageInitComplete.init(flag: flag)
        }else if triggerMode == .resume {
            task = OTANorV1TaskImageResumeComplete.init(flag: flag)
        }else{
            fatalError("❌未知的triggerMode")
        }
        if reboot {
            // 需要等待设备断开连接，在断连event中再发起重连
            self.mainStatus = .waitingDevReboot
            // 发送之后，设备才会断连(如果需要reboot)
            self.resume(task: task)
        }else{
            self.resume(task: task)
            // 直接进入Image发送流程
            self.norV1StepImageStartRequest()
        }
    }
    
    private func norV1StepImageStartRequest() {
        
        self.mainStatus = .image
        
        let fileIndex = progress.currentFileIndex
        let file = imageFileArray[fileIndex]
        let fileSize = UInt32(file.data.count)
        let sliceCount = UInt32(file.dataSliceArray.count)
        let frequency = UInt8(progress.responseFrequency)
        OLog("ℹ️\(NorV1StepLogPrefix)-ImageStart: fileIndex=\(fileIndex),imageID=\(file.imageID),fileSize=\(fileSize), sliceCount=\(sliceCount),frequency=\(frequency)")
        let task = OTANorV1TaskImageStartRequest.init(fileSize: fileSize, sliceCount: sliceCount, frequency: frequency, imageID: file.imageID) {[weak self] tsk, result, endMode, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: tsk.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            OLog("✅\(tsk.name())响应: result=\(result), endMode=\(endMode!)")
            if result != 0 {
                LogDevErrorCode(taskDes: tsk.name(), errorCode: result)
                let err = SFOTAError.DevErrorCode(errorCode: result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            s.endMode = endMode!
            
            let fileIndex = s.progress.currentFileIndex
            let sliceIndex = s.progress.completedFileSliceCount
            s.norV1StepImagePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
        }
        task.timeout = 180.0
        self.resume(task: task)
    }
    
    private func norV1StepImagePacketData(fileIndex:Int, sliceIndex:Int) {
        if(mainStatus != .image){
            OLog("-norV1StepImagePacketData- mainStatus != .image,ignore.")
            return;
        }
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        let sliceData = file.dataSliceArray[sliceIndex]
        let orderNumber = UInt16(sliceIndex + 1)
        let needRsp = progress.continueSendNoResponsePacketCount == progress.responseFrequency - 1
        let isLastSlice = sliceIndex == file.dataSliceArray.count - 1;
        if progress.continueSendNoResponsePacketCount >= progress.responseFrequency {
            fatalError("❌continueSendNoResponsePacketCount=\(progress.continueSendNoResponsePacketCount) OverRange responseFrequency=\(progress.responseFrequency)")
        }

        OLog("\(NorV1StepLogPrefix)-ImagePacketData(\(needRsp ? "Rsp":"No Rsp")): fileIndex=\(fileIndex), imageId=\(imageId), fileProgress=\(orderNumber)/\(file.dataSliceArray.count),cs=\(progress.continueSendNoResponsePacketCount)")
        
        if isLoseChecking {
            OLog("⚠️处于LoseChecking状态，暂停发送ImagePacketData(imageId=\(imageId), fileIndex=\(fileIndex))")
            return
        }
        
        if needRsp || isLastSlice {
            let task = OTANorV1TaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData) {[weak self] tsk, result, error in
    
                guard let s = self else {
                    return
                }
                if let err = error {
                    if err.errorType == .RequestTimeout {
                        // 尝试retransmit
                        s.norV1StepRetransmissionRequest()
                        return
                    }
                    LogTaskError(taskDes: tsk.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                
                let packetDataTask = tsk as! OTANorV1TaskImagePacketData
                OLog("✅\(packetDataTask.name())响应（orderNumer=\(packetDataTask.imageOrderNumber), imageId=\(packetDataTask.imageID.rawValue), sliceLength=\(packetDataTask.data.count)）: result=\(result)")

                
                if result != 0 {
                    LogDevErrorCode(taskDes: tsk.name(), errorCode: result)
                    let err = SFOTAError.DevErrorCode(errorCode: result)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                
                s.progress.completedFileSliceCount = sliceIndex + 1
                let completedBytes = s.completedBytes
                
                // 回调进度
                s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: completedBytes)
                
                let curFileIndex = s.progress.currentFileIndex
                let curFile = s.imageFileArray[curFileIndex]
                
                let nextSliceIndex = sliceIndex + 1
                if nextSliceIndex <= curFile.dataSliceArray.count - 1 {
                    // 还未发送完毕
                    s.norV1StepImagePacketData(fileIndex: curFileIndex, sliceIndex: nextSliceIndex)
                }else {
                    // 已经发送完毕
                    s.norV1StepImageEndRequest()
                }
            }
            self.progress.continueSendNoResponsePacketCount = 0
            self.resume(task: task)
        }else{
            // 先执行发送操作
            let task = OTANorV1TaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData, completion: nil)
            self.resume(task: task)
            progress.continueSendNoResponsePacketCount += 1
            let nextSliceIndex = sliceIndex + 1
            if nextSliceIndex <= file.dataSliceArray.count - 1 {
                // 还未到末尾
//                self.norV1StepImagePacketData(fileIndex: fileIndex, sliceIndex: nextSliceIndex)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    self.norV1StepImagePacketData(fileIndex: fileIndex, sliceIndex: nextSliceIndex)
                }
            }else {
                // 已经发送完最后一个包
                progress.completedFileSliceCount = file.dataSliceArray.count
                let completedBytes = self.completedBytes
                self.delegate?.otaModuleProgress(module: self, stage: .nor, stageTotalBytes: progress.totalBytes, stageCompletedBytes: completedBytes)
                OLog("attempt to send no rsp packet out slice range.nextSliceIndex=\(nextSliceIndex),sliceCount=\(file.dataSliceArray.count)")
                let err = SFOTAError.init(errorType: .SendNoRspPacketOutSliceRange, errorDes:"attempt to send no rsp packet out slice range")
                self.delegate?.otaModuleCompletion(module: self, error: err)
               
            }
        }
    }
    
    private func norV1StepRetransmissionRequest() {
        
        self.retransCount += 1
        
        OLog("\(NorV1StepLogPrefix)-RetransmissionRequest: retransOrder=\(self.retransCount)")
        
        let task = OTANorV1TaskRetransmissionRequest.init {[weak self] tsk, retransRsp, error in
            guard let s = self else {
                return
            }
            if let err = error {
                if err.errorType == .RequestTimeout {
                    if s.retransCount < s.maxRetransCount {
                        // 还没有达到上限，再次尝试
                        OLog("⚠️连续第'\(s.retransCount)/\(s.maxRetransCount)'次协商超时，准备再次尝试...")
                        s.norV1StepRetransmissionRequest()
                    }else{
                        //已达上限
                        OLog("❌连续协商超时次数达到上限(\(s.retransCount))")
                        let e = SFOTAError.init(errorType: .RequestTimeout, errorDes: "重新协商连续超时\(s.retransCount)次")
                        s.delegate?.otaModuleCompletion(module: s, error: e)
                    }
                }else {
                    // 其它类型的错误，直接回调失败
                    LogTaskError(taskDes: tsk.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                }
                return
            }
            
            let rsp = retransRsp!
            
            if rsp.result != 0 {
                LogDevErrorCode(taskDes: tsk.name(), errorCode: rsp.result)
                let err = SFOTAError.DevErrorCode(errorCode: rsp.result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            if rsp.frequency == 0 {
                OLog("❌异常协商结果:frequency=\(rsp.frequency)")
                let err = SFOTAError.init(errorType: .General, errorDes: "异常的frequency值:\(rsp.frequency)")
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            let currentSliceTotalCount = s.imageFileArray[s.progress.currentFileIndex].dataSliceArray.count
            if currentSliceTotalCount <= Int(rsp.completedCount) {
                OLog("❌异常协商结果: completeCount(\(rsp.completedCount)) Over Range actual Total sliceCount(\(currentSliceTotalCount))")
                let err = SFOTAError.init(errorType: .General, errorDes: "异常的completeCount值:\(rsp.completedCount)")
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            s.retransCount = 0
            s.progress.responseFrequency = Int(rsp.frequency)
            s.progress.completedFileSliceCount = Int(rsp.completedCount)
            s.progress.continueSendNoResponsePacketCount = Int(rsp.completedCount) % Int(rsp.frequency)
            
            s.norV1StepImagePacketData(fileIndex: s.progress.currentFileIndex, sliceIndex: s.progress.completedFileSliceCount)
            
        }
        task.timeout = 5.0
        self.resume(task: task)
    }
    
    private func norV1StepImageEndRequest() {
        let fileIndex = progress.currentFileIndex
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        let moreImage = fileIndex < (imageFileArray.count - 1)
        
        OLog("\(NorV1StepLogPrefix)-ImageEndRequest: fileIndex=\(fileIndex), imageId=\(imageId), fileCount=\(imageFileArray.count), hasMoreImage=\(moreImage)")

        
        let task = OTANorV1TaskImageEndRequest.init(imageId: imageId, moreImage: moreImage) {[weak self] task, result, error in
            guard let s = self else {
                return
            }
            
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            OLog("✅\(task.name())响应: result=\(result)")
            
            if result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: result)
                let err = SFOTAError.DevErrorCode(errorCode: result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            let tsk = task as! OTANorV1TaskImageEndRequest
            if tsk.moreImage {
                let nextFileIndex = s.progress.currentFileIndex + 1
                s.progress.currentFileIndex = nextFileIndex
                s.progress.completedFileSliceCount = 0
                s.progress.continueSendNoResponsePacketCount = 0
                // 进入下一个Image文件的发送流程
                s.norV1StepImageStartRequest()
            }else{
                // 进入最后流程
                s.norV1StepTransmissionEnd()
            }
        }
        self.resume(task: task)
    }
    
    private func norV1StepTransmissionEnd() {
        OLog("\(NorV1StepLogPrefix)-TransmissionEnd: endMode=\(self.endMode)")
        
        if self.endMode == .noSend {
            // 不用等待响应
            let task = OTANorV1TaskTransEnd.init(completion: nil)
            self.resume(task: task)
            QPrint("✅✅✅NorV1 OTA成功(NoSend)")
            self.delegate?.otaModuleCompletion(module: self, error: nil)
        }else{
            let task = OTANorV1TaskTransEnd.init {[weak self] tsk, result, error in
                guard let s = self else {
                    return
                }
                if let err = error {
                    LogTaskError(taskDes: tsk.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                OLog("✅\(tsk.name())响应: result=\(result)")
                
                if s.endMode == .sendCmd {
                    QPrint("ℹ️向设备发送End IND消息")
                    // 需要向设备发送一条确认信息
                    if result > UInt8.max || result < 0 {
                        OLog("❌Result值超过UInt8范围，无法发送EndInd指令")
                        let bitError = SFOTAError.init(errorType: .General, errorDes: "Result Value Over Flow")
                        s.delegate?.otaModuleCompletion(module: s, error: bitError)
                        return
                    }
                    let endIndTask = OTANorV1TaskEndInd.init(result: UInt8(result))
                    s.resume(task: endIndTask)
                }
                
                if result != 0 {
                    LogDevErrorCode(taskDes: tsk.name(), errorCode: result)
                    let err = SFOTAError.DevErrorCode(errorCode: result)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                QPrint("✅✅✅NorV1 OTA成功")
                s.delegate?.otaModuleCompletion(module: s, error: nil)
            }
            self.resume(task: task)
        }
    }
}
