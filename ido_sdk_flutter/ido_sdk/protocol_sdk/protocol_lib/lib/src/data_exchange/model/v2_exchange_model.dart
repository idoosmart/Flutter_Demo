
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'v2_exchange_data_model.g.dart';

@JsonSerializable()
class IDOV2ExchangeModel {
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
   List<int>? hrValues = [];

   IDOV2ExchangeModel({
      this.day= 0,
      this.hour= 0,
      this.minute= 0,
      this.second= 0,
      this.sportType= 0,
      this.operate= 0,
      this.targetValue= 0,
      this.targetType= 0,
      this.forceStart= 0,
      this.retCode= 0,
      this.calories= 0,
      this.distance= 0,
      this.durations= 0,
      this.step= 0,
      this.avgHr= 0,
      this.maxHr= 0,
      this.curHr= 0,
      this.hrSerial= 0,
      this.burnFatMins= 0,
      this.aerobicMins= 0,
      this.limitMins= 0,
      this.isSave= false,
      this.status= 0,
      this.interval= 0,
      this.hrValues= const [],
   });


   factory IDOV2ExchangeModel.fromJson(Map<String, dynamic> json) =>
       _$V2ExchangeModelFromJson(json);

   Map<String, dynamic> toJson() => _$V2ExchangeModelToJson(this);

   @override
  String toString() {
     return jsonEncode(toJson());
  }
}

