part of 'spp_trans_manager.dart';

///
/// @author tianwei
/// @date 2024/3/22 11:00
/// @desc spp文件传输管理
///

class SppTransManagerImp extends BaseSppProcessor
    with SppCmdProcessor, SppTransProcessor
    implements SppTransManager {
  SppTransManagerImp._();

  static final _instance = SppTransManagerImp._();

  factory SppTransManagerImp() => _instance;

  static const ADHESIVE_PACKET_MAX_NUM = 5;

  @override
  bool initSpp() {
    initProcessor();
    return true;
  }

  @override
  void registerCoreBridge(
      {BoolCallback? inOtaMode,
      BoolCallback? supportContinueTrans,
      BleDataWriter? writer}) {
    setProtocolCoreBridge(
        inOtaMode: inOtaMode,
        supportContinueTrans: supportContinueTrans,
        writer: writer);
  }

  @override
  int sppDataTransComplete() {
    return processDataTransComplete();
  }

  //分析spp指令，是否需要漏传给c库
  @override
  bool interceptCmd(Uint8List data) {
    //b2 01 不拦截
    if (data.length < 4 ||
        (data[2] == PROTOCOL_CMD_BT_GET &&
            data[3] == PROTOCOL_KEY_BT_GET_SPPMTU)) {
      logger?.i("this cmd should set to c lib");
      receivedData(data);
      return false;
    }
    //默认拦截所有spp指令
    return true;
  }

  ///@param data: 00 00 00 00 00
  ///                     大小    头
  @override
  bool receivedData(Uint8List data) {
    logger?.i("SPPRX : ${toHexString(data)}");
    //解包，可能存在粘包的情况，要循环解包
    int adhesivePacket = 0;
    int offsetAdd = 0;
    int length = data.length;
    final bytes = ByteData.view(data.buffer);
    int headLength = 0;
    while (length != offsetAdd) {
      headLength = bytes.twoBytes(offsetAdd); //不包含大小两个字节
      logger?.e(
          "length:$length offset_add:$offsetAdd adhesivePacket:$adhesivePacket headLength: $headLength");
      //截取一包数据，包含length+head+data
      if (headLength == 0) {
        logger?.d("warn:spp data head length is 0");
        return true;
      }
      //TODO 解析指令，返回具体的实现类，后边优化
      //TODO 解析指令，返回具体的实现类，后边优化
      //TODO 解析指令，返回具体的实现类，后边优化
      int endIndex = offsetAdd + headLength + 2; //下标+长度（大小+头+数据）
      final cmd = SppCmd(data.sublist(
          offsetAdd, endIndex >= data.length ? data.length : endIndex));
      processReceivedSppCmd(cmd);
      //offsetAdd包括两个大小字节，所以此处+2
      offsetAdd += headLength + 2;
      adhesivePacket++;
      if (adhesivePacket >= ADHESIVE_PACKET_MAX_NUM) {
        //超过粘包限制
        logger?.d(
            "warn:spp data adhesive packet more than limit($ADHESIVE_PACKET_MAX_NUM)");
        return true;
      }
    }
    return true;
  }
}
