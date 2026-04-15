import 'package:pigeon/pigeon.dart';

/// 交换数据状态
enum ApiExchangeStatus {
  /// 初始化
  initial,
  /// app发起开始
  appStart,
  /// app发起开始 ble回复
  appStartReply,
  /// app发起结束
  appEnd,
  /// app发起结束 ble回复
  appEndReply,
  /// app发起暂停
  appPause,
  /// app发起暂停 ble回复
  appPauseReply,
  /// app发起恢复
  appRestore,
  /// app发起恢复 ble回复
  appRestoreReply,
  /// app发起交换
  appIng,
  /// app发起交换 ble回复
  appIngReply,
  /// 获取最后运动数据
  getActivity,
  /// 获取最后运动数据 ble回复
  getActivityReply,
  /// 获取一分钟心率
  getHr,
  /// 获取一分钟心率 ble回复
  getHrReply,
  /// 获取活动GPS
  getActivityGps,
  /// 获取活动GPS ble回复
  getActivityGpsReply,
  /// app开始运动计划
  appStartPlan,
  /// app开始运动计划 ble回复
  appStartPlanReply,
  /// app暂停运动计划
  appPausePlan,
  /// app暂停运动计划 ble回复
  appPausePlanReply,
  /// app恢复运动计划
  appRestorePlan,
  /// app恢复运动计划 ble回复
  appRestorePlanReply,
  /// app结束运动计划
  appEndPlan,
  /// app结束运动计划 ble回复
  appEndPlanReply,
  /// app切换动作
  appSwitchAction,
  /// app切换动作 ble回复
  appSwitchActionReply,
  /// app发起的运动 ble发起暂停
  appBlePause,
  /// app发起的运动 ble发起暂停 app回复
  appBlePauseReply,
  /// app发起的运动 ble发起恢复
  appBleRestore,
  /// app发起的运动 ble发起恢复 app回复
  appBleRestoreReply,
  /// app发起的运动 ble发起结束
  appBleEnd,
  /// app发起的运动 ble发起结束 app回复
  appBleEndReply,
  /// ble发起的运动 ble发起开始
  bleStart,
  /// ble发起的运动 ble发起开始 app回复
  bleStartReply,
  /// ble发起的运动 ble发起结束
  bleEnd,
  /// ble发起的运动 ble发起结束 app回复
  bleEndReply,
  /// ble发起的运动 ble发起暂停
  blePause,
  /// ble发起的运动 ble发起暂停 app回复
  blePauseReply,
  /// ble发起的运动 ble发起恢复
  bleRestore,
  /// ble发起的运动 ble发起恢复 app回复
  bleRestoreReply,
  /// ble发起的运动 ble发起交换
  bleIng,
  /// ble发起的运动 ble发起交换 app回复
  bleIngReply,
  /// ble开始运动计划
  bleStartPlan,
  /// ble暂停运动计划
  blePausePlan,
  /// ble恢复运动计划
  bleRestorePlan,
  /// ble结束运动计划
  bleEndPlan,
  /// ble切换动作
  bleSwitchAction,
  /// ble操作运动计划 app回复
  bleOperatePlanReply
}

@HostApi()
abstract class ApiExchangeDataDelegate {

  /// 监听交换数据状态
  void listenExchangeState(ApiExchangeStatus status);

