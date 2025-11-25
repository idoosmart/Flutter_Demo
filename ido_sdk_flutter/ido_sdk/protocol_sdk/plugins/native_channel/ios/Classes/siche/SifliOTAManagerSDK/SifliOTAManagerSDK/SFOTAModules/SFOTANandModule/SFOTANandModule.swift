import UIKit
//import Zip
import CoreBluetooth

enum NandMainStatus {
    case none
    case loadingFiles
    case connecting // 包含了Manager的searching和connecting过程
    case resource
    case image
}

// 管理Nand升级事务
class SFOTANandModule: SFOTAModuleBase, OTANandBaseTaskDelegate {
    
    /// 获取SFOTANandModule单例对象
    @objc static let share = SFOTANandModule.init(name: "NAND")
    
    private override init(name: String) {
        self.deviceOtaVersion = 0
        super.init(name: name)
        
    }
    
    weak var delegate:SFOTAModuleDelegate?
    
    
    /// 长度为0表示本次升级没有资源文件参与
    /// 序列为约定好的文件发送顺序
    private var sortedResFileArray = Array<NandResFile>.init()
    
    /// 升级hcpu时所需要首先发送的control文件
    /// nil表示本次升级没有HCPU文件参与
    private var controlFile:Data?
    
    /// HCPU文件序列
    private var imageFileArray = Array<NandImageFile>.init()
    
    private var tryResume:Bool = false
    
    /// 当前正在等待响应的任务
    private var currentTask:OTANandTaskBase?
    
    private var delayRestartTimer:Timer?
    private var deviceOtaVersion:UInt32
    
    private let resProgress = NandProgressRecord.init()
    private var resCompletedBytes:Int {
        if sortedResFileArray.count <= resProgress.currentFileIndex {
            return 0
        }
        let curFile = sortedResFileArray[resProgress.currentFileIndex]
        if curFile.dataSliceArray.count < resProgress.completedFileSliceCount {
            return 0
        }
        var completed = 0
        if resProgress.currentFileIndex > 0 {
            for i in 0..<resProgress.currentFileIndex {
                completed += sortedResFileArray[i].data.count
            }
        }
        if resProgress.completedFileSliceCount == curFile.dataSliceArray.count {
            // 最后一个包
            completed += curFile.data.count
        }else{
            completed += resProgress.completedFileSliceCount * NandResFile.sliceLength
        }
        return completed
    }
    
    private let imageProgress = NandProgressRecord.init()
    private var imageCompletedBytes:Int {
        if imageFileArray.count <= imageProgress.currentFileIndex {
            return 0
        }
        let curFile = imageFileArray[imageProgress.currentFileIndex]
        if curFile.dataSliceArray.count < imageProgress.completedFileSliceCount {
            return 0
        }
        var completed = 0
        if imageProgress.currentFileIndex > 0 {
            for i in 0..<imageProgress.currentFileIndex {
                completed += imageFileArray[i].data.count
            }
        }
        if imageProgress.completedFileSliceCount == curFile.dataSliceArray.count {
            // 最后一个包
            completed += curFile.data.count
        }else{
            completed += imageProgress.completedFileSliceCount * NandImageFile.SliceLength
        }
        return completed
    }
    
    /// 模块当前所处的主要状态
    private var mainStatus:NandMainStatus = .none {
        didSet{
            OLog("ℹ️设置NandMainStatus:\(mainStatus)")
        }
    }
    
    private var isLoseChecking = false {
        didSet{
            OLog("⚠️修改isLoseChecking状态: \(oldValue) ===> \(isLoseChecking)")
        }
    }
    
