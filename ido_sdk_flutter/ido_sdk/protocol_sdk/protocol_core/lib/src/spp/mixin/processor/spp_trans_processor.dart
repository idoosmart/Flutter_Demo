import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:protocol_core/src/spp/extension/data.dart';

import '../../../logger/logger.dart';
import 'md5.dart';
import '../../model/error.dart';
import '../../model/spp_cmd.dart';
import '../../model/type_def.dart';
import '../../spp_trans_manager.dart';
import 'spp_base_processor.dart';

///
/// @author tianwei
/// @date 2024/3/22 18:50
/// @desc
///

//断点续传次数
const DATA_TRAN_CONTINUE_TIMES = 5;
//传输超时
const DATA_TRAN_TIMEOUT = 35 * 1000;
const DATA_CONTINUE_TRAN_TIMEOUT = 50 * 1000;
const LONG_FILE_SIZE = 200;
const FREAD_MAX_SIZE = 40960;
const SPP_MAX_MTU = 2048;

enum TransStatus {
  TRAN_STATUS_IDLE,
  TRAN_STATUS_REQUEST,
  TRAN_STATUS_PACKET,
  TRAN_STATUS_END,
  TRAN_STATUS_PRN,
  TRAN_STATUS_SELECT,
  TRAN_STATUS_CONTINUE,
  TRAN_STATUS_SEND_ORI_SIZE,
}

class DataTransStatus {
  TransStatus status = TransStatus.TRAN_STATUS_IDLE;
  int curTranOffset = 0; //当前传输偏移
  int curTranCheckCode = 0; //当前已经所有已经传输的校验码

  int noticePacketCount = 0; //当前通知包的统计
  int noticePacketSize = 0; //当前通知包大小
  bool isWaitNoticePacket = false; //是否在等待数据包
  bool isPackSending = false; //是否正在发送数据包
  int tranProgress = 0; //传输进度
  int retryCount = 0; //重试次数

  void reset() {
    status = TransStatus.TRAN_STATUS_IDLE;
    curTranOffset = 0;
    curTranCheckCode = 0;
    noticePacketCount = 0;
    noticePacketSize = 0;
    isWaitNoticePacket = false;
    isPackSending = false;
    tranProgress = 0;
    retryCount = 0;
  }
}

class TransData {
  Uint8List? fieBuff;
  int size = 0;

  //02:爱都(AGPS/字库/壁纸)  0xFF:表盘
  int type = 0;
  int checkCode = 0;
  int prn = 0;

  //文件名 目标文件名
  String? fileName;

  //压缩类型
  int compressionType = 0;

  //解压前的文件大小
  int originalSize = 0;

  //文件路径 素材文件路径
  String? filePath;
  bool isSpp = true;
}