  /// ble发起运动 app监听ble
  /// ExchangeResponse.model
  /// IDOBleStartExchangeModel : ble设备发送交换运动数据开始
  /// IDOBleIngExchangeModel : ble设备交换运动数据过程中
  /// IDOBleEndExchangeModel : ble设备发送交换运动数据结束
  /// IDOBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOBleOperatePlanExchangeModel : ble设备操作运动计划
  ///
  /// app发起运动 ble操作响应
  /// IDOAppBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOAppBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOAppBleEndExchangeModel : ble设备发送交换运动数据结束
  ///
  /// app发起运动 ble响应回复
  /// ExchangeResponse.model
  /// IDOAppStartReplyExchangeModel : app 开始发起运动 ble回复
  /// IDOAppEndReplyExchangeModel : app 发起运动结束 ble回复
  /// IDOAppIngReplyExchangeModel : app 交换运动数据 ble回复
  /// IDOAppPauseReplyExchangeModel : app 交换运动数据暂停 ble回复
  /// IDOAppRestoreReplyExchangeModel : app 交换运动数据恢复 ble回复
  /// IDOAppIngV3ReplyExchangeModel : app v3交换运动数据 ble回复
  /// IDOAppOperatePlanReplyExchangeModel app 操作运动计划 ble回复
  ///
  /// app 获取多运动响应的数据
  /// ExchangeResponse.model
  /// IDOAppActivityDataV3ExchangeModel : 获取多运动数据最后一次数据
  /// IDOAppHrDataExchangeModel : 多运动获取一分钟心率数据
  /// IDOAppGpsDataExchangeModel : 多运动获取一段时间的gps数据
  void listenBleResponse(Object response);

  /// 交换v2数据
  void exchangeV2Data(ApiExchangeV2Model model);

  /// 交换v3数据
  void exchangeV3Data(ApiExchangeV3Model model);

}


@FlutterApi()
abstract class ApiExchangeData {
  /// 获取是否支持v3运动数据交换
  bool supportV3ActivityExchange();

  /// 数据交换状态
  ApiExchangeStatus? status();

  /// app执行数据交换
  /// model
  /// AppStartExchangeModel : app 开始发起运动
  /// AppEndExchangeModel : app 发起运动结束
  /// AppIngExchangeModel : app 交换运动数据
  /// AppPauseExchangeModel : app 交换运动数据暂停
  /// AppRestoreExchangeModel : app 交换运动数据恢复
  /// AppIngV3ExchangeModel : app v3交换运动数据
  /// AppOperatePlanExchangeModel : app 操作运动计划
  void appExec(Object? model);

  /// ble发起运动 ble执行数据交换 app回复
  /// model
  /// StartReplyExchangeModel : ble设备发送交换运动数据开始 app回复
  /// IngReplyExchangeModel : ble设备交换运动数据过程中 app回复
  /// EndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  /// PauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// RestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// OperatePlanReplyExchangeModel : ble设备操作运动计划 app回复
  /// app发起运动 ble执行数据交换 app回复
  /// model
  /// AppBlePauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// AppBleRestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// AppBleEndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  void appReplyExec(Object? model);

  /// 获取多运动数据最后一次数据
  @async
  bool getLastActivityData();

  /// 获取多运动一分钟心率数据
  @async
  bool getActivityHrData();

  /// 获取多运动一段时间的gps数据
  @async
  bool getActivityGpsData();

  // 不显示调用相关实体类， pigeon不会生成对应文件
  void tmpGenEntryModel(
      BleOperatePlanReplyExchangeModel? t0,
      BleOperatePlanExchangeModel? t1,
      ApiExchangeV2Model? t2,
      ApiExchangeV3Model? t3,
      AppStartExchangeModel? t4,
      AppStartReplyExchangeModel? t5,
      AppEndExchangeModel? t6,
      AppIngExchangeModel? t8,
      AppPauseReplyExchangeModel? t9,
      AppRestoreExchangeModel? t10,
      AppRestoreReplyExchangeModel? t11,
      AppIngV3ExchangeModel? t12,
      AppIngV3ReplyExchangeModel? t13,
      AppActivityDataV3ExchangeModel? t14,
      AppBlePauseExchangeModel? t16,
      AppBleRestoreExchangeModel? t18,
      AppBleRestoreReplyExchangeModel? t19,
      AppBleEndExchangeModel? t20,
      AppBleEndReplyExchangeModel? t21,
      BleStartExchangeModel? t22,
      BleIngExchangeModel? t23,
      BleEndExchangeModel? t24,
      BlePauseExchangeModel? t25,
      AppBlePauseReplyExchangeModel? t26,
      AppOperatePlanReplyExchangeModel? t29,
      AppOperatePlanExchangeModel? t30,
      BleRestoreReplyExchangeModel? t31,
      BlePauseReplyExchangeModel? t32,
      BleEndReplyExchangeModel? t33,
      BleIngReplyExchangeModel? t34,
      BleStartReplyExchangeModel? t35,
      BleRestoreExchangeModel? t36,
      AppPauseExchangeModel? t37,
      ApiAppHrDataExchangeModel? t38,
      AppEndReplyExchangeModel? t39,
      AppIngReplyExchangeModel? t40,
      ApiAppGpsDataExchangeModel? t41,
      ) { }
}

