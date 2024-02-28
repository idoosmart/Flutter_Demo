// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:protocol_ffi/protocol_ffi.dart';

import '../../protocol_core.dart';
import '../manager/manager_clib.dart';

extension IDOProtocolCoreManagerExtTools on IDOProtocolCoreManager {
  /// 设置持久化路径, 用于保存数据(分段同步), 初始化时调用即可，无顺序要求，最后不要加斜杠 /
  int setFilePath({required String filePath}) {
    return IDOProtocolClibManager().cLib.setFilePath(filePath: filePath);
  }

  /// 设置当前绑定状态
  /// 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连
  int setBindMode({required int mode}) {
    return IDOProtocolClibManager().cLib.setBindMode(mode: mode);
  }

  /// 获取当前绑定状态
  /// 0 没有绑定, 1 已经绑定, 2 升级模式
  int getBindMode() {
    return IDOProtocolClibManager().cLib.getBindMode();
  }

  /// 设置运行环境 release / debug
  /// mode 0:debug 1:release
  int setRunMode(int mode) {
    return IDOProtocolClibManager().cLib.setRunMode(mode);
  }

  /// 设置log保存天数
  ///
  /// saveDay 保存日志天数 最少两天
  /// return SUCCESS(0) 成功
  int setSaveLogDay(int saveDay) {
    return IDOProtocolClibManager().cLib.setSaveLogDay(saveDay);
  }

  /// 图片压缩
  /// ```dart
  /// fileName,输入图片路径(包含文件名及后缀)
  /// endName,输出图片后缀名(.sport)
  /// format,图片格式
  /// ```dart
  int makeFileCompression(
      {required String fileName,
      required String endName,
      required int format}) {
    return IDOProtocolClibManager().cLib.makeFileCompression(
        fileName: fileName, endName: endName, format: format);
  }

  /// 制作压缩多张运动图片
  /// ```dart
  /// fileName,输入图片路径(包含文件名及后缀)
  /// endName,输出图片后缀名(.sport)
  /// format,图片格式
  /// picNum 图片数量
  /// ```dart
  int makeSportFileCompression(
      {required String fileName,
      required String endName,
      required int format,
      required int picNum}) {
    return IDOProtocolClibManager().cLib.makeSportFileCompression(
        fileName: fileName, endName: endName, format: format, picNum: picNum);
  }

  /// 制作表盘压缩文件(iwf.lz) 压缩文件会自动添加文件名.lz后缀
  /// ```dart
  /// filePath,素材路径
  /// saveFileName,文件名
  /// format,取模图片的格式
  /// block_size,压缩块大小{1024,4096}
  /// ```dart
  int makeWatchDialFileCompression(
      {required String filePath,
      required String saveFileName,
      required int format,
      required int blockSize}) {
    return IDOProtocolClibManager().cLib.makeWatchDialFileCompression(
        filePath: filePath,
        saveFileName: saveFileName,
        format: format,
        blockSize: blockSize);
  }

  /// 制作(IWF)文件,根据表盘包获取到IWF文件接口
  /// ```dart
  /// filePath 素材路径
  /// saveFileName 文件名(包含文件名后缀)
  /// format 取模图片的格式
  /// ```dart
  int makeWatchDialFile(
      {required String filePath,
      required String saveFileName,
      required int format}) {
    return IDOProtocolClibManager().cLib.makeWatchDialFile(
        filePath: filePath, saveFileName: saveFileName, format: format);
  }

  /// 制作(EPO.DAT)文件
  /// ```dart
  /// filePath 素材路径
  /// saveFileName,输出文件名,一般为EPO.DAT
  /// ```dart
  int makeEpoFile({required String filePath, required String saveFileName}) {
    return IDOProtocolClibManager()
        .cLib
        .makeEpoFile(filePath: filePath, saveFileName: saveFileName);
  }

  /// 制作思澈表盘文件,会在输入路径下生成(.watch)表盘文件
  /// ```dart
  /// filePath 素材文件路径
  /// 返回 0成功 非0失败 -1: 没有控件 -2: json文件加载失败
  /// ```
  int mkSifliDialFile({required String filePath}) {
    return IDOProtocolClibManager().cLib.mkSifliDialFile(filePath: filePath);
  }

  /// 图片转换格式 png->bmp
  /// ```dart
  /// inPath 用于转换的png路径(包含文件名及后缀)
  /// outPath 转换完的bmp路径(包含文件名及后缀)
  /// format 转换成bmp的文件格式
  /// ```dart
  int png2Bmp(
      {required String inPath, required String outPath, required int format}) {
    return IDOProtocolClibManager()
        .cLib
        .png2Bmp(inPath: inPath, outPath: outPath, format: format);
  }

