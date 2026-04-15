import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class FileTransferDelegate {
  /// 监听当前上传的文件类型
  void listenTransFileTypeChanged(ApiTransType? fileType);

  // /// 单个文件传输进度
  // void fileTransProgressSingle(double progress);
  //
  // /// 单个文件传输状态
  // void fileTransStatusSingle(TransStatusModel status);

  /// 多文件传输类型
  void fileTransStatusMultiple(int index, ApiTransStatus status);

  /// 多文件传输进度
  void fileTransProgressMultiple(int currentIndex, int totalCount,
      double currentProgress, double totalProgress);

  /// 文件传输错误码
  void fileTransErrorCode(
      int index, int errorCode, int errorCodeFromDevice, int finishingTime);

  /// 设备文件->app传输进度
  void deviceToAppTransItem(ApiDeviceTransItem deviceTransItem);

  /// 设备文件->app传输进度
  void deviceToAppTransProgress(double progress);

  /// 设备文件->app传输结果
  ///
  /// isCompleted 传输结果，receiveFilePath 接收后的文件（isCompleted为true时有效）
  void deviceToAppTransStatus(bool isCompleted, String? receiveFilePath);
}

@FlutterApi()
abstract class FileTransfer {
  /// 是否在执行传输
  bool isTransmitting();

  /// 当前传输中的文件类型
  ApiTransType? transFileType();

  // /// 执行文件传输 (单文件）
  // @async
  // bool transferSingle(BaseFile fileItem, bool cancelPrevTranTask);

  /// 执行文件传输（批量）
  @async
  List<bool> transferMultiple(
      List<BaseFile> fileItems, bool cancelPrevTranTask, CancelTransferToken? cancelToken);


  void cancelTransfer(CancelTransferToken cancelToken);

  /// 获取压缩前.iwf文件大小
  @async
  int iwfFileSize(String filePath, int type);

  /// 注册 设备文件->app传输 (仅最后一次注册有效）
  ///
  /// ```dart
  /// taskFunc 接收到的文件任务
  /// ```
  void registerDeviceTranFileToApp();

  /// 取消设备文件->app传输 注册
  void unregisterDeviceTranFileToApp();

  /// 允许接收文件
  @async
  bool acceptReceiveFile();

  /// 拒绝接收文件
  @async
  bool rejectReceiveFile();

  /// APP主动停止设备传输文件到APP
  @async
  bool stopReceiveFile();
}


/// 传输文件类型
enum ApiTransType {
  /// 固件升级
  fw,

  /// 图片资源升级
  fzbin,

  /// 字库升级
  bin,

  /// 语言包升级
  lang,

  /// BT升级
  bt,

  /// 表盘
  iwf_lz,

  /// 表盘 思澈
  watch,

  /// 壁纸表盘
  wallpaper_z,

  /// 通讯录文件
  ml,

  /// agps 在线
  online_ubx,

  /// agps 线下
  offline_ubx,

  /// 音乐（使用 MusicFileModel）
  mp3,

  /// 消息图标 （使用 MessageFileModel）
  msg,

  /// 运动图标 - 单个（使用SportFileModel）
  sport,

  /// 运动图标 - 动画（使用SportFileModel）
  sports,

  /// epo升级
  epo,

  /// gps
  gps,

  bpbin,

  /// alexa 语音
  voice,

  /// 提示音
  ton,

  /// 小程序
  app(),

  /// 其它类型：不限后缀，不对文件二次加工，直接上传到设备
  /// ```
  /// hid: 检测引导程序hid更新(android专用)
  /// xx: xxxxx
  /// ```
  other();
}

enum ApiTransStatus {
  none,

  /// 无效类型
  invalid,

  /// 文件不存在
  notExists,

  /// 存在传输任务
  busy,

  /// 配置
  config,

  /// 传输前操作
  beforeOpt,

  /// 传输中
  trans,

  /// 传输完成
  finished,

  /// 快速配置中，不支持文件传输
  onFastSynchronizing,

  /// 传输失败
  error,
}

class BaseFile {
  /// 文件类型
  ApiTransType? fileType;

  /// 文件绝对地址
  String? filePath;

  /// 文件名
  String? fileName;

  /// 文件大小
  int? fileSize;

  /// 原始文件大小（压缩前）,暂时只用于表盘
  int? originalFileSize;

  // -------------- 消息图标 --------------
  /// 事件类型
  /// 参考 通消息通知
  /// ```dart
  /// 0x01：短信
  /// 0x02：邮件
  /// 0x03：微信
  /// 0x04：QQ
  /// 0x05：新浪微博
  /// 0x06：facebook
  /// 0x07：twitter
  /// 0x08：WhatsApp
  /// 0x09：Messenger
  /// 0x0A：Instagram
  /// 0x0B：Linked in
  /// 0x0C：日历
  /// 0x0D：skype；
  /// 0x0E：闹钟
  /// 0x0F：pokeman
  /// 0x10：VKontakte
  /// 0x11：Line
  /// 0x12：Viber
  /// 0x13：KakaoTalk
  /// 0x14：Gmail
  /// 0x15：Outlook,
  /// 0x16：Snapchat
  /// 0x17：TELEGRAM
  /// 0x18：other
  /// 0x20：chatwork
  /// 0x21：slack
  /// 0x22：Yahoo Mail
  /// 0x23：Tumblr,
  /// 0x24：Youtube
  /// 0x25：Yahoo Pinterest
  /// 0x26：TikTok
  /// 0x27：Redbus
  /// 0x28：Dailyhunt
  /// 0x29：Hotstar
  /// 0x2A：Inshorts
  /// 0x2B：Paytm
  /// 0x2C：Amazon
  /// 0x2D：Flipkart
  /// 0x2E：Prime
  /// 0x2F：Netflix
  /// 0x30：Gpay
  /// 0x31：Phonpe
  /// 0x32：Swiggy
  /// 0x33：Zomato
  /// 0x34：Make My trip
  /// 0x35：Jio Tv
  /// 0x36：keep
  /// 0x37：Microsoft
  /// 0x38：WhatsApp Business
  /// 0x39：niosefit
  /// 0x3A：missed_calls未接来电
  /// 0x3B：Gpap
  /// 0x3C：YTmusic
  /// 0x3D：Uber
  /// 0x3E：Ola
  /// 0x3F：事项提醒
  /// 0x40：Google meet
  /// ```
  int? evtType;

  /// 应用包名
  String? packName;

  // -------------- 音乐 --------------
  /// 音乐id
  int? musicId;

  /// 歌手名
  String? singerName;

  /// 使用SPP传输
  bool? useSpp;

  // -------------- 运动 --------------
  /// 运动模式
  int? sportType;

  /// 图标类型 1:单张小运动图片 2:单张大运动图片 3:多运动动画图片 4:单张中运动图片 5:运动最小图标
  int? iconType;

  /// 运动图标 - 动画
  bool? isSports;
}

class CancelTransferToken {
  String? token;
}

class ApiDeviceTransItem {

  /// 文件类型
  /// ```dart
  /// 0x13 语音备忘录文件 .voice
  /// 0x15 acc算法日志文件 .accdata
  /// 0x16 gps算法日志文件 .gpslog
  /// ```
  int? fileType;


  /// 文件大小 单位 字节
  int? fileSize;


  int? fileCompressionType;


  /// 文件名称
  String? fileName;

  /// 接收成功后的文件路径
  String? filePath;

}

