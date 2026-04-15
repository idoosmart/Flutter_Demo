import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class Tool {
  /// 图片转换格式 png->bmp
  /// ```dart
  /// inPath 用于转换的png路径(包含文件名及后缀)
  /// outPath 转换完的bmp路径(包含文件名及后缀)
  /// format 转换成bmp的文件格式
  /// 返回 0 成功
  /// ```dart
  int png2Bmp(String inPath, String outPath, int format);

  /// 压缩png图片质量
  /// ```dart
  /// inputFilePath   输入文件路径
  /// outputFilePath 输出文件路径
  /// 返回 0 成功
  /// ```
  int compressToPNG(String inputFilePath, String outputFilePath);

  /// 创建EPO.DAT文件
  /// ```dart
  /// dirPath 存放要制作epo文件的目录
  /// epoFilePath 制作的epo文件存放路径
  /// ```
  @async
  bool makeEpoFile(String dirPath, String epoFilePath);

  /// 设置流数据是否输出开关
  ///
  /// iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
  /// 0 成功
  bool setWriteStreamByte(bool isWrite);

  // ------------------------------ GPS轨迹工具 ------------------------------

  /// gsp运动后优化轨迹,根据运动类型初始化速度阈值，若输入其他运动类型，会导致无运动轨迹
  ///
  /// [motionTypeIn] 运动类型：
  /// ```dart
  /// 1、户外走路 = 52, 走路 = 1, 徒步 = 4, 运动类型设为0
  /// 2、户外跑步 = 48, 跑步 = 2, 运动类型设为1
  /// 3、户外骑行 = 50, 骑行 = 3, 运动型性设为2
  /// ```dart
  int gpsInitType(int motionTypeIn);

  /// gps数据实时处理入口,需要对输出的数据进行判断，若纬度为-180则为错误值，不应该输出
  /// ```dart
  /// { lon,经度,数据类型double
  ///  lat,纬度,数据类型double
  ///  timestamp,时间戳,数据类型int
  ///  accuracy,定位精度,数据类型double
  ///  gpsaccuracystatus,定位等级，0 = 定位未知, 1 = 定位好, 2 = 定位差,数据类型int }
  /// ```dart
  String gpsAlgProcessRealtime(String json);

  /// 平滑数据，结果保存在数组lat和lon中
  /// ```dart
  /// {lat,纬度数组,长度为len,数据类型double
  ///  lon,经度数组,长度为len,数据类型double len,数据长度}
  /// ```dart
  String gpsSmoothData(String json);

  // ------------------------------ 来电提醒 、消息提醒 ------------------------------
  ///  v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
  /// ```dart
  /// contactText：联系人名称
  /// phoneNumber：号码
  /// 返回 0 成功
  /// ```
  int setV2CallEvt(String contactText,String phoneNumber);

  /// v2发送信息提醒以及信息内容(部分设备实现)
  ///
  /// ```dart
  /// type 信息类型
  /// contactText 通知内容
  /// phoneNumber 号码
  /// dataText 消息内容
  /// 返回 0 成功
  /// ```
  int setV2NoticeEvt(int type,String contactText,String phoneNumber,String dataText);

  /// v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
  ///
  /// 返回 0 成功
  int stopV2CallEvt();

  /// v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
  ///
  /// 返回 0 成功
  int missedV2MissedCallEvt();

  /// 记录原生层log
  void logNative(String msg);

  /// 获取版本号
  VersionInfo? getSDKVersionInfo();

  /// 获取mp3音频采样率
  /// ```dart
  /// mp3FilePath 输入带路径MP3文件名
  /// return int 输入的MP3文件的采样率如：441000， 异常返回-1
  /// ```
  int mp3SamplingRate(String mp3FilePath);
}

/// 设备信息
class VersionInfo {
  /// 协议库版本号
  String? verMain;

  /// c库版本
  String? verClib;

  /// Alexa库版本
  String? verAlexa;
}

