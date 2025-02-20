import 'dart:typed_data';
import 'dart:convert';

import 'package:protocol_core/src/logger/logger.dart';
import 'package:protocol_core/src/spp/extension/data.dart';
import 'package:protocol_core/src/spp/model/error.dart';

///
/// @author tianwei
/// @date 2024/3/22 16:03
/// @desc SPP指令结构
///

///start-spp基础指令
const PROTOCOL_CMD_BT_GET = 0xB2; //SPP数据
const PROTOCOL_KEY_BT_GET_SPPMTU = 0x01;

///end

///start-spp文件传输指令
const PROTOCOL_CMD_DATA_TRAN_SPP = 0xD2;

const PROTOCOL_KEY_DATA_TRAN_REQUEST = 0x01;
const PROTOCOL_KEY_DATA_TRAN_PACKET = 0x02;
const PROTOCOL_KEY_DATA_TRAN_END = 0x03;
const PROTOCOL_KEY_DATA_TRAN_OFFSET = 0x04;
const PROTOCOL_KEY_DATA_TRAN_PRN_VALUE = 0x05;
const PROTOCOL_KEY_DATA_TRAN_SELECT = 0x06;
const PROTOCOL_KEY_DATA_TRAN_MANUAL_STOP = 0x07;
const PROTOCOL_KEY_DATA_TRAN_SEND_ORIGINAL_SIZE = 0x08;

///end
///
const PROTOCOL_SPP_DATA_LENGTH_BYTES = 2; //两个字节的数据大小（head+数据）
const PROTOCOL_SPP_DATA_HEAD_BYTES = 2; //指令头长度
const PROTOCOL_SPP_DATA_REPLY_ERROR_BYTES = 1; //错误码长度

//SPP指令头固定长度：length+head+error
const PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES = PROTOCOL_SPP_DATA_LENGTH_BYTES +
    PROTOCOL_SPP_DATA_HEAD_BYTES +
    PROTOCOL_SPP_DATA_REPLY_ERROR_BYTES;

///指令头
class ProtocolHead {
  final int cmd;
  final int key;

  ProtocolHead(this.cmd, this.key);
}

class CmdData {
  late Uint8List data;
  late ByteData byteData;

  CmdData(this.data) {
    byteData = ByteData.view(data.buffer);
  }

  CmdData.generate() {
    data = Uint8List(0);
    byteData = ByteData.view(data.buffer);
  }

  refresh(Uint8List data) {
    this.data = data;
    byteData = ByteData.view(this.data.buffer);
  }
}

class SppCmd extends CmdData {
  late int length;
  late ProtocolHead head;

  SppCmd(super.data) {
    length = byteData.getUint16Little(0);
    head = ProtocolHead(byteData.oneByte(PROTOCOL_SPP_DATA_LENGTH_BYTES),
        byteData.oneByte(PROTOCOL_SPP_DATA_LENGTH_BYTES + 1));
  }

  SppCmd.generate(int cmd, int key) : super.generate() {
    head = ProtocolHead(cmd, key);
    length = PROTOCOL_SPP_DATA_HEAD_BYTES;
  }

  String get showCmd => head.cmd.toRadixString(16).padLeft(2, '0');

  String get showKey => head.key.toRadixString(16).padLeft(2, '0');

  Uint8List get original => data;

  Uint8List get lengthBytes => length.twoBytes();

  Uint8List get sendBytes => Uint8List.fromList([...lengthBytes, ...data]);

  @override
  refresh(Uint8List data) {
    super.refresh(Uint8List.fromList(
        [...head.cmd.oneByte(), ...head.key.oneByte(), ...data]));
    length += data.length;
  }

  //获取除大小外的包括head+data的数据
  Uint8List getData() {
    return data.sublist(PROTOCOL_SPP_DATA_LENGTH_BYTES);
  }
}

///spp文件传输请求，d2 01
class SppDataTransRequest extends SppCmd {
  final int type;
  final int size;
  final int compressionType;
  final String fileName;
  int _fileNameByteLength = 0;