    /// 启动模块
    func start(resourcePath:URL?, controlImageFilePath:URL?, imageFileInfos:[SFNandImageFileInfo], tryResume:Bool, imageRspFrequency:UInt8){
//        OLog("原始参数: resourceZipPath=\(resourceZipPath?.description ?? "nil"), controlImageFilePath=\(controlImageFilePath?.description ?? "nil"), imageFileInfos=\(imageFileInfos), tryResume=\(tryResume)")
        
        OLog("原始参数: resourcePath=\(resourcePath?.description ?? "空")")
        OLog("原始参数: controlImageFilePath=\(controlImageFilePath?.description ?? "空")")

        OLog("原始参数: tryResume=\(tryResume)")
        OLog("原始参数: imageRspFrequency=\(imageRspFrequency)")
        OLog("原始参数: imageFileInfos.count=\(imageFileInfos.count)")
        for i in 0 ..< imageFileInfos.count {
            OLog("原始参数: ImageFileInfo[\(i)]=\(imageFileInfos[i])")
        }
        
//        if resourceZipPath == nil {
//            /// 暂未实现resource为空的场景
//            OLog("❌资源文件地址为nil")
//            let error = SFOTAError.init(errorType: .General, errorDes: "Resource Paht is nil")
//            self.delegate?.otaModuleCompletion(module: self, error: error)
//            return
//        }
        self.mainStatus = .loadingFiles
        if let resPath = resourcePath {
            do{
                let resFiles =  try ResourceZipLoader.loadSorted(path: resPath)
                for file in resFiles {
                    OLog("文件名='\(file.nameWithPath)',文件大小=\(file.data.count)")
                }
                self.sortedResFileArray = resFiles
            }catch{
                OLog("❌加载资源文件失败:path=\(resPath),error=\(error)")
                let otaError = SFOTAError.init(errorType: .LoadResourceZipFailed, errorDes: "\(error)")
                self.delegate?.otaModuleCompletion(module: self, error: otaError)
                return
            }
        }else{
            // 不需要传zip资源。
            OLog("⚠️启用无ResouceZip资源的OTA流程")
            self.sortedResFileArray = []
        }
        
        if let controlPath = controlImageFilePath {
            guard let controlFileData = try? Data.init(contentsOf: controlPath) else {
                let otaError = SFOTAError.init(errorType: .LoadControlFileFailed, errorDes: "加载HCPU Control文件失败")
                self.delegate?.otaModuleCompletion(module: self, error: otaError)
                return
            }
            self.controlFile = controlFileData
            
            // 只有controlImageFilePath不为nil才处理hcpuImageFilePaths
            var imageFileArray = Array<NandImageFile>.init()
            var imageIDArray = Array<UInt16>.init()
            for index in 0..<imageFileInfos.count {
                let fileInfo = imageFileInfos[index]
                guard let fileData = try? Data.init(contentsOf: fileInfo.path) else {
                    OLog("❌加载Image失败:path=\(fileInfo.path)")
                    let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "加载Image文件失败")
                    self.delegate?.otaModuleCompletion(module: self, error: otaError)
                    return
                }
                let imageFile = NandImageFile.init(imageID: fileInfo.imageID, data: fileData)
//                OLog("成功加载Image文件:imageID=\(imageFile.imageID), \(imageFile.data.count) bytes")
                
                imageIDArray.append(fileInfo.imageID.rawValue)
                imageFileArray.append(imageFile)
            }
            if imageFileArray.count == 0 {
                OLog("❌Image失败:文件数量为0")
                let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "No Image Files!")
                self.delegate?.otaModuleCompletion(module: self, error: otaError)
                return
            }else {
                let imageIDSet = Set(imageIDArray)
                if imageIDSet.count != imageFileArray.count {
                    // 说明存在重复的image ID
                    OLog("❌存在重复的ImageID")
                    let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "Duplicated Image ID!")
                    self.delegate?.otaModuleCompletion(module: self, error: otaError)
                    return
                }
                