  /// 压缩png图片质量
  /// ```dart
  /// inputFilePath   输入文件路径
  /// outputFilePath 输出文件路径
  /// int 成功 SUCCESS
  /// ```
  int compressToPNG(
      {required String inputFilePath, required String outputFilePath}) {
    return IDOProtocolClibManager().cLib.compressToPNG(
        inputFilePath: inputFilePath, outputFilePath: outputFilePath);
  }

  /// jpg转png
  /// ```dart
  /// inputFilePath   输入文件路径
  /// outputFilePath 输出文件路径
  /// int 0 成功, 1 已经是png，其它失败
  /// ```
  int jpgToPNG(
      {required String inputFilePath, required String outputFilePath}) {
    return IDOProtocolClibManager().cLib.jpgToPNG(
        inputFilePath: inputFilePath, outputFilePath: outputFilePath);
  }

  /// 制作壁纸图片文件
  /// ```dart
  /// file_path 素材路径
  /// save_file_path 输出文件名
  /// format 预留
  /// ```dart
  int makePhotoFile(
      {required String filePath, required String saveFilePath, int? format}) {
    return IDOProtocolClibManager().cLib.makePhotoFile(
        filePath: filePath, saveFilePath: saveFilePath, format: format);
  }

  /// 将功能表输出到json文件
  /// path 输出文件路径(包含文件名及后缀)
  int funcTableOutputOnJsonFile(String filePath) {
    return IDOProtocolClibManager().cLib.funcTableOutputOnJsonFile(filePath);
  }

  ///  制作联系人文件 v2_conta.ml
  /// ```dart jsondata json数据
  /// {
  /// 当前文件保存的年 ：year , month , day , hour , minute , second
  /// 联系人详情个数     ：contact_item_num
  /// 联系人详情            ：items
  /// 联系人详情姓名     ：name
  /// 纤细人详情号码     ：phone
  /// }
  /// return 成功：生成的联系人文件路径(持久化路径目录+v2_conta.ml) 失败：NULL
  /// ```
  String? makeContactFile({required String jsonData}) {
    return IDOProtocolClibManager().cLib.makeContactFile(jsonData: jsonData);
  }

  /// @brief 模拟器回应数据解释，传入key`replyinfo`，输出对应的字节数据
  /// @param json_data 素材JSON数据，对应事件号的`replyinfo`
  /// @param json_data_len 素材JSON数据长度
  /// @param evt 事件号
  /// @return JSON字符串，转换后的字节数据用JSON格式返回
  String? simulatorRespondInfoExec({required String jsonData,required int jsonLen,required int evtType}) {
    return IDOProtocolClibManager().cLib.simulatorRespondInfoExec(json: jsonData,jsonLen: jsonLen,evtType: evtType);
  }

  /// @brief 模拟器收到APP的字节数据，解释成对应的json内容输出
  /// @param data 素材字节数据
  /// @param data_len 字节数据长度
  /// @return 输出json数据字符串
  String? simulatorReceiveBinary2Json({required Uint8List data}) {
    return IDOProtocolClibManager().cLib.simulatorReceiveBinary2Json(data: data);
  }

  /// @brief 计算长包指令的校验码
  /// @param data 素材字节数据
  /// @param data_len 字节数据长度
  /// @return 输出2个字节的CRC校验码
  int getCrc16({required Uint8List data}) {
    return IDOProtocolClibManager().cLib.getCrc16(data: data);
  }

  /// 音频采样率转换完成回
  ///
  /// error_code 0:成功  1:失败,采样率已经是44.1kHZ不需要转换  2:失败,pcm转换失败  3:失败,读取文件失败
  void registerMp3ToMp3Complete(void Function(int errorCode) func) {
    IDOProtocolClibManager().cLib.registerMp3ToMp3Complete(func: func);
  }

  /// 将采样率转化为44.1khz
  /// ```dart
  /// inPath   音频输入文件路径 目录及文件名、文件名后缀
  /// outPath  音频输出文件路径 目录及文件名、文件名后缀
  /// inSize   音频输入文件大小
  /// return   0 成功
  /// ```
  int audioSamplingRateConversion(
      {required String inPath, required outPath, required int fileSize}) {
    return IDOProtocolClibManager().cLib.audioSamplingRateConversion(
        inPath: inPath, outPath: outPath, fileSize: fileSize);
  }

  /// 音频文件格式转换 mp3转pcm
  /// ```dart
  /// inPath   音频输入文件路径 目录及文件名、文件名后缀
  /// outPath  音频输出文件路径 目录及文件名、文件名后缀
  /// return   0 成功
  /// ```
  int audioFormatConversionMp32Pcm({required String inPath, required outPath}) {
    return IDOProtocolClibManager()
        .cLib
        .audioFormatConversionMp32Pcm(inPath: inPath, outPath: outPath);
  }

  /// 获取mp3音频采样率
  /// ```dart
  /// mp3FilePath 输入带路径MP3文件名
  /// return int 输入的MP3文件的采样率
  /// ```
  int audioGetMp3SamplingRate({required String mp3FilePath}) {
    return IDOProtocolClibManager()
        .cLib
        .audioGetMp3SamplingRate(mp3FilePath: mp3FilePath);
  }

