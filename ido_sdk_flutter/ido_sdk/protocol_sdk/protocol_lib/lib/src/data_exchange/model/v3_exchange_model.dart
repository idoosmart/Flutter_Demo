import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'v3_exchange_data_model.g.dart';

@JsonSerializable()
class IDOV3ExchangeModel {
  /// 训练课程年份
  int? year;
  /// 训练课程月份
  int? month;
  /// 日期
  int? day;
  /// 时
  int? hour;
  /// 分
  int? minute;
  /// 秒
  int? second;
  /// 运动类型
  int? sportType;
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
  List<int>? hrValues = [];
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
  List<int>? kmSpeeds = [];
  /// 英里配速个数
  int? mileCount;
  /// 英里配速集合
  List<int>? mileSpeeds = [];
  /// 步频个数
  int? stepsFrequencyCount;
  /// 步频集合
  List<int>? stepsFrequencys = [];
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
  List<Map<String,dynamic>>? actionData = [];
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
  List<int>? paceSpeeds = [];
  /// 实时速度个数
  int? realSpeedCount;
  /// 实时速度数组 传过来的是s 每5s算一次
  List<int>? realSpeeds = [];
  /// gps 坐标点时间间隔
  int? intervalSecond;
  /// gps个数
  int? gpsCount;
  /// gps数据详情集合 [{'latitude':0,'longitude':0}]
  List<Map<String,dynamic>>? gpsData = [];
  /// 分段数据个数
  int? segmentItemNum;
  /// 分段数据总时间 单位秒
  int? segmentTotalTime;
  /// 分段数据总距离 单位米
  int? segmentTotalDistance;
  /// 分段数据总配速 单位秒/百米
  int? segmentTotalPace;
  ///分段数据总平均心率
  int? segmentTotalAvgHr;
  /// 分段数据总步频 单位次/分
  int? segmentTotalAvgStepFrequency;
  /// 区间配速
  /// 高强度间歇配速 单位秒/百米
  int? paceHiit;
  /// 区间配速
  /// 无氧配速
  /// 单位秒/百米
  int? paceAnaerobic;
  /// 区间配速
  /// 乳酸阈配速
  /// 单位秒/百米
  int? paceLacticAcidThreshold;
  /// 区间配速
  /// 马拉松配速
  /// 单位秒/百米
  int? paceMarathon;
  /// 区间配速
  /// 轻松跑配速
  /// 单位秒/百米
  int? paceEasyRun;
  /// 分段数据详情
  /// index ：分段序号
  /// time: 用时 单位秒
  /// distance: 距离 单位米
  /// pace: 配速 单位秒/百米
  /// avg_hr: 平均心率 单位次/分
  /// avg_step_frequency: 平均步频 单位次/分
  List<Map<String, dynamic>>? segmentItems = [];

  IDOV3ExchangeModel({
    this.year= 0,
    this.month= 0,
    this.day= 0,
    this.hour= 0,
    this.minute= 0,
    this.second= 0,
    this.sportType= 0,
    this.planType= 0,
    this.actionType= 0,
    this.version= 0,
    this.operate= 0,
    this.targetValue= 0,
    this.targetType= 0,
    this.forceStart= 0,
    this.retCode= 0,
    this.calories= 0,
    this.distance= 0,
    this.durations= 0,
    this.step= 0,
    this.swimPosture= 0,
    this.status= 0,
    this.signalFlag= 0,
    this.isSave= false,
    this.realTimeSpeed= 0,
    this.realTimePace= 0,
    this.interval= 0,
    this.hrCount= 0,
    this.burnFatMins= 0,
    this.aerobicMins= 0,
    this.limitMins= 0,
    this.hrValues= const [],
    this.warmUpSecond= 0,
    this.anaeroicSecond= 0,
    this.fatBurnSecond= 0,
    this.aerobicSecond= 0,
    this.limitSecond= 0,
    this.avgHr= 0,
    this.maxHr= 0,
    this.curHr= 0,
    this.warmUpValue= 0,
    this.fatBurnValue= 0,
    this.aerobicValue= 0,
    this.limitValue= 0,
    this.anaerobicValue= 0,
    this.avgSpeed= 0,
    this.maxSpeed= 0,
    this.avgStepFrequency= 0,
    this.maxStepFrequency= 0,
    this.avgStepStride= 0,
    this.maxStepStride= 0,
    this.kmSpeed= 0,
    this.fastKmSpeed= 0,
    this.kmSpeedCount= 0,
    this.kmSpeeds = const [],
    this.mileCount= 0,
    this.mileSpeeds= const [],
    this.stepsFrequencyCount= 0,
    this.stepsFrequencys= const [],
    this.trainingEffect= 0,
    this.anaerobicTrainingEffect= 0,
    this.vo2Max= 0,
    this.actionDataCount= 0,
    this.inClassCalories= 0,
    this.completionRate= 0,
    this.hrCompletionRate= 0,
    this.recoverTime= 0,
    this.avgWeekActivityTime= 0,
    this.grade= 0,
    this.actionData= const [],
    this.trainingOffset= 0,
    this.countHour= 0,
    this.countMinute= 0,
    this.countSecond= 0,
    this.time= 0,
    this.lowHeart= 0,
    this.heightHeart= 0,
    this.paceSpeedCount= 0,
    this.paceSpeeds= const [],
    this.realSpeedCount= 0,
    this.realSpeeds= const [],
    this.intervalSecond= 0,
    this.gpsCount= 0,
    this.gpsData = const [],
    this.segmentItemNum = 0,
    this.segmentTotalTime = 0,
    this.segmentTotalDistance = 0,
    this.segmentTotalPace = 0,
    this.segmentTotalAvgHr = 0,
    this.segmentTotalAvgStepFrequency = 0,
    this.paceHiit = 0,
    this.paceAnaerobic = 0,
    this.paceLacticAcidThreshold = 0,
    this.paceMarathon = 0,
    this.paceEasyRun = 0,
    this.segmentItems = const [],
  });

  factory IDOV3ExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$V3ExchangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$V3ExchangeModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}