  SppDataTransRequest(this.type, this.size, this.compressionType, this.fileName)
      : super.generate(
            PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_REQUEST) {

    //final fileNameBytes = fileName.bytes();
    List<int> fileNameBytes = utf8.encode(fileName);
    _fileNameByteLength = fileNameBytes.length;
    refresh(Uint8List.fromList([
      ...type.oneByte(),
      ...size.fourBytes(),
      ...compressionType.oneByte(),
      ...fileNameBytes
    ]));
  }

  int get fileNameByteLength => _fileNameByteLength;
}

//spp prn设置
class SppDataTransPrnSet extends SppCmd {
  final int num;

  SppDataTransPrnSet(this.num)
      : super.generate(
            PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_PRN_VALUE) {
    refresh(num.oneByte());
  }
}

//spp数据包
class SppDataTransPacket extends SppCmd {
  int errCode = 0;
  final Uint8List bytes; //文件数据
  SppDataTransPacket(this.bytes)
      : super.generate(
            PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_PACKET) {
    refresh(Uint8List.fromList([...errCode.oneByte(), ...bytes]));
  }
}

class SppDataTransEnd extends SppCmd {
  final int checkCode;

  SppDataTransEnd(this.checkCode)
      : super.generate(PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_END) {
    refresh(checkCode.fourBytes());
  }
}

class SppDataTransStop extends SppCmd {
  SppDataTransStop()
      : super.generate(
            PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_MANUAL_STOP){
    refresh(Uint8List.fromList([]));
  }
}

class SppDataTransContinue extends SppCmd {
  SppDataTransContinue()
      : super.generate(
            PROTOCOL_CMD_DATA_TRAN_SPP, PROTOCOL_KEY_DATA_TRAN_SELECT){
    refresh(Uint8List.fromList([]));
  }
}

///↓↓↓固件回复数据↓↓↓/////////////////////////////////////////

class SppCmdReply extends SppCmd {
  late int errCode;
  int _currIndex = 0; //记录当前读取的下标

  SppCmdReply(super.data) {
    errCode = byteData
        .oneByte(PROTOCOL_SPP_DATA_LENGTH_BYTES + PROTOCOL_SPP_DATA_HEAD_BYTES);
  }

  bool get succeed => errCode == SUCCESS;

  ///提供三个频率高的方法
  int get firstOneByte =>
      byteData.oneByte(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES);

  int get firstTwoBytes =>
      byteData.twoBytes(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES);

  int get firstFourBytes =>
      byteData.fourBytes(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES);
}

class SppDataTransRequestReply extends SppCmdReply {

  SppDataTransRequestReply(super.data);
}

///获取sppmtu回复
class SppMtuReply extends SppCmdReply {
  late int mtu;
  late int checkCode;

  SppMtuReply(super.data) {
    mtu = firstFourBytes;
    //TODO 后续优化获取方式 nextFourBytes()
    checkCode = byteData.fourBytes(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES + 4);
  }
}

class SppDataTransPrnSetReply extends SppCmdReply {
  late int getPrn;

  SppDataTransPrnSetReply(super.data) {
    getPrn = firstOneByte;
  }
}

class SppDataTransPacketReply extends SppCmdReply {
  late int checkCode;
  late int offset;

  SppDataTransPacketReply(super.data) {
    checkCode = firstFourBytes;
    //TODO 后续优化获取方式 nextFourBytes()
    offset = byteData.fourBytes(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES + 4);
  }
}

class SppDataTransEndReply extends SppCmdReply {
  SppDataTransEndReply(super.data);
}

class SppDataTransContinueReply extends SppCmdReply {
  late int offset;
  late int checkCode;

  SppDataTransContinueReply(super.data) {
    offset = firstFourBytes;
    //TODO 后续优化获取方式 nextFourBytes()
    checkCode = byteData.fourBytes(PROTOCOL_SPP_DATA_REPLY_FIX_HEAD_BYTES + 4);
  }
}