class ApiExchangeBaseModel {
  /// 日期
  int? day;

  /// 时
  int? hour;

  /// 分钟
  int? minute;

  /// 秒钟
  int? second;

  /// 运动类型
  int? sportType;
}

class ApiExchangeV2Model {
  ApiExchangeBaseModel? baseModel;

  /// 1:请求app打开gps  2：发起运动请求
  int? operate;

  ///  0: 无目标， 1: 重复次数，单位：次，
  ///  2: 距离,单位：米,  3: 卡路里, 单位：大卡,
  ///  4: 时长,单位：分钟, 5:  步数, 单位：步
  int? targetValue;

  /// 目标数值
  int? targetType;

  /// 是否强制开始 0:不强制,1:强制
  int? forceStart;

  /// 0:成功; 1:设备已经进入运动模式失败;
  /// 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
  int? retCode;

  /// 卡路里 (单位:J)
  int? calories;

  /// 距离 (单位:米)
  int? distance;

  /// 持续时间 (单位:秒钟)
  int? durations;

  /// 步数 (单位:步)
  int? step;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 当前心率
  int? curHr;

  /// 序列号
  int? hrSerial;

  /// 燃烧脂肪时长 (单位：分钟)
  int? burnFatMins;

  /// 有氧时长 (单位：分钟)
  int? aerobicMins;

  /// 极限时长 (单位：分钟)
  int? limitMins;

  /// 是否存储数据
  bool? isSave;

  /// 0:全部有效, 1:距离无效， 2: gps 信号弱
  int? status;

  /// 心率间隔
  int? interval;

  /// 心率数据集合
  List<int?>? hrValues;
}

class ApiExchangeV3Model {
  ApiExchangeBaseModel? baseModel;

  /// 训练课程年份
  int? year;

  /// 训练课程月份
  int? month;

  /// 计划类型：
  ///  1：跑步计划3km , 2：跑步计划5km ,
  ///  3：跑步计划10km , 4：半程马拉松训练（二期）, 5：马拉松训练（二期）
  int? planType;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4快跑；
  ///  5:结束课程运动 （还要等待用户是否有自由运动）;
  ///  6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;

  /// 数据版本
  int? version;

  /// 1:请求app打开gps  2：发起运动请求
  int? operate;

  ///  0: 无目标， 1: 重复次数，单位：次，
  ///  2: 距离,单位：米,  3: 卡路里, 单位：大卡,
  ///  4: 时长,单位：分钟, 5:  步数, 单位：步
  int? targetValue;

  /// 目标数值
  int? targetType;

  /// 是否强制开始 0:不强制,1:强制
  int? forceStart;

  /// 0:成功; 1:设备已经进入运动模式失败;
  /// 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
  int? retCode;

  /// 卡路里 (单位:J)
  int? calories;

  /// 距离 (单位:米)
  int? distance;

  /// 持续时间 (单位:秒钟)
  int? durations;

  /// 步数 (单位:步)
  int? step;

  /// 0: 混合泳; 1: 自由泳; 2: 蛙泳; 3: 仰泳; 4: 蝶泳;
  int? swimPosture;

  /// 手环返回的状态 开始:1,暂停:2, 结束:3,0:无效状态
  int? status;

  /// 信号强弱  0: 表示信号弱， 1: 表示信号强
  int? signalFlag;

