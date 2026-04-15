import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class AlexaAuthDelegate {
  /// Alexa认证需要打开的url和userCode
  void callbackPairCode(String userCode, String verificationUri);

  /// 监听登录状态
  void loginStateChanged(ApiLoginState state);

  /// 监听语音状态
  void voiceStateChanged(ApiVoiceState state);
}

@HostApi()
abstract class AlexaDataSource {
  /// 获取健康数据
  @async
  int getHealthValue(ApiGetValueType valueType);

  /// 获取心率
  @async
  int getHrValue(int dataType, int timeType);

  /// 功能控制
  ///
  /// funType 0 关闭找手机功能
  void functionControl(int funType);
}

@FlutterApi()
abstract class Alexa {
  /// 是否已登录
  bool isLogin();

  /// 获取当前语言
  ApiLanguageType currentLanguage();

  /// 注册alexa
  /// ```dart
  /// clientId Alexa后台生成的ID
  /// writeToFile 写log文件
  /// outputToConsole 打印到控制台
  /// logLevel 日志级别（该值只会在debug模式下有效）
  /// ```
  @async
  void registerAlexa(String clientId);

  /// 网络变更需实时调用此方法(重要!!!)
  void onNetworkChanged(bool hasNetwork);

  /// 切换语言 默认英语
  @async
  bool changeLanguage(ApiLanguageType type);

  /// Alexa CBL授权
  /// ```dart
  /// productId 在alexa后台注册的产品ID
  /// func 回调Alexa认证需要打开的url和userCode
  /// 返回 0 成功，1 失败，2 超时
  /// ```
  @async
  int authorizeRequest(String productId);

  /// 停止登录 (结束当前执行中的相关登录操作)
  void stopLogin();

  /// 退出登录
  void logout();

  // ---------------------- 内部测试使用 ----------------------

  /// 是否支持语音测试
  @async
  bool isSupportAudioTesting();

  /// 测试pcm上传 (内部使用)
  @async
  bool testUploadPCM(String pcmPath);

  void debugTest();
  void refreshToken();
}

enum ApiLoginState {
  /// 登录中
  logging,

  /// 已登录
  logined,

  /// 未登录
  logout,
}

/// Alexa 语音状态 (未启用)
enum ApiVoiceState {
  /// 无状态
  none,

  /// 准备
  ready,

  /// 开始
  starting,

  /// 结束
  finished,
}

/// 国家及语言
enum ApiLanguageType {
  /// 德语
  german,

  /// 英语 澳大利亚
  australia,

  /// 英语 加拿大
  canadaEn,

  /// 英语 英国
  unitedKingdom,

  /// 英语 印度
  india,

  ///英语 美国
  usa,

  /// 西班牙语 西班牙
  spainEs,

  /// 西班牙语 墨西哥
  mexico,

  /// 西班牙语 美国
  spainUs,

  /// 法语 加拿大
  frenchCanada,

  /// 法语 法国
  frenchFrench,

  /// 印地语 印度
  hindiIndia,

  /// 意大利语
  italianItaly,

  /// 日语
  japan,

  /// 葡萄牙语
  portugal
}

/// 健康数据类型
enum ApiGetValueType {
  /// 当天步数
  pedometer,

  /// 当天卡路里
  calorie,

  /// 当天最近一次测量的心率
  heartRate,

  /// 当天血氧
  spO2,

  /// 当天距离（米）
  kilometer,

  /// 当天室内游泳距离（米）
  swimmingDistance,

  /// 当天睡眠得分
  sleepScore,

  /// 当天跑步次数
  runningCount,

  /// 当天游泳次数
  swimmingCount,

  /// 当天运动次数
  dayWorkoutCount,

  /// 当周运动次数
  weekWorkoutCount,

  /// 身体电量
  bodyBattery,
}
