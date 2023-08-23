import 'package:json_annotation/json_annotation.dart';

part 'tran_config_reply.g.dart';

/// 传输配置信息
@JsonSerializable()
class TranConfigReply {

  /// 错误码 0是正常，非0是错误
  @JsonKey(name: 'err_code')
  final int? errCode;

  ///
  final int? type;
  @JsonKey(name: 'evt_type')
  final int? evtType;
  @JsonKey(name: 'sport_type')
  final int? sportType;
  @JsonKey(name: 'icon_width')
  final int? iconWidth;
  @JsonKey(name: 'icon_height')
  final int? iconHeight;
  final int? format;
  @JsonKey(name: 'block_size')
  final int? blockSize;
  @JsonKey(name: 'big_sports_num')
  final int? bigSportsNum;
  @JsonKey(name: 'msg_num')
  final int? msgNum;
  @JsonKey(name: 'small_sports_and_animation_num')
  final int? smallSportsAndAnimationNum;
  @JsonKey(name: 'medium_num')
  final int? mediumNum;

  TranConfigReply({
    this.errCode,
    this.type,
    this.evtType,
    this.sportType,
    this.iconWidth,
    this.iconHeight,
    this.format,
    this.blockSize,
    this.bigSportsNum,
    this.msgNum,
    this.smallSportsAndAnimationNum,
    this.mediumNum,
  });

  factory TranConfigReply.fromJson(Map<String, dynamic> json) =>
      _$TranConfigReplyFromJson(json);

  Map<String, dynamic> toJson() => _$TranConfigReplyToJson(this);
}