                let validator = CtrlFileValidator.init()
                let validateResult = validator.validateCtrlFile16(ctrlFileData: controlFileData, imageIds: imageIDArray)
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
            }
            self.imageFileArray = imageFileArray
        }
        self.tryResume = tryResume
        
        resProgress.defaultFrequnecy = 1
        resProgress.reset()
        
        imageProgress.defaultFrequnecy = Int(imageRspFrequency)
        imageProgress.reset()
        
        /// 计算
        for file in self.sortedResFileArray {
            resProgress.totalBytes += file.data.count
        }
        for file in self.imageFileArray {
            imageProgress.totalBytes += file.data.count
        }
        
        self.mainStatus = .connecting
        /// 发起连接请求，等待ble
        self.delegate?.otaModuleReconnectRequest(module: self)

    }
    
    /// 处理Manager通知的蓝牙事件
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
            if self.mainStatus == .connecting {
                // 只在该阶段才处理连接超时回调
                let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索目标外设超时")
                // Manager在该回调中统一对Module执行clear操作
                self.delegate?.otaModuleCompletion(module: self, error: error)
            }else {
                OLog("⚠️[异常]NandModule处于\(mainStatus)状态，收到了搜索超时的消息")
            }
        }else if event == .disconnected {
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
            // 仅在流程最开始等待连接成功的阶段处理该事件，其它时候忽略该事件
            if mainStatus == .connecting {
                // 更新状态标记，开始Resource流程
                self.mainStatus = .resource
                self.otaNandResStepFileInitStart()
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
    
    
    /// 处理Manager下发的收到的蓝牙数据
    override func bleDataHandler(bleCore: QBleCore, data: Data) {
        // data已经是从SerialTransport结构中解析出的Data部分
        
        //1、解析成Nand的Message结构
        if data.count < 5{
            // 为保证Message的data部分一定有数据，长度至少为5字节
            OLog("❌解析NandMessage失败: 数据长度(\(data.count))小于5字节。")
            return
        }
        let d = NSData.init(data: data)
        var messageIdValue:UInt16 = 0
        d.getBytes(&messageIdValue, range: NSRange.init(location: 0, length: 2))
        
        guard let messageType = NandMessageType.init(rawValue: messageIdValue) else {
            OLog("❌解析NandMessageType失败: 未知的message id = \(messageIdValue)")
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
        let nandMsg = OTANandMessageBaseModel.init(messageType: messageType, payloadData: messageData)
        if let curTsk = self.currentTask {
            // 当前有在等待响应的任务, 对比是否是req-rsp组合
            let isPaired = NandMessageUtils.IsPaired(requestType: curTsk.messageType, responseType: nandMsg.messageType)
            if isPaired {
                // 移除当前任务，以及关闭超时计时器
                self.currentTask = nil
                curTsk.stopTimer()
                
                // 触发回调。在其子类各自的completion中去解析具体的数据
                curTsk.baseCompletion?(curTsk,nandMsg,nil)
                return
            }
        }
        /// 可能是其它设备主动发来的消息
        if nandMsg.messageType == .LINK_LOSE_CHECK_REQUEST {
            // 调整发送序列的指令，需要SDK回复
            let payload = nandMsg.payloadData
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
            
            if mainStatus != .image && mainStatus != .resource {
                OLog("⚠️当前未在resource/Image发送阶段，忽略LoseCheckRequest")
                return
            }

            if mainStatus == .resource {
                let curFile = self.sortedResFileArray[self.resProgress.currentFileIndex]
                if curFile.dataSliceArray.count <= completedCount {
                    OLog("⚠️completedCount(\(completedCount))大于等于resFile(\(curFile.dataSliceArray.count))总包数，忽略LoseCheckRequest")
                    return
                }
                resProgress.completedFileSliceCount = Int(completedCount)
                resProgress.responseFrequency = Int(rspFreq)
                resProgress.continueSendNoResponsePacketCount = Int(completedCount) % Int(rspFreq)
            }else if mainStatus == .image {
                let curFile = self.imageFileArray[self.imageProgress.currentFileIndex]
                let sliceCount = curFile.dataSliceArray.count
                if sliceCount <= completedCount {
                    OLog("⚠️completedCount(\(completedCount))大于等于imageFile(\(curFile.dataSliceArray.count))总包数，忽略LoseCheckRequest")
                    return
                }
                imageProgress.completedFileSliceCount = Int(completedCount)
                imageProgress.responseFrequency = Int(rspFreq)
                imageProgress.continueSendNoResponsePacketCount =  Int(completedCount) % Int(rspFreq)
            }else {
                fatalError("❌当前未在发送阶段")
            }
            
            self.isLoseChecking = true
            
            
            // 移除currentTask，即暂停发送
            self.currentTask?.stopTimer()
            self.currentTask = nil
            
            self.delayRestartTimer?.invalidate()
            self.delayRestartTimer = nil
            
            // 回复设备,协议中规定result暂时填0
            let rspTask = OTANandTaskLoseCheckResponse.init(result: 0)
            self.resume(task:rspTask)
            
            OLog("⚠️调整包序号，1秒后重发。。。")
//            let status = self.mainStatus
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
    
    @objc private func delayRestartTimeoutHandler(timer: Timer) {
        self.delayRestartTimer?.invalidate()
        self.delayRestartTimer = nil
        
        if !self.isLoseChecking {
            // 已经不在发送状态
            OLog("⚠️不在loseChecking状态，忽略针对LoseCheck的重发")
            return
        }
        self.isLoseChecking = false
        if self.mainStatus == .resource {
            let fileIndex = self.resProgress.currentFileIndex
            let sliceIndex = self.resProgress.completedFileSliceCount
            self.otaNandResStepSendFilePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
        }else if self.mainStatus == .image {
            let fileIndex = self.imageProgress.currentFileIndex
            let sliceIndex = self.imageProgress.completedFileSliceCount
            self.otaNandHCPUStepImagePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
        }else{
            OLog("⚠️mainStatus=\(self.mainStatus)，不在resource或image阶段，忽略针对LoseCheck的重发")
        }
    }
    
    
    private let ResLogPrefix = "ℹ️NandOTA流程[Resource]"
    private let HcpuLogPrefix = "ℹ️NandOTA流程[HCPU]"
    
    /// Nand流程1
    private func otaNandResStepFileInitStart() {

        let fileCount = UInt32(self.sortedResFileArray.count)
        var totalResFileBytes = 0
        OLog("makeSlice sliceLength=\(NandResFile.sliceLength)")
        for file in sortedResFileArray {
            file.makeSlice()
            totalResFileBytes += file.data.count
        }
        let version:UInt32 = 102
        OLog("\(ResLogPrefix)-FileInitStart: fileCount=\(fileCount), totalFileLength=\(totalResFileBytes), version=\(version)")
        let task = OTANandResTaskFileInitStart.init(fileCount: fileCount, totalBytes: UInt32(totalResFileBytes),version: version) {[weak self] task, result, resumeState, completedFileCount,otaVersion,fsBlock, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                self?.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            OLog("✅\(task.name())响应: result=\(result), resumeState=\(resumeState), completedFileCount=\(completedFileCount)")

            if result == 14 {
                // 表示Resource部分已经更新，直接进入HCPU的InitRequest流程
                OLog("⚠️Resouorce已经完成更新，准备进入HCPU流程...")
                s.otaNandHCPUStepImageInitRequest()
                return
            }
            if result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: Int(result))
                let otaError = SFOTAError.DevErrorCode(errorCode: Int(result))
                s.delegate?.otaModuleCompletion(module: s, error: otaError)
                return
            }
            s.deviceOtaVersion = otaVersion;
            if fileCount == 0{
                OLog("⚠️无Resource资源，准备进入HCPU流程...")
                s.otaNandHCPUStepImageInitRequest();
                return
            }
           
            // 计算设备的剩余空间
            var needTotalBlock:Int = 0
            if(fsBlock > 0){
                for f in s.sortedResFileArray {
                    let block = s.calculateFileBlock(blockLength: Int(fsBlock), fileLength: f.data.count)
                    needTotalBlock += block
                }
            }
          
            
            if resumeState == 1 && s.tryResume {
                // 支持续传并且用户允许了尝试续传
                OLog("尝试Resource续传，已完成文件数量:\(completedFileCount)")
                if completedFileCount > s.sortedResFileArray.count {
                    OLog("❌设备回复的completedFileCount=\(completedFileCount)大于文件总数\(s.sortedResFileArray.count)")
                    let otaError = SFOTAError.init(errorType: .General, errorDes: "Invalid Device Response")
                    s.delegate?.otaModuleCompletion(module: s, error: otaError)
                    return
                }
                if completedFileCount == s.sortedResFileArray.count {
                    // 特殊情况，已经传完，直接进入FILE_END_REQUEST
                    s.otaNandResStepFileEndRequest()
                }else{
                    s.resProgress.currentFileIndex = Int(completedFileCount)
                    s.otaNandResStepInitCompleted(resume: true,totalBlockCount: needTotalBlock,otaVer: Int(otaVersion))
                }
            }else{
                s.otaNandResStepInitCompleted(resume: false,totalBlockCount: needTotalBlock,otaVer: Int(otaVersion))
            }
        }
        self.resume(task: task)
    }
    
    private func calculateFileBlock(blockLength:Int, fileLength:Int) -> Int {
        let count = fileLength/blockLength + (fileLength%blockLength > 0 ? 1:0)
        return count
    }
    
    /// Nand流程2
    private func otaNandResStepInitCompleted(resume:Bool,totalBlockCount:Int,otaVer:Int){
        OLog("\(ResLogPrefix)-InitCompleted: resume=\(resume),totalBlockCount=\(totalBlockCount),otaVer=\(otaVer)")
        let task = OTANandResTaskFileInitComplete.init(resume: resume,totalBlockCount: totalBlockCount,otaVersion: otaVer)
        self.resume(task: task)
        self.otaNandResFileStartRequest()
    }
    
    private func otaNandResFileStartRequest() {
        
        // 进行一次进度回调
        self.delegate?.otaModuleProgress(module: self, stage: .nand_res, stageTotalBytes: self.resProgress.totalBytes, stageCompletedBytes: self.resCompletedBytes)
        
        // 上一步骤已经对resProgress中的参数做了越界判读，这里直接使用
        let curResFile = self.sortedResFileArray[resProgress.currentFileIndex]
        
        let orderNumber = UInt16(resProgress.currentFileIndex + 1)
        let fileLength = UInt32(curResFile.data.count)
        let packetCount = UInt16(curResFile.dataSliceArray.count)
        let nameDataWithPath = curResFile.nameDataWithPath
        let rspFreq = UInt16(resProgress.responseFrequency)
        
        OLog("\(ResLogPrefix)-FileStartRequest: fileName=\(curResFile.nameWithPath), fileLength=\(fileLength), fileIndex=\(orderNumber-1), packetCount=\(packetCount), rspFreq=\(rspFreq)")

        
        let task = OTANandResTaskFileStartRequest.init(fileOrderNumber: orderNumber, rspFrequnecy: rspFreq, fileLength: fileLength, packetCount: packetCount, fileNameDataWithPath: nameDataWithPath) {[weak self] task, result, error in
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
                LogDevErrorCode(taskDes: task.name(), errorCode: Int(result))
                let err = SFOTAError.DevErrorCode(errorCode: Int(result))
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            // 开始发送PacketData
            let fileIndex = s.resProgress.currentFileIndex
            let sliceIndex = s.resProgress.completedFileSliceCount

            s.otaNandResStepSendFilePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
        }
        self.resume(task: task)
    }
    
    
    private func otaNandResStepSendFilePacketData(fileIndex:Int, sliceIndex:Int) {
        if(self.mainStatus != .resource){
            OLog("otaNandResStepSendFilePacketData mainStatus != resource .ignore.")
            return
        }
        let file = sortedResFileArray[fileIndex]
        let packetData = file.dataSliceArray[sliceIndex]
        let packetOrder = UInt16(sliceIndex + 1)
        
        OLog("\(ResLogPrefix)-FilePacketData: fileIndex=\(fileIndex), fileName=\(file.nameWithPath), packetOrder=\(packetOrder)/\(file.dataSliceArray.count), packetSize=\(packetData.count)")
        
        if isLoseChecking {
            OLog("⚠️处于LoseChecking状态，暂停发送ResPacketData(fileIndex=\(fileIndex), packetOrder=\(packetOrder))")
            return
        }
        
        /// 判断本次发送是否需要等待响应
        let isNoResponse = resProgress.continueSendNoResponsePacketCount < resProgress.responseFrequency - 1
        
        if isNoResponse {
            // 继续发送无响应的Packet
            
            let noRspTask = OTANandResTaskFilePacketData.init(packetOrderNumber: packetOrder, packetData: packetData, completion: nil)
            self.resume(task: noRspTask)
            
            resProgress.continueSendNoResponsePacketCount += 1
            
            let nextSliceIndex = sliceIndex + 1
            
            if nextSliceIndex <= file.dataSliceArray.count - 1 {
                // 不是最后一个包，继续发送
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    self.otaNandResStepSendFilePacketData(fileIndex: fileIndex, sliceIndex: nextSliceIndex)
                }
            }else{
                //已经发送完最后一个包了
                
                // 更新进度并回调
                resProgress.completedFileSliceCount = file.dataSliceArray.count
                let resCompletedBytes = self.resCompletedBytes
                self.delegate?.otaModuleProgress(module: self, stage: .nand_res, stageTotalBytes: resProgress.totalBytes, stageCompletedBytes: resCompletedBytes)
                
                // 发送FileEndRequest，在FileEndRequest中处理resProgress
                self.otaNandResStepFileEndRequest()
            }
            return
        }
        
        let rspTask = OTANandResTaskFilePacketData.init(packetOrderNumber: UInt16(packetOrder), packetData: packetData) {[weak self] task, result, newRspFreq, remoteCompletedPacketCount, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            OLog("✅\(task.name())响应(orderNum=\(task.packetOrderNumber), sliceLength=\(task.packetData.count)): result=\(result), newRspFreq=\(newRspFreq), remoteCompletedPacketCount=\(remoteCompletedPacketCount)")

            if result == 13 {
                // 包序号错误，更新response频率以及从指定序号重发
                if remoteCompletedPacketCount == file.dataSliceArray.count{
                    //发下一个文件
                    OLog("已完成当前文件所有切片传输，发送文件结束...complete=\(remoteCompletedPacketCount):\(file.dataSliceArray.count)")
                    s.otaNandResStepFileEndRequest()
                    return
                }else if remoteCompletedPacketCount > file.dataSliceArray.count {
                    OLog("❌错误的remoteCompletedPacketCount:\(remoteCompletedPacketCount), 当前发送sliceIndex=\(sliceIndex)")
                    let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Device Completed Packet Count")
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
                
                let oldFreq = s.resProgress.responseFrequency
                let oldSliceCompletedCount = s.resProgress.completedFileSliceCount
                
                s.resProgress.completedFileSliceCount = remoteCompletedPacketCount
                if newRspFreq > 0 {
                    s.resProgress.responseFrequency = newRspFreq
                    s.resProgress.continueSendNoResponsePacketCount = remoteCompletedPacketCount % newRspFreq
                }else{
                    OLog("❌异常的New Response Frequency:\(newRspFreq)!!!")
                    let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Device Response Frequency")
                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    return
                }
               
                
                OLog("⚠️调整responseFreq:\(oldFreq)===>\(s.resProgress.responseFrequency), completedCount:\(oldSliceCompletedCount) ===> \(remoteCompletedPacketCount)")
                
                // 重新回调进度
                s.delegate?.otaModuleProgress(module: s, stage: .nand_res, stageTotalBytes: s.resProgress.totalBytes, stageCompletedBytes: s.resCompletedBytes)
                
                s.otaNandResStepSendFilePacketData(fileIndex: fileIndex, sliceIndex: remoteCompletedPacketCount)
                return
            }
            if result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: result)
                let err = SFOTAError.DevErrorCode(errorCode: result)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            // 成功，更新进度
            s.resProgress.continueSendNoResponsePacketCount = 0
            s.resProgress.completedFileSliceCount = sliceIndex + 1
            let resCompletedBytes = s.resCompletedBytes
            // 进度回调
            s.delegate?.otaModuleProgress(module: s, stage: .nand_res, stageTotalBytes: s.resProgress.totalBytes, stageCompletedBytes: resCompletedBytes)
            
            let curFileIndex = s.resProgress.currentFileIndex
            let curFile = s.sortedResFileArray[curFileIndex]
            if s.resProgress.completedFileSliceCount > curFile.dataSliceArray.count {
                fatalError("❌completedFileSliceCount Over dataSliceArray.count")
            }
            // 判断sliceIndex是否到末尾
            if sliceIndex < curFile.dataSliceArray.count - 1 {
                // 还未发送完Slice
                let nextSliceIndex = sliceIndex + 1
                s.otaNandResStepSendFilePacketData(fileIndex: curFileIndex, sliceIndex: nextSliceIndex)
            }else {
                // 已经发送完该file
                // 进入FileEndRequest流程
                // 并在该流程中判断是否进入下一个文件的发送
                s.otaNandResStepFileEndRequest()
            }
        }
        self.resume(task: rspTask)
    }
    
    
    private func otaNandResStepFileEndRequest() {
        // 在这里判断并更新resProgress.fileIndex信息
        let curFileIndex = resProgress.currentFileIndex
        let curFileOrder = UInt16(curFileIndex + 1)
        OLog("\(ResLogPrefix)-FileEndRequest: fileOrderNumber=\(curFileOrder)")

        let task = OTANandResTaskFileEndRequest.init(fileOrderNumber: curFileOrder) {[weak self] task, result, error in
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
            // 判断res文件是否发送完毕
            if curFileIndex < s.sortedResFileArray.count - 1 {
                // 还有文件没发送
                s.resProgress.currentFileIndex = curFileIndex + 1
                s.resProgress.completedFileSliceCount = 0
                s.resProgress.continueSendNoResponsePacketCount = 0
                
                // 进入下一个文件的发送
                s.otaNandResFileStartRequest()
            }else{
                // res文件已经发送完毕
                s.otaNandResStepFileTotalEndRequest()
            }
        }
        self.resume(task: task)
    }
    
    private func otaNandResStepFileTotalEndRequest() {
        let hasHcpuFiles = controlFile != nil
        OLog("\(ResLogPrefix)-FileTotalEndRequest: hcpuUpdate=\(hasHcpuFiles)")
        let task = OTANandResTaskFileTotalEndRequest.init(hcpuUpdate: hasHcpuFiles) {[weak self] task, result, error in
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
            let tsk = task as! OTANandResTaskFileTotalEndRequest
            if tsk.hcpuUpdate {
                //进入到hcpu升级流程
                s.otaNandHCPUStepImageInitRequest()
            }else{
                // 回调成功
                OLog("✅升级成功")
                s.delegate?.otaModuleCompletion(module: s, error: nil)
            }
        }
        self.resume(task: task)
    }
    
    private func otaNandHCPUStepImageInitRequest() {
        OLog("\(HcpuLogPrefix)-ImageInitRequest")
        self.mainStatus = .image
        self.delegate?.otaModuleProgress(module: self, stage: .nand_image, stageTotalBytes: imageProgress.totalBytes, stageCompletedBytes: imageCompletedBytes)
        
        guard let ctrlData = self.controlFile else {
            OLog("❌没有control文件，终止升级")
            let error = SFOTAError.init(errorType: .General, errorDes: "缺少Control文件")
            self.delegate?.otaModuleCompletion(module: self, error: error)
            return
        }
        
        let task = OTANandHcpuTaskImageInitRequestExt.init(ctrlPacketData: ctrlData) {[weak self] task, msg, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            OLog("✅\(task.name())响应: result=\(msg!.result), resumeInfos=\(msg!.resumeInfos?.toString() ?? "nil")")
            
            let result = msg!.result
            if result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: Int(result))
                let err = SFOTAError.DevErrorCode(errorCode: Int(result))
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            
            var resume = false
            if let resumeInfos = msg!.resumeInfos, s.tryResume == true {
                // 设备支持续传，且用户允许尝试续传
                resume = true
                
                // 是否需要从指定image的第一个包开始
                let resumeRestart = resumeInfos.resumeRestart
                let imageIdValue = resumeInfos.imageIdValue
                var completedCount:UInt32 = 0
                let frequency = resumeInfos.rspFrequency
                
                var startFileIndex = -1
                
                guard let imageId = NandImageID.init(rawValue: UInt16(imageIdValue)) else {
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
                    // 需要从指定的ImageID的第一个包开始发送
                    completedCount = 0
                }else{
                    // 使用返回的completedPacketCount，对这个数据进行合理性校验
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
                    OLog("❌Invalid Response Frequency Value From Device: freq=\(frequency).SDK will continue without try resume.")
//                    let err = SFOTAError.init(errorType: .General, errorDes: "Invalid Response Frequency Value From Device")
//                    s.delegate?.otaModuleCompletion(module: s, error: err)
                    resume = false
//                    return
                }else{
                    s.imageProgress.currentFileIndex = startFileIndex
                    s.imageProgress.responseFrequency = Int(frequency)
                    s.imageProgress.completedFileSliceCount = Int(completedCount)
                    s.imageProgress.continueSendNoResponsePacketCount = Int(completedCount) % Int(frequency)
                    OLog("▶️即将使用的resume条件: fileIndex=\(s.imageProgress.currentFileIndex), completedCount=\(s.imageProgress.completedFileSliceCount), ResponseFrequency=\(s.imageProgress.responseFrequency)")
                }
               
            }else{
                // 不进行续传
            }
            s.delegate?.otaModuleProgress(module: s, stage: .nand_image, stageTotalBytes: s.imageProgress.totalBytes, stageCompletedBytes: s.imageCompletedBytes)
            s.otaNandHCPUStepImageInitCompletedExt(resume: resume)
        }
        self.resume(task: task)
    }
    
    
    private func otaNandHCPUStepImageInitCompletedExt(resume:Bool) {
        OLog("\(HcpuLogPrefix)-ImageInitCompletedExt: resume=\(resume),fileIndex=\(imageProgress.currentFileIndex),completedCount=\(imageProgress.completedFileSliceCount),rspFreq=\(imageProgress.responseFrequency)")
        let task = OTANandHcpuTaskImageInitCompletedExt.init(resume: resume)
        self.resume(task: task)
        
        self.otaNandHCPUStepImageStartRequest()
    }
    
    private func otaNandHCPUStepImageStartRequest() {
        let file = imageFileArray[imageProgress.currentFileIndex]
        let fileLength = UInt32(file.data.count)
        let sliceCount = UInt32(file.dataSliceArray.count)
        let frequency = UInt8(imageProgress.responseFrequency)
        let imageID = file.imageID
        OLog("\(HcpuLogPrefix)-ImageStartRequest: fileIndex=\(imageProgress.currentFileIndex), imageId=\(imageID),fileLength=\(fileLength), packetCount=\(sliceCount), rspFreq=\(frequency)")
        let task = OTANandHcpuTaskImageStartRequest.init(fileLength: fileLength, sliceCount: sliceCount, rspFreq: frequency, imageId: imageID) {[weak self] task, result, error in
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
            let fileIndex = s.imageProgress.currentFileIndex
            let sliceIndex = s.imageProgress.completedFileSliceCount
            s.otaNandHCPUStepImagePacketData(fileIndex: fileIndex, sliceIndex: sliceIndex)
        }
        task.timeout = 180.0
        self.resume(task: task)
    }
    
    private func otaNandHCPUStepImagePacketData(fileIndex:Int, sliceIndex:Int) {
        if(self.mainStatus != .image){
            OLog("otaNandHCPUStepImagePacketData mainStatus != .image ignore")
            return
        }
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        if(sliceIndex == file.dataSliceArray.count){
            self.otaNandHCPUStepImageEndRequest()
            return
        }
        let sliceData = file.dataSliceArray[sliceIndex]
        let orderNumber = UInt32(sliceIndex + 1)
        let needRsp = imageProgress.continueSendNoResponsePacketCount == imageProgress.responseFrequency - 1
        if imageProgress.continueSendNoResponsePacketCount >= imageProgress.responseFrequency {
            fatalError("❌continueSendNoResponsePacketCount=\(imageProgress.continueSendNoResponsePacketCount) OverRange responseFrequency=\(imageProgress.responseFrequency)")
        }
        OLog("\(HcpuLogPrefix)-ImagePacketData(\(needRsp ? "Rsp":"No Rsp")): fileIndex=\(fileIndex), imageId=\(imageId), fileProgress=\(orderNumber)/\(file.dataSliceArray.count),cs=\(imageProgress.continueSendNoResponsePacketCount)")
        
        
        if isLoseChecking {
            OLog("⚠️处于LoseChecking状态，暂停发送ImagePacketData(imageId=\(imageId), fileIndex=\(fileIndex))")
            return
        }
        
        if deviceOtaVersion < 2 {
            if orderNumber > UInt16.max {
                OLog("⚠️deviceOtaVersion=\(deviceOtaVersion),orderNumber=\(orderNumber)>UInt16.max")
                let error = SFOTAError.init(errorType: .FileTooLarge, errorDes: "文件大小超出协议范围.")
                self.delegate?.otaModuleCompletion(module: self, error: error)
                return;
            }
        }
        
        if needRsp {
            let task = OTANandHcpuTaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData,otaVersion: deviceOtaVersion) {[weak self] task, result, error in
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
                
                s.imageProgress.completedFileSliceCount = sliceIndex + 1
                let completedBytes = s.imageCompletedBytes
                
                // 回调进度
                s.delegate?.otaModuleProgress(module: s, stage: .nand_image, stageTotalBytes: s.imageProgress.totalBytes, stageCompletedBytes: completedBytes)
                
                let curFileIndex = s.imageProgress.currentFileIndex
                let curFile = s.imageFileArray[curFileIndex]
                
                let nextSliceIndex = sliceIndex + 1
                if nextSliceIndex <= curFile.dataSliceArray.count - 1 {
                    // 还未发送完毕
                    s.otaNandHCPUStepImagePacketData(fileIndex: curFileIndex, sliceIndex: nextSliceIndex)
                }else {
                    // 已经发送完毕
                    s.otaNandHCPUStepImageEndRequest()
                }
            }
            self.imageProgress.continueSendNoResponsePacketCount = 0
            self.resume(task: task)
        }else{
            // 先执行发送操作
            let task = OTANandHcpuTaskImagePacketData.init(imageID: imageId, imageOrderNumber: orderNumber, data: sliceData,otaVersion: deviceOtaVersion, completion: nil)
            self.resume(task: task)
            imageProgress.continueSendNoResponsePacketCount += 1
            let nextSliceIndex = sliceIndex + 1
            if nextSliceIndex <= file.dataSliceArray.count - 1 {
                // 还未到末尾
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    self.otaNandHCPUStepImagePacketData(fileIndex: fileIndex, sliceIndex: nextSliceIndex)
                }
            }else {
                // 已经发送完最后一个包
                imageProgress.completedFileSliceCount = file.dataSliceArray.count
                let completedBytes = self.imageCompletedBytes
                self.delegate?.otaModuleProgress(module: self, stage: .nand_image, stageTotalBytes: imageProgress.totalBytes, stageCompletedBytes: completedBytes)
                self.otaNandHCPUStepImageEndRequest()
            }
        }
    }
    
    
    private func otaNandHCPUStepImageEndRequest() {
        let fileIndex = imageProgress.currentFileIndex
        let file = imageFileArray[fileIndex]
        let imageId = file.imageID
        
        let moreImage = fileIndex < (imageFileArray.count - 1)
        let fileLength = UInt32(file.data.count)
        
        OLog("\(HcpuLogPrefix)-ImageEndRequest: fileIndex=\(fileIndex), imageId=\(imageId), fileCount=\(imageFileArray.count), hasMoreImage=\(moreImage)")

        
        let task = OTANandHcpuTaskImageEndRequest.init(fileLength:fileLength, imageId: imageId, moreImage: moreImage) {[weak self] task, result, error in
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
            let tsk = task as! OTANandHcpuTaskImageEndRequest
            if tsk.moreImage {
                let nextFileIndex = s.imageProgress.currentFileIndex + 1
                s.imageProgress.currentFileIndex = nextFileIndex
                s.imageProgress.completedFileSliceCount = 0
                s.imageProgress.continueSendNoResponsePacketCount = 0
                // 进入下一个Image文件的发送流程
                s.otaNandHCPUStepImageStartRequest()
            }else{
                // 进入最后流程
                s.otaNandHCPUStepImageTransmissionEnd()
            }
        }
        self.resume(task: task)

    }
    
    private func otaNandHCPUStepImageTransmissionEnd(){
        let task = OTANandHcpuTaskImageTransEnd.init {[weak self] task, result, error in
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
            OLog("✅升级成功")
            s.delegate?.otaModuleCompletion(module: s, error: nil)
        }
        self.resume(task: task)
    }
    
    private func resume(task:OTANandTaskBase) {
        let msgPackData = task.toNandMessageData()

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
                if QBleCore.sharedInstance.isShakedHands == false {
                    // QBleCore侵入了Module，待优化
                    OLog("⚠️蓝牙未连接，OTANandTaskBase直接回调失败")
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
    
    // nandTask超时回调
    func nandBaseTaskTimeout(task: OTANandTaskBase) {
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
    
    /// OTA结束后的清理工作
    override func clear() {
        delayRestartTimer?.invalidate()
        delayRestartTimer = nil
        isLoseChecking = false
        sortedResFileArray.removeAll()
        controlFile = nil
        imageFileArray.removeAll()
        tryResume = false
        currentTask?.stopTimer()
        currentTask = nil
        mainStatus = .none
        resProgress.reset()
        imageProgress.reset()
    }
    

}