  /// 是否存储数据
  bool? isSave;

  /// app计算显示实时速度 单位km/h 100倍 15秒一个记录
  int? realTimeSpeed;

  /// app计算显示实时配速 单位 s
  int? realTimePace;

  /// 心率间隔
  int? interval;

  /// 心率个数
  int? hrCount;

  /// 燃烧脂肪时长 (单位：分钟)
  int? burnFatMins;

  /// 有氧时长 (单位：分钟)
  int? aerobicMins;

  /// 极限时长 (单位：分钟)
  int? limitMins;

  /// 心率数据集合
  List<int?>? hrValues;

  /// 热身锻炼时长(秒钟)
  int? warmUpSecond;

  /// 无氧锻炼时长(秒钟)
  int? anaeroicSecond;

  /// 燃脂锻炼时长(秒钟)
  int? fatBurnSecond;

  /// 有氧锻炼时长(秒钟)
  int? aerobicSecond;

  /// 极限锻炼时长(秒钟)
  int? limitSecond;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 当前心率
  int? curHr;

  /// 热身运动值
  int? warmUpValue;

  /// 脂肪燃烧运动值
  int? fatBurnValue;

  /// 有氧运动值
  int? aerobicValue;

  /// 极限运动值
  int? limitValue;

  /// 无氧运动值
  int? anaerobicValue;

  /// 平均速度 km/h
  int? avgSpeed;

  /// 最大速度 km/h
  int? maxSpeed;

  /// 平均步频
  int? avgStepFrequency;

  /// 最大步频
  int? maxStepFrequency;

  /// 平均步幅
  int? avgStepStride;

  /// 最大步幅
  int? maxStepStride;

  /// 平均公里配速
  int? kmSpeed;

  /// 最快公里配速
  int? fastKmSpeed;

  /// 公里配速个数
  int? kmSpeedCount;

  /// 公里配速集合
  List<int?>? kmSpeeds;

  /// 英里配速个数
  int? mileCount;

  /// 英里配速集合
  List<int?>? mileSpeeds;

  /// 步频个数
  int? stepsFrequencyCount;

  /// 步频集合
  List<int?>? stepsFrequencys;

  /// 训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
  int? trainingEffect;

  /// 无氧训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
  int? anaerobicTrainingEffect;

  /// 最大摄氧量；  单位：毫升/公斤/分钟； 范围  0-80
  int? vo2Max;

  /// 本次动作训练个数
  int? actionDataCount;

  /// 课程内运动热量  单位千卡
  int? inClassCalories;

  /// 动作完成率 0—100
  int? completionRate;

  /// 心率控制率 0—100
  int? hrCompletionRate;

  /// 恢复时长：单位小时(app收到该数据之后，每过一小时需要自减一)
  int? recoverTime;

  /// 上个月平均每周的运动时间 单位分钟
  int? avgWeekActivityTime;

  /// 摄氧量等级  1:低等 2:业余 3:一般 4：平均 5：良好 6：优秀 7：专业
  int? grade;

  ///  动作完成内容
  ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
  ///  heart_con_value : 每个动作心率控制
  ///  time : 动作完成时间 单位秒
  ///  goal_time ：动作目标时间
  List<Map<String, Object>?>? actionData;

  /// 训练的课程日期偏移 从0开始
  int? trainingOffset;

  /// 运动倒计时
  int? countHour;

  /// 运动倒计时分
  int? countMinute;

  /// 运动倒计时秒
  int? countSecond;

  /// 动作目标时间  单位秒
  int? time;

  /// 心率范围低值
  int? lowHeart;

  /// 心率范围高值
  int? heightHeart;

  /// 实时配速个数
  int? paceSpeedCount;

  /// 实时配速数组  传过来的是s 每5s算一次
  List<int?>? paceSpeeds;

  /// 实时速度个数
  int? realSpeedCount;

  /// 实时速度数组 传过来的是s 每5s算一次
  List<int?>? realSpeeds;
}

