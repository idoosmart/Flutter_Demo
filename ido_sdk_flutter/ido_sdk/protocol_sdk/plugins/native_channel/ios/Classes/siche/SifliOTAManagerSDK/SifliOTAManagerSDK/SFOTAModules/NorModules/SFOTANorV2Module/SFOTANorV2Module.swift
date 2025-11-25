import UIKit
import CoreBluetooth

fileprivate enum NorV2MainStatus {
    case none
    case dfuInitConnecting // 最开始的连接，包含了Manager的searching和connecting过程
    case dfuInit   // 处于Image Init交互阶段
    case waitingDevReboot // 等待设备重启
    case dfuImageConnecting // 发送image前的连接
    case dfuImage   // 发送image阶段
}

class SFOTANorV2Module: SFOTAModuleBase,OTANorV2BaseTaskDelegate {
    
    /// 获取SFOTANorV2Module单例对象
    @objc static let share = SFOTANorV2Module.init(name: "Nor_V2")
    private override init(name: String) {
        super.init(name: name)
    }


    weak var delegate:SFOTAModuleDelegate?
    
    /// 升级Image时所需要首先发送的control文件
    private var controlFile:Data?
    
    /// image文件序列，根据id值升序排列，同id的文件只能有1个
    private var imageFileArray = Array<NorImageFile>.init()
    
    private var tryResume:Bool = false
    
    /// 不为nil，表示处于Image的自检模式。
    private var resumeInfoCacheForImageReview:NorV2ResumeInfos?
    
    private var endMode:NorEndMode = .noSend {
        didSet{
            OLog("⚠️修改EndMode:\(oldValue) ==> \(endMode)")
        }
    }
    
    /// 当前正在等待响应的任务
    private var currentTask:OTANorV2TaskBase?
    
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
    
