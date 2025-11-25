//
//  SFOTANorOfflineModule.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/12/24.
//

import UIKit
fileprivate enum NorOfflineMainStatus {
    case none
    case dfuInitConnecting // 最开始的连接，包含了Manager的searching和connecting过程
    case start   // DFU_IMAGE_OFFLINE_START_REQ
    case sendData // 发送数据
    case end // 结束请求DFU_IMAGE_OFFLINE_END_REQ
    case done   // 结束
}

class SFOTANorOfflineModule: SFOTAModuleBase,OTANorV2BaseTaskDelegate {
    @objc static let share = SFOTANorOfflineModule.init(name: "Nor_Offline")
    private override init(name: String) {
        super.init(name: name)
    }

    /// 当前正在等待响应的任务
    private var currentTask:OTANorV2TaskBase?
    private var offlineImageFile:NorOfflineImageFile?
    weak var delegate:SFOTAModuleDelegate?
    private let progress = NorProgressRecord.init()
    /// 模块当前所处的主要状态
    private var mainStatus:NorOfflineMainStatus = .none {
        didSet{
            OLog("ℹ️设置NorOfflineMainStatus:\(oldValue) ==> \(mainStatus)")
        }
    }
    
    private var completedBytes:Int {
        if let curFile = self.offlineImageFile{
            var completed = 0
           
            if progress.completedFileSliceCount == curFile.dataSliceArray.count {
                // 最后一个包
                completed += curFile.data.count
            }else{
                completed += progress.completedFileSliceCount * NorOfflineImageFile.SliceLength
            }
            return completed
        }else{
            return 0
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
            if self.mainStatus == .dfuInitConnecting{
                // 只在该阶段才处理连接超时回调
                let error = SFOTAError.init(errorType: .SearchTimeout, errorDes: "搜索目标外设超时")
                // Manager在该回调中统一对Module执行clear操作
                self.delegate?.otaModuleCompletion(module: self, error: error)
            }else {
                OLog("⚠️[异常]NorV2Module处于\(mainStatus)状态，收到了搜索超时的消息")
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
            // 仅在下面两个状态下才处理连接成功的阶段处理该事件，其它时候忽略该事件
            if mainStatus == .dfuInitConnecting {
                self.otaNorOfflineStepStartReq()
            } else {
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
            OLog("❌解析Nor Offline Message失败: 数据长度(\(data.count))小于5字节。")
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
        
       
            OLog("⚠️未处理的设备消息：\(messageType)")
        
    }
    
    override func clear() {
        currentTask?.stopTimer()
        currentTask = nil
        mainStatus = .none
        progress.reset()
    }
    //---- OTANorV2BaseTaskDelegate
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
    
    public func start(offlineFilePath:URL){
        OLog("原始参数: offlineFile=\(offlineFilePath)")
        
        guard let fileData = try? Data.init(contentsOf: offlineFilePath) else {
            OLog("❌加载Image失败:path=\(offlineFilePath.path)")
            let otaError = SFOTAError.init(errorType: .LoadImageFileFailed, errorDes: "加载Image文件失败")
            self.delegate?.otaModuleCompletion(module: self, error: otaError)
            return
        }
        OLog("offlineFile data length=\(fileData.count)")
        if(fileData.count < 12){
            OLog("❌加载Image失败:nor offline image file data length < 12")
            let err = SFOTAError.init(errorType: .InvalidParams, errorDes: "nor offline image file data length < 12")
            self.delegate?.otaModuleCompletion(module: self, error: err)
            return
        }
        //check magic
        var magic:UInt32 = 0;
        var crc32:UInt32 = 0;
        let pd = NSData.init(data: fileData)
        pd.getBytes(&magic, range: NSRange.init(location: 0, length: 4))
        pd.getBytes(&crc32, range: NSRange.init(location: 8, length: 4))
        if(magic != 0x53454346){
            OLog("❌加载Image失败:nor offline image file magic error")
            let err = SFOTAError.init(errorType: .InvalidParams, errorDes: "nor offline image file magic error")
            self.delegate?.otaModuleCompletion(module: self, error: err)
            return
        }
        self.offlineImageFile = NorOfflineImageFile.init(crc32: crc32, data: fileData)
        self.progress.totalBytes = fileData.count;
        self.mainStatus = .dfuInitConnecting
        /// 发起连接请求，等待ble
        OLog("otaModuleReconnectRequest...")
        self.delegate?.otaModuleReconnectRequest(module: self)
    }
    
    private func otaNorOfflineStepStartReq(){
        OLog("")
        self.mainStatus = .start
        let fileLength:UInt32 = UInt32(self.offlineImageFile!.data.count);
        let packetCount:UInt32 = UInt32(self.offlineImageFile!.dataSliceArray.count)
        let crc32 = self.offlineImageFile!.crc32
        let initTask = SFOTANorOfflineStartRequest.init(fileLength: fileLength, packetCount: packetCount, crc32: crc32) { [weak self]task, msg, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            let message:NorOfflineStartRequestMsg = msg!
            
            OLog("✅\(task.name())响应:result=\(message.result),  completeCount=\(message.completeCount)")

            
            if message.result != 0 {
                LogDevErrorCode(taskDes: task.name(), errorCode: Int(message.result))
                let err = SFOTAError.DevErrorCode(errorCode: Int(message.result))
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
                        
//            var resume = false
            var sliceIndex:Int = 0
            if message.completeCount > 0 {
                
                // 需要从指定imageId开始
//                resume = true
                sliceIndex = Int(message.completeCount);
                s.progress.completedFileSliceCount = Int(message.completeCount)
                OLog("▶️即将使用的resume条件: fileIndex=\(s.progress.currentFileIndex), completedCount=\(s.progress.completedFileSliceCount)")
            }
            s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: s.completedBytes)
            s.otaNorOfflineStepPacketReq(sliceIndex: sliceIndex)
        }
        self.resume(task: initTask)
    }
    
    private func otaNorOfflineStepPacketReq(sliceIndex: Int){
        OLog("")
        if(self.offlineImageFile == nil){
            OLog("❌加载Image失败:nor offline image file is nil")
            let err = SFOTAError.init(errorType: .InvalidParams, errorDes: "加载Image失败:nor offline image file is nil")
            self.delegate?.otaModuleCompletion(module: self, error: err)
            return
        }
        self.mainStatus = .sendData
        if(self.progress.completedFileSliceCount >= self.offlineImageFile!.dataSliceArray.count){
            OLog("⚠️已是最后一包，将直接发送结束")
            self.otaNorOfflineEndReq()
            return;
        }
        let packetOrder = UInt32(sliceIndex + 1)
        let packetData = self.offlineImageFile!.dataSliceArray[sliceIndex]
        let dataLength = UInt32(packetData.count)
        var verifyValue = CRCUtil.CRC32_MPEG2(src: packetData, offset: 0, length: packetData.count)
        let packetRequest = SFOTANorOfflinePacketRequest.init(packetOrder: packetOrder, dataLength: dataLength, crc: verifyValue, packetData: packetData) { [weak self]task, msg, error in
            guard let s = self else {
                return
            }
            if let err = error {
                LogTaskError(taskDes: task.name(), error: err)
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            let packetMsg:NorOfflinePacketMsg = msg!
            let result = packetMsg.result
            OLog("✅\(task.name())响应（orderNumer=\(task.packetOrder), sliceLength=\(task.packetData.count)）: result=\(result),retransmission=\(packetMsg.retransmission),completeCount=\(packetMsg.completeCount)")
            
            if result != 0 && packetMsg.retransmission == 0{
                //有错误码，且不需要续传，则认为是出错。
                LogDevErrorCode(taskDes: task.name(), errorCode: Int(result))
                let err = SFOTAError.DevErrorCode(errorCode: Int(result))
                s.delegate?.otaModuleCompletion(module: s, error: err)
                return
            }
            var nextSliceIndex = sliceIndex + 1
            if(packetMsg.retransmission == 1){
                //需要调整发送序号为手表指定
                OLog("设备要求调整包序号... =>\(packetMsg.completeCount)")
                nextSliceIndex = Int(packetMsg.completeCount);
            }
            
            s.progress.completedFileSliceCount = nextSliceIndex
            let completedBytes = s.completedBytes
            
            // 回调进度
            s.delegate?.otaModuleProgress(module: s, stage: .nor, stageTotalBytes: s.progress.totalBytes, stageCompletedBytes: completedBytes)
            
            if nextSliceIndex <= s.offlineImageFile!.dataSliceArray.count - 1 {
                // 还未发送完毕
                s.otaNorOfflineStepPacketReq(sliceIndex: nextSliceIndex)
            }else {
                // 已经发送完毕
                s.otaNorOfflineEndReq()
            }
        }
        self.resume(task: packetRequest)
    }
    
    private func otaNorOfflineEndReq(){
        OLog("otaNorOfflineEndReq")
        self.mainStatus = .end
        let endRequest = SFOTANorOfflineEndRequest.init { [weak self]task, result, error in
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
            QPrint("✅✅✅Nor Offline OTA成功")
            s.mainStatus = .done
            s.delegate?.otaModuleCompletion(module: s, error: nil)
        }
        self.resume(task: endRequest)
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
}