  /// pcm音频文件采样率转换
  /// ```dart
  /// configPath 采样率转换配置文件的路径包括文件名
  /// outPath 采样率转换后的目标文件输出路径(包括文件名 .pcm)
  /// sampleRate 采样率大小 默认44100hz
  /// return 0 成功
  /// ```
  int pcmFileSamplingRateConversion(
      {required String configPath, required String outPath}) {
    return IDOProtocolClibManager().cLib.pcmFileSamplingRateConversion(
        configPath: configPath, outPath: outPath);
  }

  ///  v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
  ///
  /// contactText：联系人名称, phoneNumber：号码
  int setV2CallEvt({
    required String contactText,
    required String phoneNumber,
  }) {
    return IDOProtocolClibManager()
        .cLib
        .setV2CallEvt(contactText: contactText, phoneNumber: phoneNumber);
  }

  /// v2发送信息提醒以及信息内容(部分设备实现)
  /// ```dart
  /// @param:type,信息类型
  /// {
  /// TYPE_SMS = 0x01
  /// TYPE_EMAIL = 0x02
  /// TYPE_WX = 0x03
  /// TYPE_QQ = 0x04
  /// TYPE_WEIBO = 0x05
  /// TYPE_FACEBOOK = 0x06
  /// TYPE_TWITTER = 0x07
  /// TYPE_WHATSAPP = 0x08
  /// TYPE_MESSENGER = 0x09
  /// TYPE_INSTAGRAM = 0x0A
  /// TYPE_LINKEDIN = 0x0B
  /// TYPE_CALENDAR = 0x0C
  /// TYPE_SKYPE = 0x0D
  /// TYPE_ALARM = 0x0E
  /// TYPE_VKONTAKTE = 0x10
  /// TYPE_LINE = 0x11
  /// TYPE_VIBER = 0x12
  /// TYPE_KAKAO_TALK = 0x13
  /// TYPE_GMAIL = 0x14
  /// TYPE_OUTLOOK = 0x15
  /// TYPE_SNAPCHAT = 0x16
  /// TYPE_TELEGRAM = 0x17
  /// TYPE_CHATWORK = 0x20
  /// TYPE_SLACK = 0x21
  /// TYPE_TUMBLR = 0x23
  /// TYPE_YOUTUBE = 0x24
  /// TYPE_PINTEREST_YAHOO = 0x25
  /// TYPE_TIKTOK = 0x26
  /// TYPE_REDBUS = 0X27
  /// TYPE_DAILYHUNT= 0X28
  /// TYPE_HOTSTAR = 0X29
  /// TYPE_INSHORTS = 0X2A
  /// TYPE_PAYTM = 0X2B
  /// TYPE_AMAZON = 0X2C
  /// TYPE_FLIPKART = 0X2D
  /// TYPE_PRIME = 0X2E
  /// TYPE_NETFLIX = 0X2F
  /// TYPE_GPAY = 0X30
  /// TYPE_PHONPE = 0X31
  /// TYPE_SWIGGY = 0X32
  /// TYPE_ZOMATO = 0X33
  /// TYPE_MAKEMYTRIP = 0X34
  /// TYPE_JIOTV = 0X35
  /// TYPE_KEEP = 0X36
  /// }
  /// contactText：通知内容, phoneNumber：号码
  /// ```dart
  int setV2NoticeEvt({
    required int type,
    required String contactText,
    required String phoneNumber,
    required String dataText,
  }) {
    return IDOProtocolClibManager().cLib.setV2NoticeEvt(
        type: type,
        contactText: contactText,
        phoneNumber: phoneNumber,
        dataText: dataText);
  }

  /// v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
  int stopV2CallEvt() {
    return IDOProtocolClibManager().cLib.stopV2CallEvt();
  }

  /// v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
  int missedV2MissedCallEvt() {
    return IDOProtocolClibManager().cLib.missedV2MissedCallEvt();
  }

  /// 设置持久化路径, 用于保存功能表数据, 初始化时调用即可，无顺序要求，最后不要加斜杠 /
  /// filePath 持久化目录路径
  /// 返回 SUCCESS(0) 成功
  int setFunctionTableFilePath({required String filePath}) {
    return IDOProtocolClibManager()
        .cLib
        .setFunctionTableFilePath(filePath: filePath);
  }

  /// 获取Clib版本信息
  ///
  /// release_string clib版本号 三位表示release版本 四位表是develop版本
  /// 0 成功
  String? getClibVersion() {
    return IDOProtocolClibManager().cLib.getClibVersion();
  }

  /// 设置流数据是否输出开关
  ///
  /// iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
  /// 0 成功
  int setWriteStreamByte(int isWrite) {
    return IDOProtocolClibManager().cLib.setWriteStreamByte(isWrite);
  }
}