/// app 开始发起运动
class AppStartExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 目标类型
  int? targetType;

  /// 目标值
  int? targetValue;

  /// 是否强制开始 0:不强制,1:强制
  int? forceStart;

  /// 最大摄氧量 单位 ml/kg/min
  int? vo2max;

  /// 恢复时长：单位小时
  int? recoverTime;

  /// 上个月平均每周的运动时间 单位分钟
  int? avgWeekActivityTime;
}

/// app 开始发起运动 ble回复
class AppStartReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0:成功; 1:设备已经进入运动模式失败;
  /// 2:设备电量低失败;3:手环正在充电
  /// 4:正在使用Alexa 5:通话中
  int? retCode;
}

/// app 发起运动结束
class AppEndExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 持续时长（单位：s）
  int? duration;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 0:不保存，1:保存
  int? isSave;
}

/// app 发起运动结束 ble回复
class AppEndReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0:成功; 1:设备结束失败
  int? errorCode;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 步数 (单位:步)
  int? step;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
  int? limitMins;
}

/// app 交换运动数据
class AppIngExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
  int? status;
}

/// app 交换运动数据 ble回复
class AppIngReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
  int? status;

  /// 步数
  int? step;

  /// 当前心率
  int? currentHr;

  /// 心率间隔 单位s
  int? interval;

  /// 序列号
  int? hrSerial;

  /// 心率值数据
  List<int?>? hrJson;
}

/// app 交换运动数据暂停
class AppPauseExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 暂停时
  int? pauseHour;

  /// 暂停分
  int? pauseMinute;

  /// 暂停秒
  int? pauseSecond;
}

/// app 交换运动数据暂停 ble回复
class AppPauseReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 暂停错误码 0:成功 非0:失败
  int? errCode;
}

/// app 交换运动数据恢复
class AppRestoreExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// app 交换运动数据恢复 ble回复
class AppRestoreReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 暂停错误码 0:成功 非0:失败
  int? errCode;
}

/// app v3交换运动数据
class AppIngV3ExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 协议版本号
  int? version;

  /// 0: 表示信号弱 2: 表示信号强
  int? signal;

  /// app 距离
  int? distance;

  /// app计算显示实时配速，单位km/h，100倍
  int? speed;

  /// 持续时间
  int? duration;

  /// 卡路里
  int? calories;
}

/// app v3交换运动数据 ble回复
class AppIngV3ReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 协议版本号
  int? version;

  /// 心率数据
  int? heartRate;

  /// 距离 单位根据单位设置的单位显示
  int? distance;

  /// 持续时间 秒钟
  int? duration;

  /// 动态卡路里
  int? realTimeCalories;

  /// 实时速度，单位km/h，扩大100倍
  int? realTimeSpeed;

  /// 实时公里配速 单位s/公里
  int? kmSpeed;

  /// 步数
  int? steps;

  /// 主泳姿
  int? swimPosture;

  /// 状态 0：无效 1：开始 2：手动暂停 3：结束 4：自动暂停
  int? status;

  /// 实时的配速，单位秒，5秒使用滑动平均，第5秒使用1-5秒数据，第6秒使用2-6秒数据
  int? realTimeSpeedPace;

  /// 有氧训练效果等级  单位无  范围 0-50 扩大10倍传输
  int? trainingEffect;

  /// 无氧运动训练效果等级 单位无  范围 0-50 扩大10倍传输
  int? anaerobicTrainingEffect;

  /// 动作类型
  /// 1快走
  /// 2慢跑
  /// 3中速跑
  /// 4快跑
  /// 5结束课程运动 （还要等待用户是否有自由运动）
  /// 6课程结束后自由运动（此字段当operate为5起作用）
  /// 运动累积时间=课程内训练时间+课程结束后计时
  int? actionType;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  int? countHour;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  int? countMinute;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  int? countSecond;
}