    /// 模块当前所处的主要状态
    private var mainStatus:NorV2MainStatus = .none {
        didSet{
            OLog("ℹ️设置NorV2MainStatus:\(oldValue) ==> \(mainStatus)")
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
            if self.mainStatus == .dfuInitConnecting || self.mainStatus == .dfuImageConnecting {
                // 只在该阶段才处理连接超时回调
                let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索目标外设超时")
                // Manager在该回调中统一对Module执行clear操作
                self.delegate?.otaModuleCompletion(module: self, error: error)
            }else {
                OLog("⚠️[异常]NorV2Module处于\(mainStatus)状态，收到了搜索超时的消息")
            }
        }else if event == .disconnected {
            if mainStatus == .waitingDevReboot {
                // 等待设备重启中，这里发起重连请求
                mainStatus = .dfuImageConnecting
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
            if mainStatus == .dfuInitConnecting {
                self.otaNorV2StepImageInitRequest()
            } else if mainStatus == .dfuImageConnecting {
                self.otaNorV2StepImageStartRequest()
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
        
        //1、解析成NorV2的Message结构
        if data.count < 5{
            // 为保证Message的data部分一定有数据，长度至少为5字节
            OLog("❌解析NorV2Message失败: 数据长度(\(data.count))小于5字节。")
            return
        }
        let d = NSData.init(data: data)
        var messageIdValue:UInt16 = 0
        d.getBytes(&messageIdValue, range: NSRange.init(location: 0, length: 2))
        
        guard let messageType = NorV2MessageType.init(rawValue: messageIdValue) else {
            OLog("❌解析NorV2MessageType失败: 未知的message id = \(messageIdValue)")
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
        let norV2Msg = OTANorV2MessageBaseModel.init(messageType: messageType, payloadData: messageData)
        if let curTsk = self.currentTask {
            // 当前有在等待响应的任务, 对比是否是req-rsp组合
            let isPaired = NorV2MessageUtils.IsPaired(requestType: curTsk.messageType, responseType: norV2Msg.messageType)
            if isPaired {
                // 移除当前任务，以及关闭超时计时器
                self.currentTask = nil
                curTsk.stopTimer()
                
                // 触发回调。在其子类各自的completion中去解析具体的数据
                curTsk.baseCompletion?(curTsk,norV2Msg,nil)
                return
            }
        }
        
        /// 可能是其它设备主动发来的消息
        if norV2Msg.messageType == .LINK_LOSE_CHECK_REQUEST {
            // 调整发送序列的指令，需要SDK回复
            let payload = norV2Msg.payloadData
            if payload.count < 8 {
                OLog("⚠️收到设备的LINK_LOSE_CHECK_REQUEST,但payload字节数不足8。")
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
            
            if mainStatus != .dfuImage {
                OLog("⚠️当前未在Image发送阶段或LoseCheck状态，忽略LoseCheckRequest")
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
            
            
            if let timer = self.delayRestartTimer, timer.isValid {
                OLog("⚠️已经处于LoseCheck状态，刷新LoseCheck信息, completedFileSliceCount: \(progress.completedFileSliceCount)==>\(completedCount), responseFrequency: \(progress.responseFrequency) ==> \(rspFreq)")
            }
            // 如果已经在LoseCheck状态，重置重启时间
            self.delayRestartTimer?.invalidate()
            self.delayRestartTimer = nil
            
            // 回复设备,协议中规定result暂时填0
            let rspTask = OTANorV2TaskLoseCheckResponse.init(result: 0)
            self.resume(task:rspTask)
            
            OLog("⚠️调整包序号，1秒后重发。。。")
            let timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(delayRestartTimeoutHandler(timer:)), userInfo: nil, repeats: false)
            self.delayRestartTimer = timer
            RunLoop.main.add(timer, forMode: .default)
        }else if messageType == .ABORT {
            let payloadDes = NSData.init(data: messageData).debugDescription
            let error = SFOTAError.init(errorType: .General, errorDes: "Device Abort: \(payloadDes)")
            self.delegate?.otaModuleCompletion(module: self, error: error)
        }else {
            OLog("⚠️未处理的设备消息：\(messageType)")
        }
    }
    
    @objc private func delayRestartTimeoutHandler(timer:Timer) {
        self.delayRestartTimer?.invalidate()
        self.delayRestartTimer = nil
        if !self.isLoseChecking {
            // 已经不在发送状态
            OLog("⚠️不在loseChecking状态，忽略针对LoseCheck的重发")
            return
        }
        self.isLoseChecking = false
        if self.mainStatus != .dfuImage {
            // 已经不在发送状态
            OLog("⚠️mainStatus=\(self.mainStatus)，不在loseChecking状态，忽略针对LoseCheck的重发")
            return
        }
        let fileIndex = self.progress.currentFileIndex
        let sliceIndex = self.progress.completedFileSliceCount
        self.mainStatus = .dfuImage
        self.otaNorV2StepImagePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
    }
    
    override func clear() {
        delayRestartTimer?.invalidate()
        delayRestartTimer = nil
        isLoseChecking = false
        controlFile = nil
        imageFileArray.removeAll()
        tryResume = false
        resumeInfoCacheForImageReview = nil
        currentTask?.stopTimer()
        currentTask = nil
        mainStatus = .none
        endMode = .noSend
        progress.reset()
    }
    
    private func resume(task:OTANorV2TaskBase) {
        let msgPackData = task.toNorV2MessageData()

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
                    OLog("⚠️蓝牙未连接，OTANorV2TaskBase直接回调失败")
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
    
    func norV2BaseTaskTimeout(task: OTANorV2TaskBase) {
        if task !== self.currentTask {
            var currentTypeDes = "nil"
            if let curTask = self.currentTask {
                currentTypeDes = "\(curTask.messageType)"
            }
            OLog("⚠️[异常]收到非当前任务的超时回调(messageType=\(task.messageType)(\(task.messageType.rawValue))), currentTask.MessageType=\(currentTypeDes)")
        }else{
            // 超时任务确定是当前任务，置空当前任务
            self.currentTask = nil
        }
        let error = SFOTAError.init(errorType: .RequestTimeout, errorDes: "请求超时")
        task.baseCompletion?(task,nil,error)
    }
    
    
    /// 启动模块
    func start(controlImageFilePath:URL, imageFileInfos:[SFNorImageFileInfo], tryResume:Bool, rspFrequency:UInt8){
//        OLog("原始参数:, controlImageFilePath=\(controlImageFilePath), imageFileInfos=\(imageFileInfos), tryResume=\(tryResume), responseFrequency=\(rspFrequency)")
        OLog("原始参数: controlImageFilePath=\(controlImageFilePath)")
        OLog("原始参数: tryResume=\(tryResume)")
        OLog("原始参数: responseFrequency=\(rspFrequency)")
        OLog("原始参数: imageFileInfos.count=\(imageFileInfos.count)")
        for i in 0 ..< imageFileInfos.count {
            OLog("原始参数: ImageFileInfo[\(i)]=\(imageFileInfos[i])")
        }
        
        guard let controlFileData = try? Data.init(contentsOf: controlImageFilePath) else {
            let otaError = SFOTAError.init(errorType: .LoadControlFileFailed, errorDes: "加载NorV2 Control文件失败")
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        self.controlFile = controlFileData
        let ctrlData4Log = NSData.init(data: self.controlFile!)
        let ctrlFileSign = HashUtils.CalculateMD5(data: self.controlFile!)
        OLog("📃✅成功加载ctrl文件: length=\(controlFileData.count), content=\(ctrlData4Log.customDescription), md5=\(ctrlFileSign)")

        
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
            let imageID = fileInfo.imageID
            let data4Log = NSData.init(data: fileData)
            let fileSign = HashUtils.CalculateMD5(data: fileData)
            OLog("📃✅成功加载Image文件: imageID=\(imageID)(\(imageID.rawValue)), length=\(fileData.count), content=\(data4Log.customDescription), md5=\(fileSign), path=\(fileInfo.path)")
            let imageFile = NorImageFile.init(imageID: imageID, data: fileData)
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
        self.tryResume = tryResume
        
        progress.defaultFrequnecy = Int(rspFrequency)
        
        /// reset函数中会根据defaultFrequnecy重置responseFrequency
        progress.reset()
        
        /// 计算
        for file in self.imageFileArray {
            progress.totalBytes += file.data.count
            let imageID = file.imageID
            let data4Log = NSData.init(data: file.data)
            var firstPack = NSData.init()
            var lastPack = NSData.init()
            if file.dataSliceArray.count > 0 {
                firstPack = NSData.init(data: file.dataSliceArray.first!)
                lastPack = NSData.init(data: file.dataSliceArray.last!)
            }
            OLog("📃整理后的Image: imageID=\(imageID)(\(imageID.rawValue)), content=\(data4Log.customDescription), packetCount=\(file.dataSliceArray.count), firstPack=\(firstPack), lastPack=\(lastPack)")
        }
        
        self.mainStatus = .dfuInitConnecting
        /// 发起连接请求，等待ble
        self.delegate?.otaModuleReconnectRequest(module: self)
    }
    
    
    private let NorV2StepLogPrefix = "ℹ️NorV2流程"
    
    private func otaNorV2StepImageInitRequest() {
        OLog("\(NorV2StepLogPrefix)-ImageInitRequest")
        self.mainStatus = .dfuInit
        let initTask = OTANorV2TaskImageInitRequestExt.init(ctrlPacketData: self.controlFile!) {[weak self] task, msg, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            let message = msg!
            
            OLog("✅\(task.name())响应:result=\(message.result), reboot=\(message.needReboot), resumeInfos=\(message.resumeInfos?.debugDescription ?? "nil")")

            
            if message.result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: message.result)
                let err = SFOTAError.DevErrorCode(errorCode: message.result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
                        
            var resume = false
            if let resumeInfos = message.resumeInfos, s.tryResume == true {
                
                // 需要从指定imageId开始
                
                resume = true
                
                let resumeRestart = resumeInfos.resumeRestart
                let imageIdValue = resumeInfos.imageIdValue
                var completedCount:UInt32 = 0
                let frequency = resumeInfos.rspFrequency
                
                var startFileIndex = -1
                
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
                    completedCount = resumeInfos.completedPacketCount
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
                    OLog("⚠️Invalid Response Frequency Value From Device: freq=\(frequency)。SDK Will Continue Without Try Resume !")
                    resume = false
                }else{
                    s.progress.currentFileIndex = startFileIndex
                    s.progress.responseFrequency = Int(frequency)
                    s.progress.completedFileSliceCount = Int(completedCount)
                    s.progress.continueSendNoResponsePacketCount = Int(completedCount) % Int(frequency)
                    OLog("▶️即将使用的resume条件: fileIndex=\(s.progress.currentFileIndex), completedCount=\(s.progress.completedFileSliceCount), ResponseFrequency=\(s.progress.responseFrequency)")
                }
            }else{
                // 不进行续传
            }
            s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: s.completedBytes)
            s.otaNorV2StepImageInitCompleted(resume: resume, resumeInfos: message.resumeInfos,willReboot: message.needReboot)
        }
        self.resume(task: initTask)
    }
    
    private func otaNorV2StepImageInitCompleted(resume:Bool, resumeInfos:NorV2ResumeInfos?, willReboot:Bool) {
        OLog("\(NorV2StepLogPrefix)-ImageInitCompleted: resume=\(resume), resumeInfos=\(resumeInfos?.debugDescription ?? "nil"), waitingReboot=\(willReboot)")
        
        
        if resume && resumeInfos?.imageReview == true {
            // 将进行Image检查。
            
            // 缓存resume信息
            self.resumeInfoCacheForImageReview = resumeInfos
            
            // 重置进度
            self.progress.currentFileIndex = 0
            self.progress.completedFileSliceCount = 0
            OLog("⚠️⚠️即将进入ImageReview模式⚠️⚠️")
        }
        
        if willReboot {
            // 在断开蓝牙的事件中进行重连请求
            self.mainStatus = .waitingDevReboot
            let task = OTANorV2TaskImageInitCompletedExt.init(resume: resume)
            self.resume(task: task)
        }else {
            let task = OTANorV2TaskImageInitCompletedExt.init(resume: resume)
            self.resume(task: task)
            self.otaNorV2StepImageStartRequest()
        }
    }
    
    private func otaNorV2StepImageStartRequest() {
        self.mainStatus = .dfuImage
        let fileIndex = progress.currentFileIndex
        let file = imageFileArray[fileIndex]
        let fileLength = UInt32(file.data.count)
        let packetCount = UInt32(file.dataSliceArray.count)
        let freq = UInt8(progress.responseFrequency)
        
        OLog("\(NorV2StepLogPrefix)-ImageStartRequest: fileLength=\(fileLength), packetCount=\(packetCount), frequency=\(freq), imageID=\(file.imageID)(\(file.imageID.rawValue))")


        let task = OTANorV2TaskImageStartRequest.init(fileLength: fileLength, sliceCount: packetCount, rspFreq: freq, imageId: file.imageID) {[weak self] tsk, msg, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: tsk.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            let message = msg!
            OLog("✅\(tsk.name())响应: result=\(message.result), endMode=\(message.endMode), skip=\(message.skip?.description ?? "nil")")
            
            if message.result != 0 {
                LogDevErrorCode(taskDes: tsk.name(), errorCode: message.result)
                let err = SFOTAError.DevErrorCode(errorCode: message.result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            s.endMode = message.endMode
            
            if let resumeInfo = s.resumeInfoCacheForImageReview {
                
                let file = s.imageFileArray[fileIndex]
                if file.imageID.rawValue == resumeInfo.imageIdValue {
                    // 已经检查到可以正常resume的Image
                    
                    // 清除ImageReview标记，防止后续流程继续进入ImageReview模式
                    s.resumeInfoCacheForImageReview = nil
                    
                    // 使用resume中缓存的续传信息
                    if resumeInfo.resumeRestart || resumeInfo.rspFrequency == 0{
                        s.progress.completedFileSliceCount = 0
                        s.progress.continueSendNoResponsePacketCount = 0
                    }else{
                        s.progress.completedFileSliceCount = Int(resumeInfo.completedPacketCount)
                        s.progress.continueSendNoResponsePacketCount = Int(resumeInfo.completedPacketCount) % Int(resumeInfo.rspFrequency);
                    }
                   
                    
                    OLog("✅解除ImageReview模式，准备开始续传: fileIndex=\(fileIndex), imageID=\(file.imageID.rawValue), completedFileSliceCount=\(s.progress.completedFileSliceCount)")
                }else{
                    // 还不是可以正常resume的Image，检查skip位
                    
                    // 处于Image检查模式，必须含有skip信息，否则表示设备端数据异常
                    guard let skip = message.skip else {
                        OLog("❌[ImageReview模式]设备IMAGE_START_RESPONSE数据缺少skip字段")
                        let err = SFOTAError.init(errorType: .InsufficientBytes, errorDes: "缺少Skip信息")
                        s.delegate?.otaModuleCompletion(module: s, error: err)
                        return
                    }
                    
                    // 产生一次进度回调
                    s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: s.completedBytes)
                    if skip {
                        // 跳过该Image，直接进入下一个ImageStart
                        let nextFileIndex = s.progress.currentFileIndex + 1
                        if nextFileIndex > s.imageFileArray.count - 1 {
                            // 意味着即将跳过最后一个Image。
                            OLog("⚠️⚠️⚠️[ImageReview模式][异常]即将skip最后一个Image")
                            s.otaNorV2StepTransmissionEnd()
                        }else {
                            s.progress.currentFileIndex = nextFileIndex
                            OLog("⚠️[ImageReview模式]跳过Image: imageID=\(tsk.imageId.rawValue)")
                            s.otaNorV2StepImageStartRequest()
                        }
                        return
                    }
                    
                    // 不能跳过，需要从该Image的第一个包开始发送。
                    s.progress.completedFileSliceCount = 0
                    s.progress.continueSendNoResponsePacketCount = 0
                    OLog("⚠️[ImageReview模式]准备重新发送Image文件: fileIndex=\(fileIndex), imageID=\(file.imageID.rawValue)")
                }
            }
            s.otaNorV2StepImagePacketData(fileIndex: s.progress.currentFileIndex, sliceIndex: s.progress.completedFileSliceCount)
        }
        task.timeout = 180.0
        self.resume(task: task)
    }
    
    private func otaNorV2StepImagePacketData(fileIndex: Int, sliceIndex: Int) {
        if(mainStatus != .dfuImage){
            OLog("-otaNorV2StepImagePacketData- mainStatus != .dfuImage,ignore.")
            return;
        }
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        if sliceIndex == file.dataSliceArray.count {
            self.otaNorV2StepImageEndRequest()
            return
        }

        let sliceData = file.dataSliceArray[sliceIndex]
        let orderNumber = UInt16(sliceIndex + 1)
        let needRsp = progress.continueSendNoResponsePacketCount == progress.responseFrequency - 1
        if progress.continueSendNoResponsePacketCount >= progress.responseFrequency {
            fatalError("❌continueSendNoResponsePacketCount=\(progress.continueSendNoResponsePacketCount) OverRange responseFrequency=\(progress.responseFrequency)")
        }

        OLog("\(NorV2StepLogPrefix)-ImagePacketData(\(needRsp ? "Rsp":"No Rsp")): fileIndex=\(fileIndex), imageId=\(imageId), fileProgress=\(orderNumber)/\(file.dataSliceArray.count),cs=\(progress.continueSendNoResponsePacketCount)")
        
        if needRsp {
            let task = OTANorV2TaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData) {[weak self] tsk, result, error in
    
                guard let s = self else {
                    return
                }
                if let err = error {
                    LogTaskError(taskDes: tsk.name(), error: err)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                let packetDataTask = tsk as! OTANorV2TaskImagePacketData
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
                    s.otaNorV2StepImagePacketData(fileIndex: curFileIndex, sliceIndex: nextSliceIndex)
                }else {
                    // 已经发送完毕
                    s.otaNorV2StepImageEndRequest()
                }
            }
            self.progress.continueSendNoResponsePacketCount = 0
            self.resume(task: task)
        }else{
            // 先执行发送操作
            let task = OTANorV2TaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData, completion: nil)
            self.resume(task: task)
            progress.continueSendNoResponsePacketCount += 1
            let nextSliceIndex = sliceIndex + 1
            if nextSliceIndex <= file.dataSliceArray.count - 1 {
                // 还未到末尾
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    self.otaNorV2StepImagePacketData(fileIndex: fileIndex, sliceIndex: nextSliceIndex)
                }
            }else {
                // 已经发送完最后一个包
                progress.completedFileSliceCount = file.dataSliceArray.count
                let completedBytes = self.completedBytes
                self.delegate?.otaModuleProgress(module: self, stage: .nor, stageTotalBytes: progress.totalBytes, stageCompletedBytes: completedBytes)
                self.otaNorV2StepImageEndRequest()
            }
        }
    }
    
    private func otaNorV2StepImageEndRequest() {
        let fileIndex = progress.currentFileIndex
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        
        let moreImage = fileIndex < (imageFileArray.count - 1)
        
        OLog("\(NorV2StepLogPrefix)-ImageEndRequest: fileIndex=\(fileIndex), imageId=\(imageId), fileCount=\(imageFileArray.count), hasMoreImage=\(moreImage)")
        
        let task = OTANorV2TaskImageEndRequest.init(imageId: imageId, moreImage: moreImage) {[weak self] (task, result, error) in
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
            let tsk = task as! OTANorV2TaskImageEndRequest
            if tsk.moreImage {
                let nextFileIndex = s.progress.currentFileIndex + 1
                s.progress.currentFileIndex = nextFileIndex
                s.progress.completedFileSliceCount = 0
                s.progress.continueSendNoResponsePacketCount = 0
                // 进入下一个Image文件的发送流程
                s.otaNorV2StepImageStartRequest()
            }else{
                // 进入最后流程
                s.otaNorV2StepTransmissionEnd()
            }
        }
        self.resume(task: task)
    }
    
    
    private func otaNorV2StepTransmissionEnd() {
        
        OLog("\(NorV2StepLogPrefix)-TransmissionEnd: endMode=\(self.endMode)")

        if self.endMode == .noSend {
            // 不用等待响应
            let task = OTANorV2TaskTransEnd.init(completion: nil)
            self.resume(task: task)
            QPrint("✅✅✅NorV2 OTA成功(NoSend)")
            self.delegate?.otaModuleCompletion(module: self, error: nil)
        }else{
            let task = OTANorV2TaskTransEnd.init {[weak self] tsk, result, error in
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
                    let endIndTask = OTANorV2TaskEndInd.init(result: UInt8(result))
                    s.resume(task: endIndTask)
                }
                
                if result != 0 {
                    LogDevErrorCode(taskDes: tsk.name(), errorCode: result)
                    let err = SFOTAError.DevErrorCode(errorCode: result)
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                QPrint("✅✅✅NorV2 OTA成功")
                s.delegate?.otaModuleCompletion(module: s, error: nil)
            }
            self.resume(task: task)
        }
    }
}
