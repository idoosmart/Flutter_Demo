import 'package:alexa_net/alexa_net.dart';

/// Alexa认证需要打开的url和userCode
typedef CallbackPairCode = void Function(
    String userCode, String verificationUri);

/// 登录响应结果
enum LoginResponse {
  successful,
  failed,
  timeout,
}

enum LoginState {
  /// 登录中
  logging,

  /// 已登录
  logined,

  /// 未登录
  logout,
}

/// Alexa 语音状态 (未启用)
enum VoiceState {
  /// 无状态
  none,

  /// 准备
  ready,

  /// 开始
  starting,

  /// 结束
  finished,
}

// 未启用
enum _State {
  none,

  // 请求登录状态
  requestLoginStateSending,

  // 接收设备语音

  /// 开始接入设备语音
  receiveAudioStarted,
  receiveAudioCanceled,

  /// 中断
  receiveAudioInterrupt,

  // 上传到alexa
  uploadAudioToAlexaStarted,
  uploadAudioToAlexaDone,
  uploadAudioToAlexaFailed,

  // 接收alexa回复
  reply_,

  // 上传到设备
  send_,
}

/// 国家及语言
enum AlexaLanguageType {
  /// 德语
  german('de-DE'),

  /// 英语 澳大利亚
  australia('en-AU'),

  /// 英语 加拿大
  canadaEn('en-CA'),

  /// 英语 英国
  unitedKingdom('en-GB'),

  /// 英语 印度
  india('en-IN'),

  ///英语 美国
  usa('en-US'),

  /// 西班牙语 西班牙
  spainEs('es-ES'),

  /// 西班牙语 墨西哥
  mexico('es-MX'),

  /// 西班牙语 美国
  spainUs('es-US'),

  /// 法语 加拿大
  frenchCanada('fr-CA'),

  /// 法语 法国
  frenchFrench('fr-FR'),

  /// 印地语 印度
  hindiIndia('hi-IN'),

  /// 意大利语
  italianItaly('it-IT'),

  /// 日语
  japan('ja-JP'),

  /// 葡萄牙语
  portugal('pt-BR');

  const AlexaLanguageType(this.lan);
  final String lan;
}

/// 健康数据类型
enum AlexaGetValueType {
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

/// 获取心率
enum AlexaHRDataType {
  /// 平均
  avg,

  /// 最大
  max,

  /// 最小
  min,
}

enum AlexaHRTimeType {
  /// 今天
  today,

  /// 上周
  week,

  /// 上个月
  mouth,

  /// 上一年
  year,
}

/// 功能控制
enum AlexaFoundationType {
  /// 关闭找手机功能
  closeFoundPhone,
}