/// app 获取v3多运动数据
class AppActivityDataV3ExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 年份
  int? year;

  /// 月份
  int? month;

  /// 协议库版本号
  int? version;

  /// 心率间隔 单位分钟
  int? hrInterval;

  /// 步数
  int? step;

  /// 持续时间
  int? durations;

  /// 卡路里
  int? calories;

  /// 距离
  int? distance;

  /// 脂肪燃烧的心率持续时间 单位分钟
  int? burnFatMins;

  /// 有氧运动的持续时间 单位分钟
  int? aerobicMins;

  /// 极限锻炼的持续时间 单位分钟
  int? limitMins;

  /// 热身运动
  int? warmUp;

  /// 脂肪燃烧
  int? fatBurning;

  /// 有氧训练
  int? aerobicExercise;

  /// 无氧训练
  int? anaerobicExercise;

  /// 极限训练
  int? extremeExercise;

  /// 热身运动的累计时长 单位秒
  int? warmUpTime;

  /// 脂肪燃烧的累计时长 单位秒
  int? fatBurningTime;

  /// 有氧运动的累计时长 单位秒
  int? aerobicExerciseTime;

  /// 无氧运动的累计时长 单位秒
  int? anaerobicExerciseTime;

  /// 极限锻炼的累计时长 单位秒
  int? extremeExerciseTime;

  /// 平均速度 单位km/h
  int? avgSpeed;

  /// 最快速度 单位km/h
  int? maxSpeed;

  /// 平均步幅
  int? avgStepStride;

  /// 最大步幅
  int? maxStepStride;

  /// 平均公里配速
  int? kmSpeed;

  /// 最快公里配速
  int? fastKmSpeed;

  /// 平均步频
  int? avgStepFrequency;

  /// 最大步频
  int? maxStepFrequency;

  /// 平均心率
  int? avgHrValue;

  /// 最大心率
  int? maxHrValue;

  /// 恢复时长 单位小时 app收到该数据之后，每过1小时需要自减1
  int? recoverTime;

  /// 最大摄氧量 单位 ml/kg/min
  int? vo2max;

  /// 训练效果 范围： 1.0 - 5.0 （扩大10倍传输）
  int? trainingEffect;

  /// 摄氧量等级 1：低等 2：业余 3：一般 4：平均 5：良好 6：优秀 7：专业
  int? grade;

  /// 步频详情个数
  int? stepsFrequencyCount;

  /// 英里配速个数 最大100
  int? miSpeedCount;

  /// 实时速度个数
  int? realSpeedCount;

  /// 实时配速个数
  int? paceSpeedCount;

  /// 公里配速详情个数 最大100
  int? kmSpeedCount;

  /// 本次动作训练个数
  int? actionDataCount;

  ///课程内运动热量 单位千卡
  int? inClassCalories;

  ///动作完成率 0—100
  int? completionRate;

  ///心率控制率 0—100
  int? hrCompletionRate;

  /// 每公里耗时秒数 配速集合
  List<int?>? kmSpeeds;

  /// 步频集合 单位步/分钟
  List<int?>? stepsFrequency;

  /// 英里配速数组
  List<int?>? itemsMiSpeed;

  /// 实时速度数组 单位km/h
  List<int?>? itemRealSpeed;

  /// 实时配速数组
  List<int?>? paceSpeedItems;

  ///  动作完成内容
  ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
  ///  heart_con_value : 每个动作心率控制
  ///  time : 动作完成时间 单位秒
  ///  goal_time ：动作目标时间
  List<Map<String, Object>?>? actionData;
}

/// app v3 多运动数据数据交换中获取1分钟心率数据
class AppHrDataExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 协议版本号
  int? version;

  /// 心率数据数组长度 最大60
  int? heartRateHistoryLen;

  /// 心率间隔 单位秒
  int? interval;

  /// 心率数据数组 存一分钟的心率数据, 1s存一个
  List<int?>? heartRates;
}

/// app发起运动 ble设备发送交换运动数据暂停
class AppBlePauseExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// app发起运动 ble设备发送交换运动数据暂停 app回复
class AppBlePauseReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;
}