mixin SppTransProcessor on BaseSppProcessor implements SppTransManager {
  ///断点续传次数
  int mContinueTimes = 5;
  String mMD5 = "";
  String mSavedMD5 = "";

  ///文件传输配置
  late TransData mTransData;

  ///文件传输状态
  late DataTransStatus mDataTransStatus = DataTransStatus();

  ///存放一次读取的文件内容（根据mtu设置大小）
  Uint8List? sendData;

  ///是否需要先传输文件原始大小，ble传输表盘需要
  bool tranOriginalSizeFirst = false;

  Timer? sendTimeOutTimer;
  Timer? lastReceiveTimeOutTimer;

  CallbackDataTranCompleteCbHandle? completeCallback;
  CallbackDataTranProgressCbHandle? progressCallback;

  @override
  bool initProcessor() {
    _cleanDataTransStatus();
    return true;
  }

  @override
  int onDisconnect() {
    if (mDataTransStatus.status == TransStatus.TRAN_STATUS_IDLE) {
      return SUCCESS;
    }
    logger?.i("spp disconnected");
    if (supportSppDataTransContinue()) {
      mSavedMD5 = mMD5;
      logger?.e(
          "SET_BLE_EVT_DISCONNECT  mDataTransStatus.status = ${mDataTransStatus.status}");
      if (mDataTransStatus.status != TransStatus.TRAN_STATUS_IDLE) {
        _setStatus(TransStatus.TRAN_STATUS_CONTINUE);
      }
      return SUCCESS;
    }
    _stopLastReceiveTimeoutTimer();
    if (mDataTransStatus.status != TransStatus.TRAN_STATUS_IDLE) {
      _notifyStatusOut(ERROR_INVALID_STATE, DATA_TRAN_ERROR_VALUE_STATUS_ERROR);
    }
    if (!supportSppDataTransContinue()) {
      _stopDataTrans();
    }
    return SUCCESS;
  }

  ///
  /// 处理固件返回的数据，因为在[SppTransManagerImp]的with最后，所以最先执行
  /// 必须调用super，否则[SppCmdProcessor] 的[processReceivedSppCmd]不会执行
  @protected
  @override
  int processReceivedSppCmd(SppCmd data) {
    super.processReceivedSppCmd(data);
    ProtocolHead head = data.head;
    if (head.cmd != PROTOCOL_CMD_DATA_TRAN_SPP) {
      return SUCCESS;
    }

    if (!isSppTranStart()) {
      logger?.e("warn:spp trans already started!");
      return ERROR_INVALID_STATE;
    }

    //重置50秒定时器
    _startTransTimeoutTimer();

    switch (head.key) {
      case PROTOCOL_KEY_DATA_TRAN_REQUEST:
        if (mDataTransStatus.status != TransStatus.TRAN_STATUS_REQUEST) {
          logger?.e(
              "1 warn:invalid cmd reply cur tran status is ${mDataTransStatus.status}");
          return ERROR_INVALID_STATE;
        }
        final reply = SppDataTransRequestReply(data.original);
        if (reply.succeed) {
          //d2 01 成功
          _setStatus(TransStatus.TRAN_STATUS_PRN);
        } else {
          //d2 01 失败，停止传输
          logger?.i("err:spp data tran request fail(${reply.errCode})");
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, reply.errCode);
        }
        break;
      case PROTOCOL_KEY_DATA_TRAN_PACKET:
        if (mDataTransStatus.status != TransStatus.TRAN_STATUS_PACKET) {
          logger?.e(
              "2 warn:invalid cmd reply cur tran status is ${mDataTransStatus.status}");
          return ERROR_INVALID_STATE;
        }

        ///沒有传输完成，但是也米有在等待表示状态异常了
        if (mDataTransStatus.isWaitNoticePacket == false &&
            isTransEnd() == false) {
          logger?.e("warn:invalid packet");
          return SUCCESS;
        }
        mDataTransStatus.isWaitNoticePacket = false;
        final reply = SppDataTransPacketReply(data.original);
        if (!reply.succeed) {
          logger?.e("err:get tran notice packet err(${reply.errCode})");
          if (supportSppDataTransContinue()) {
            _continueDataTrans();
            return SUCCESS;
          } else {
            _stopDataTransAndNotifyStatusOut(
                ERROR_INVALID_STATE, reply.errCode);
            return ERROR_INVALID_STATE;
          }
        }

        int checkResult = _checkCodeOptimized(
            mTransData.filePath ?? "",
            mDataTransStatus.curTranOffset,
            mDataTransStatus.curTranOffset + mDataTransStatus.noticePacketSize);
        //校驗沒通過
        if (checkResult != SUCCESS) {
          logger?.e("err:get cal check code fail,stop tran");
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, reply.errCode);
          return ERROR_INVALID_STATE;
        }

        //判斷偏移是否一致
        if (mDataTransStatus.curTranOffset +
                    mDataTransStatus.noticePacketSize !=
                reply.offset ||
            mDataTransStatus.curTranCheckCode != reply.checkCode) {
          if (mDataTransStatus.curTranCheckCode != reply.checkCode) {
            logger?.e(
                "err:get data check code from ble(0x${reply.checkCode.toHexString}) != app calculate check code(0x${mDataTransStatus.curTranCheckCode.toHexString}");
          } else {
            logger?.e(
                "err:get data offset from ble(${reply.offset}) != app cur tran offset(${mDataTransStatus.curTranCheckCode + mDataTransStatus.noticePacketSize})");
          }
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, reply.errCode);
          return ERROR_INVALID_STATE;
        }

        //刷新进度
        _noticePacketCompleted();
        _tranProcessFast();
        break;
      case PROTOCOL_KEY_DATA_TRAN_END:
        final reply = SppDataTransEndReply(data.original);
        if (reply.succeed) {
          logger?.i("file trans complete!");
          _setStatus(TransStatus.TRAN_STATUS_IDLE);
          _stopDataTransAndNotifyStatusOut(SUCCESS, reply.errCode);
        } else {
          logger?.e("err:spp data tran request tran end fail(${reply.errCode})");
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, reply.errCode);
        }
        break;
      case PROTOCOL_KEY_DATA_TRAN_OFFSET:
        break;
      case PROTOCOL_KEY_DATA_TRAN_PRN_VALUE:
        if (mDataTransStatus.status != TransStatus.TRAN_STATUS_PRN) {
          logger?.e(
              "3 warn:invalid cmd reply cur tran status is ${mDataTransStatus.status}");
          return ERROR_INVALID_STATE;
        }
        final reply = SppDataTransPrnSetReply(data.original);
        if (reply.succeed) {
          _setStatus(TransStatus.TRAN_STATUS_PACKET);
          if (supportSppDataTransContinue()) {
            //刷新prn
            if (reply.getPrn > 0) {
              mTransData.prn = reply.getPrn;
            }
          }
        } else {
          logger?.e("err:tran set prn value fail(${reply.errCode}");
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, reply.errCode);
        }
        break;
      case PROTOCOL_KEY_DATA_TRAN_SELECT:
        //无效包
        if (mDataTransStatus.status != TransStatus.TRAN_STATUS_SELECT) {
          logger?.e(
              "4 warn:invalid cmd reply cur tran status is ${mDataTransStatus.status}");
          return ERROR_INVALID_STATE;
        }

        final reply = SppDataTransContinueReply(data.original);
        if (reply.succeed &&
            mDataTransStatus.curTranCheckCode == reply.checkCode) {
          //校验码正确
          _setTransOffset(reply.offset, reply.checkCode);
          //重新設置prn
          _setStatus(TransStatus.TRAN_STATUS_PRN);
        } else {
          //校验码错误或失败，重试
          logger?.e(
              "err:get ble save cur data offset err(app calculate check code:0x${mDataTransStatus.curTranCheckCode.toHexString},get check code) restart transmission");
          _stopDataTrans();
          int code = sppTranDataStart();
          if (code != SUCCESS) {
            _notifyStatusOut(ERROR_INVALID_STATE, code);
          }
        }
        break;
      case PROTOCOL_KEY_DATA_TRAN_SEND_ORIGINAL_SIZE:
        //spp不需要
        break;
      case PROTOCOL_KEY_DATA_TRAN_MANUAL_STOP:
        break;
    }
    _tranProcess();
    return SUCCESS;
  }

  @override
  int registerSppDataTranCompleteCallback(
      {required CallbackDataTranCompleteCbHandle func}) {
    completeCallback = func;
    return SUCCESS;
  }

  @override
  int registerSppDataTranProgressCallbackReg(
      {required CallbackDataTranProgressCbHandle func}) {
    progressCallback = func;
    return SUCCESS;
  }

  @override
  int sppTranDataSetBuffByPath(
      {required int dataType,
      required String srcPath,
      required String fileName,
      required int compressionType,
      required int oriSize}) {
    if (srcPath.isEmpty || fileName.isEmpty) {
      logger?.e(
          "err:${srcPath.isEmpty ? "src file path null" : ""}${fileName.isEmpty ? "dst file name null" : ""}");
      return ERROR_INVALID_PARAM;
    }

    final transFile = File(srcPath);
    if (!transFile.existsSync()) {
      logger?.e("err: file($srcPath) not exists");
      return ERROR_FILE_NOT_FIND;
    }
    int totalSize = 0;
    try {
      totalSize = transFile.lengthSync();
    } catch (e) {
      return ERROR_FILE_OPERATE_FAILED;
    }
    //初始化传输数据
    mTransData = TransData();
    mTransData.fileName = fileName;
    mTransData.filePath = srcPath;
    mTransData.size = totalSize;
    mTransData.compressionType = compressionType;
    mTransData.type = dataType;
    mTransData.originalSize = oriSize;

    //初始化数据缓存
    sendData = Uint8List(txMtu);

    //判断是否需要先发文件原始大小，ble表盘需要，配合功能表
    tranOriginalSizeFirst = false;
    if (fileName.endsWith("iwf.lz")) {
      tranOriginalSizeFirst = true;
    }
    logger?.i(
        "spp data tran set buf,file type:$dataType,src file path:$srcPath,file name:$fileName,compression type:$compressionType,file size:$totalSize,original size:$oriSize,${tranOriginalSizeFirst ? "need to send original size" : "not need to send original size"}");

    //TODO md5计算,断点续传需要
    mMD5 = calculateMD5(transFile);
    logger?.d("md5: $mMD5");
    return SUCCESS;
  }

  @override
  int sppTranDataSetPRN(int num) {
    mTransData.prn = num;
    return SUCCESS;
  }

  @override
  int sppTranDataStart() {
    logger?.i("start spp trans");
    if (supportSppDataTransContinue()) {
      if (mDataTransStatus.status == TransStatus.TRAN_STATUS_CONTINUE) {
        logger?.e("md5 is equal: ${mSavedMD5.isNotEmpty && mSavedMD5 == mMD5}");
        if (mSavedMD5.isNotEmpty &&
            mSavedMD5 == mMD5 &&
            mDataTransStatus.retryCount < 3) {
          _continueDataTrans();
          return SUCCESS;
        } else {
          logger?.e("err:not same file,save md5 != cur md5");
          if (mSavedMD5.isNotEmpty && mSavedMD5 == mMD5) {
            mSavedMD5 = "";
          }
          _stopDataTrans();
        }
      }
    }

    if (mDataTransStatus.status != TransStatus.TRAN_STATUS_IDLE) {
      logger?.e("err:tran status invalid(${mDataTransStatus.status})");
      return ERROR_INVALID_STATE;
    }
    mDataTransStatus.retryCount = 0;
    _cleanDataTransStatus();
    if (tranOriginalSizeFirst && supportSendOriginalSize()) {
      _setStatus(TransStatus.TRAN_STATUS_SEND_ORI_SIZE);
    } else {
      _setStatus(TransStatus.TRAN_STATUS_REQUEST);
    }
    _startTransTimeoutTimer();
    _tranProcess();
    return SUCCESS;
  }

  @override
  int processDataTransComplete() {
    if (mDataTransStatus.status != TransStatus.TRAN_STATUS_PACKET) {
      return SUCCESS;
    }
    logger?.i("spp data tran protocol write complete");
    if (mDataTransStatus.isWaitNoticePacket) {
      logger?.i("spp data tran wait notice packet from ble");
      return SUCCESS;
    }
    mDataTransStatus.isPackSending = false;
    _tranProcessFast();
    return SUCCESS;
  }

  @override
  int sppTranDataManualStop() {
    logger?.i("stop by user");
    _setStatus(TransStatus.TRAN_STATUS_IDLE);
    _cleanNoticePacketStatus();
    _stopTransTimeoutTimer();
    _stopLastReceiveTimeoutTimer();
    final request = SppDataTransStop();
    _writeSppDataOut(request);
    return SUCCESS;
  }

  @override
  int sppTranDataStartWithTryTime(int times) {
    mContinueTimes = times;
    return SUCCESS;
  }

  @override
  bool isSppTranStart() {
    return mDataTransStatus.status != TransStatus.TRAN_STATUS_IDLE;
  }

  _setStatus(TransStatus status) {
    logger?.d("_setStatus -> $status");
    mDataTransStatus.status = status;
  }

  //发送常规指令
  void _tranProcess() {
    logger?.d("_tranProcess");
    //c库是会有30毫秒的中断延迟
    _transProcessHandle();
  }

  //发送数据包指令
  void _tranProcessFast() {
    logger?.d("_tranProcessFast");
    _transProcessHandle();
  }

  void _transProcessHandle() {
    logger?.e(
        "_transProcessHandle status: ${mDataTransStatus.status}, isSpp: ${mTransData.isSpp}");
    switch (mDataTransStatus.status) {
      case TransStatus.TRAN_STATUS_IDLE:
        break;
      case TransStatus.TRAN_STATUS_REQUEST:
        _writeRequestCmd(mTransData.type, mTransData.size,
            mTransData.fileName ?? "", mTransData.compressionType);
        break;
      case TransStatus.TRAN_STATUS_PACKET:
        _processWritePacket();
        break;
      case TransStatus.TRAN_STATUS_END:
        _writeEndCmd(mDataTransStatus.curTranCheckCode);
        break;
      case TransStatus.TRAN_STATUS_PRN:
        _writePrnCmd(mTransData.prn);
        break;
      case TransStatus.TRAN_STATUS_SELECT:
        _writeSelectCmd();
        break;
      case TransStatus.TRAN_STATUS_CONTINUE:
        break;
      case TransStatus.TRAN_STATUS_SEND_ORI_SIZE:
        _writeOriginalSizeCmd(mTransData.type, mTransData.originalSize,
            mTransData.fileName ?? "", mTransData.compressionType);
        break;
      default:
        break;
    }
  }

  int _continueDataTrans() {
    lastReceiveTimeOutTimer?.cancel();
    if (!supportSppDataTransContinue()) {
      logger?.e("err:not support spp data tran continue");
      _stopDataTrans();
      return SUCCESS;
    }
    if (mDataTransStatus.retryCount >= mContinueTimes) {
      logger?.i(
          "warn:spp data tran continue cout(${mDataTransStatus.retryCount}) more than max retry time($mContinueTimes)");
      _stopDataTransAndNotifyStatusOut(
          ERROR_MAX_TIME, DATA_TRAN_ERROR_VALUE_TIMEOUT_ERROR);
      mDataTransStatus.retryCount = 0;
      return SUCCESS;
    }

    mDataTransStatus.retryCount++;
    //重置偏移，去获取固件最新的偏移
    _cleanNoticePacketStatus();
    _setStatus(TransStatus.TRAN_STATUS_SELECT);
    _tranProcess();
    _startTransTimeoutTimer();
    return SUCCESS;
  }

  void _setTransOffset(int offset, int checkCode) {
    mDataTransStatus.curTranOffset = offset;
    mDataTransStatus.curTranCheckCode = checkCode;
  }

  int _processWritePacket() {
    if (supportSppDataTransContinue()) {
      if (mDataTransStatus.status != TransStatus.TRAN_STATUS_PACKET) {
        return SUCCESS;
      }
    }
    //如果m_tran_status.m_prn != 0,并prn已经发送完成 需要等待应打包
    if (mTransData.prn != 0 && mDataTransStatus.isWaitNoticePacket) {
      logger?.d("m_tran_status.m_prn != 0,并prn已经发送完成 需要等待应打包");
      return SUCCESS;
    }
    //判断传输是否结束
    if (isTransEnd()) {
      logger?.i("spp trans complete, last check");
      logger?.i(
          "end spp send data offset:${mDataTransStatus.curTranOffset + mDataTransStatus.noticePacketSize} "
          "packet count:${mDataTransStatus.noticePacketCount} last packet data length:${mDataTransStatus.noticePacketSize}");
      //传输完成
      int checkResult = _checkCodeOptimized(mTransData.filePath ?? "",
          mDataTransStatus.curTranOffset, mTransData.size);
      if (checkResult != SUCCESS) {
        logger?.e("err:get cal check code fail,stop tran $checkResult");
        _stopDataTransAndNotifyStatusOut(ERROR_INVALID_STATE, 0);
        return SUCCESS;
      }
      _noticePacketCompleted(); //包发送接收,通知包直接成功
      _sendTransComplete();
      return SUCCESS;
    }

    //传文件内容
    int curOffset =
        mDataTransStatus.curTranOffset + mDataTransStatus.noticePacketSize;
    int mtu = txMtu;
    int maxSendMtu = SPP_MAX_MTU;
    if (mtu > maxSendMtu) {
      mtu = maxSendMtu - 3;
    } else {
      mtu -= 3;
    }
    //一包的数据大小
    int readLength =
        (mTransData.size - curOffset > mtu) ? mtu : mTransData.size - curOffset;

    mDataTransStatus.isPackSending = true;

    mDataTransStatus.isWaitNoticePacket = false;
    mDataTransStatus.noticePacketCount++;
    mDataTransStatus.noticePacketSize += readLength;

    if (mTransData.prn == 0) {
      //TODO 直接完成？
      logger?.e("prn == 0");
      _noticePacketCompleted();
    } else if (mDataTransStatus.noticePacketCount >= mTransData.prn &&
        mTransData.prn != 0) {
      logger?.i(
          "spp send data offset:${curOffset + readLength} packet count:${mDataTransStatus.noticePacketCount} last packet data length:$readLength");
      mDataTransStatus.isWaitNoticePacket = true;
    }

    //申请当前包缓存大小
    sendData = Uint8List(readLength);
    logger?.i("cur offset:$curOffset");
    _readFileBytesSync(mTransData.filePath ?? "", curOffset, readLength);
    return SUCCESS;
  }

  void _readFileBytesSync(String filePath, int offset, int readLength) {
    debugPrint(
        "read $readLength bytes, offset: $offset, sendData.length: ${sendData?.length}");
    if (filePath.isEmpty ||
        sendData == null ||
        sendData!.isEmpty ||
        readLength == 0) {
      logger?.e(
          "1err: stop read file, file: $filePath, sendData is ${sendData != null ? "not null" : "null"}, length: $readLength");
      _stopDataTransAndNotifyStatusOut(ERROR_INVALID_PARAM, 0);
      return;
    }
    try {
      final file = File(filePath);
      final af = file.openSync();
      af.setPositionSync(offset);
      int read = af.readIntoSync(sendData!, 0, readLength);
      af.closeSync();
      logger?.d("read real size:$read");
      if (sendData == null || sendData!.isEmpty) {
        logger?.e(
            "2err: stop read file, file: $filePath, sendData is ${sendData != null ? "not null" : "null"}, length: $readLength");
        _stopDataTransAndNotifyStatusOut(ERROR_INVALID_PARAM, 0);
      } else {
        //组包
        _writePacket(sendData!);
      }
    } catch (e) {
      logger?.e("err:file read failed: $e");
      _stopDataTransAndNotifyStatusOut(ERROR_FILE_OPERATE_FAILED, 0);
    }
  }

  void _readFileBytes(String filePath, int offset, int readLength) {
    debugPrint(
        "read $readLength bytes, offset: $offset, sendData.length: ${sendData?.length}");
    if (filePath.isEmpty ||
        sendData == null ||
        sendData!.isEmpty ||
        readLength == 0) {
      logger?.e(
          "3err: stop read file, file: $filePath, sendData is ${sendData != null ? "not null" : "null"}, length: $readLength");
      _stopDataTransAndNotifyStatusOut(ERROR_INVALID_PARAM, 0);
      return;
    }
    final file = File(filePath);
    final stream = file.openRead(offset, offset + readLength);
    stream.listen((event) {
      logger?.d("read result: ${event.length}");
      if (event.length != readLength) {
        logger?.e("err:file read failed, read length not equal to required length");
        _stopDataTransAndNotifyStatusOut(ERROR_FILE_OPERATE_FAILED, 0);
      } else {
        if (sendData == null || sendData!.isEmpty) {
          logger?.e(
              "4err: stop read file, file: $filePath, sendData is ${sendData != null ? "not null" : "null"}, length: $readLength");
          _stopDataTransAndNotifyStatusOut(ERROR_INVALID_PARAM, 0);
        } else {
          sendData?.setAll(0, event);
          //组包
          _writePacket(sendData!);
        }
      }
    }, onDone: () {
      debugPrint("read one packet done!");
    }, onError: (e) {
      logger?.e("err:file read failed: $e");
      _stopDataTransAndNotifyStatusOut(ERROR_FILE_OPERATE_FAILED, 0);
    });
  }

  void _writePacket(Uint8List data) {
    final packet = SppDataTransPacket(data);
    packet.errCode = 0;
    _writeSppDataOut(packet);
  }

  ///请求发送文件d2 01
  int _writeRequestCmd(
      int type, int size, String fileName, int compressionType) {
    if (fileName.isEmpty || mTransData.size <= 0) {
      logger?.e(
          "err: write failed, ${fileName.isEmpty ? "file name is empty" : ""}${mTransData.size <= 0 ? "data size is ${mTransData.size}" : ""}");
      return ERROR_INVALID_PARAM;
    }
    final request = SppDataTransRequest(type, size, compressionType, fileName);
    _writeSppDataOut(request);
    return SUCCESS;
  }

  ///文件內容發送完成，发送d2 03
  void _writeEndCmd(int curTranCheckCode) {
    final request = SppDataTransEnd(curTranCheckCode);
    _writeSppDataOut(request);
  }

  ///设置prn
  int _writePrnCmd(int prn) {
    final prnSet = SppDataTransPrnSet(prn);
    _writeSppDataOut(prnSet);
    return SUCCESS;
  }

  int _writeSelectCmd() {
    final request = SppDataTransContinue();
    _writeSppDataOut(request);
    return SUCCESS;
  }

  void _writeOriginalSizeCmd(
      int type, int originalSize, String s, int compressionType) {}

  bool isTransEnd() {
    return mDataTransStatus.curTranOffset + mDataTransStatus.noticePacketSize >=
        mTransData.size;
  }

  int _checkCodeOptimized(String filePath, int startIndex, int endIndex) {
    int len = endIndex - startIndex;
    logger?.i(
        "check code start, startIndex: $startIndex, endIndex: $endIndex, len: $len");
    if (filePath.isEmpty) {
      logger?.e("err:src file path $filePath null");
      return ERROR_NULL;
    }
    final file = File(filePath);
    final af = file.openSync();
    Uint8List buffer = Uint8List(len);
    af.setPositionSync(startIndex);
    af.readIntoSync(buffer, 0, len);
    af.closeSync();
    for (int i = 0; i < len; i++) {
      mDataTransStatus.curTranCheckCode += buffer[i];
    }
    logger?.i("check code end");
    return SUCCESS;
  }

  int _noticePacketCompleted() {
    mDataTransStatus.curTranOffset += mDataTransStatus.noticePacketSize;
    _cleanNoticePacketStatus();
    int progress = mTransData.size == 0
        ? 0
        : (mDataTransStatus.curTranOffset * 100) ~/ mTransData.size;
    if (progress != mDataTransStatus.tranProgress) {
      if (progress > 99) {
        progress = 99;
      }
      logger?.i("spp data tran progress:$progress");
      _notifyTransProgressOut(progress);
    }
    mDataTransStatus.tranProgress = progress;
    return SUCCESS;
  }

  void _sendTransComplete() {
    _setStatus(TransStatus.TRAN_STATUS_END);
    _tranProcess();
  }

  ///停止文件传输并通知外部状态
  _stopDataTransAndNotifyStatusOut(int error, int errorValue) {
    _notifyStatusOut(error, errorValue);
    _stopDataTrans();
  }

  ///停止文件传输流程，释放资源
  int _stopDataTrans() {
    _setStatus(TransStatus.TRAN_STATUS_IDLE);
    _cleanNoticePacketStatus();
    _stopTransTimeoutTimer();
    _stopLastReceiveTimeoutTimer();
    // TODO：此处置空会导致重传时报错
    //mTransData.filePath = null;
    sendData = null;
    logger?.i("spp data tran stop");
    return SUCCESS;
  }

  void _cleanNoticePacketStatus() {
    mDataTransStatus.noticePacketSize = 0;
    mDataTransStatus.noticePacketCount = 0;
    mDataTransStatus.isWaitNoticePacket = false;
    mDataTransStatus.isPackSending = false;
  }

  void _cleanDataTransStatus() {
    mDataTransStatus.reset();
  }

  void _sendTimeoutTimerHandler() {
    if (mDataTransStatus.status != TransStatus.TRAN_STATUS_IDLE) {
      if (mDataTransStatus.status == TransStatus.TRAN_STATUS_PACKET &&
          supportSppDataTransContinue()) {
        if (mDataTransStatus.retryCount <= mContinueTimes) {
          _continueDataTrans();
        } else {
          logger?.e(
              "err:spp data tran send time out,retry time more than max,stop trans");
          _stopDataTransAndNotifyStatusOut(
              ERROR_MAX_TIME, DATA_TRAN_ERROR_VALUE_TIMEOUT_ERROR);
          mDataTransStatus.retryCount = 0;
        }
      } else {
        logger?.e("err:spp data tran send time out,stop trans");
        _stopDataTransAndNotifyStatusOut(
            ERROR_TIMEOUT, DATA_TRAN_ERROR_VALUE_TIMEOUT_ERROR);
      }
    }
  }

  void _lastReceiveTimeOutTimerHandler() {
    logger?.e("last recieve timer handle out");
    _stopDataTransAndNotifyStatusOut(ERROR_TIMEOUT, ERROR_TIMEOUT);
  }

  void _stopTransTimeoutTimer() {
    sendTimeOutTimer?.cancel();
  }

  void _startTransTimeoutTimer() {
    sendTimeOutTimer?.cancel();
    sendTimeOutTimer = Timer(
        Duration(
            milliseconds: supportSppDataTransContinue()
                ? DATA_CONTINUE_TRAN_TIMEOUT
                : DATA_TRAN_TIMEOUT),
        _sendTimeoutTimerHandler);
  }

  void _stopLastReceiveTimeoutTimer() {
    lastReceiveTimeOutTimer?.cancel();
  }

  void _startLastReceiveTimeoutTimer() {
    lastReceiveTimeOutTimer?.cancel();
    lastReceiveTimeOutTimer = Timer(
        const Duration(milliseconds: DATA_TRAN_TIMEOUT),
        _lastReceiveTimeOutTimerHandler);
  }

  ///通知外部

  int _writeSppDataOut(SppCmd request) {
    if (isInOTAMode()) {
      logger?.e("device in ota mode");
      return ERROR_INVALID_STATE;
    }

    if (request.length < 2) {
      return SUCCESS;
    }

    Uint8List sendData = request.sendBytes;
    if (sendData.length == 2 && sendData[0] == 0x02 && sendData[1] == 0x00) {
      logger?.i("忽略空数据包：${toHexString(sendData)}");
      return SUCCESS;
    }
    logger?.i("SPPTX : ${toHexString(sendData)}");
    writeDataToBle(sendData);
    return SUCCESS;
  }

  void _notifyStatusOut(int error, int errorValue) {
    if (completeCallback != null) {
      completeCallback!(error, errorValue);
    }
  }

  void _notifyTransProgressOut(int progress) {
    if (progressCallback != null) {
      progressCallback!(progress);
    }
  }
}