/// app发起运动 ble设备发送交换运动数据恢复
class AppBleRestoreExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// app发起运动 ble设备发送交换运动数据恢复 app回复
class AppBleRestoreReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;
}

/// app发起运动 ble设备发送交换运动数据结束
class AppBleEndExchangeModel {

  ApiExchangeBaseModel? baseModel;

  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
  int? limitMins;

  /// 0:不保存，1:保存
  int? isSave;
}

/// app发起运动 ble设备发送交换运动数据结束 app回复
class AppBleEndReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;

  ///持续时长 单位s
  int? duration;

  ///卡路里 单位大卡
  int? calories;

  ///距离 单位0.01km
  int? distance;
}

/// ble发起运动 ble设备发送交换运动数据开始
class BleStartExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 1：请求app打开gps 2：发起运动请求
  int? operate;
}

/// ble发起的运动 ble设备交换运动数据过程中
class BleIngExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 距离 单位：0.01km
  int? distance;
}

/// ble发起的运动 ble设备发送交换运动数据结束
class BleEndExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// ble发起的运动 ble设备发送交换运动数据暂停
class BlePauseExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// ble发起的运动 ble设备发送交换运动数据恢复
class BleRestoreExchangeModel {
  ApiExchangeBaseModel? baseModel;
}

/// ble发起的运动 ble设备发送交换运动数据开始 app回复
class BleStartReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 1：请求app打开gps 2：发起运动请求
  int? operate;

  /// 0: 成功 非0: 失败
  int? retCode;
}

/// ble发起的运动 ble设备交换运动数据过程中 app回复
class BleIngReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 距离 单位：0.01km
  int? distance;
}

/// ble发起的运动 ble设备发送交换运动数据结束 app回复
class BleEndReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功 非0: 失败
  int? retCode;
}

/// ble发起的运动 ble设备发送交换运动数据暂停 app回复
class BlePauseReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功 非0: 失败
  int? retCode;
}

/// ble发起的运动 ble设备发送交换运动数据恢复 app回复
class BleRestoreReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 0: 成功 非0: 失败
  int? retCode;
}

/// app 操作计划运动
class AppOperatePlanExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 训练的课程日期偏移 从0开始
  int? trainingOffset;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;
}

/// app 操作计划运动 ble回复
class AppOperatePlanReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;

  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;

  /// 0为成功，非0为失败
  int? errorCode;
}

/// ble 操作计划运动
class BleOperatePlanExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;

  /// 0为成功，非0为失败
  int? errorCode;

  /// 训练课程年份
  int? trainingYear;

  /// 训练课程月份
  int? trainingMonth;

  /// 训练课程日期
  int? trainingDay;

  /// 动作目标时间  单位秒
  int? time;

  /// 心率范围低值
  int? lowHeart;

  /// 心率范围高值
  int? heightHeart;
}

/// ble 操作计划运动 app回复
class BleOperatePlanReplyExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;

  /// 0为成功，非0为失败
  int? errorCode;
}

/// app v3 多运动数交换中获取1分钟心率数据
class ApiAppHrDataExchangeModel {
  ApiExchangeBaseModel? baseModel;

  /// 协议版本号
  int? version;

  /// 心率数据数组长度 最大60
  int? heartRateHistoryLen;

  /// 心率间隔 单位秒
  int? interval;

  /// 心率数据数组 存一分钟的心率数据, 1s存一个
  List<int?>? heartRates;
}

/// app v3 多运动数据交换中获取GPS经纬度数据
class ApiAppGpsDataExchangeModel {

  ApiExchangeBaseModel? baseModel;

  /// 协议版本号
  int? version;

  /// 坐标点时间间隔 单位秒
  int? intervalSecond;

  /// 坐标点个数
  int? gpsCount;

  /// gps数据详情集合 [{'latitude':0,'longitude':0}]
  List<Map<String, Object>?>? gpsData;

}
