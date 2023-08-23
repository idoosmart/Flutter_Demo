// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tran_config_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranConfigReply _$TranConfigReplyFromJson(Map<String, dynamic> json) =>
    TranConfigReply(
      errCode: json['err_code'] as int?,
      type: json['type'] as int?,
      evtType: json['evt_type'] as int?,
      sportType: json['sport_type'] as int?,
      iconWidth: json['icon_width'] as int?,
      iconHeight: json['icon_height'] as int?,
      format: json['format'] as int?,
      blockSize: json['block_size'] as int?,
      bigSportsNum: json['big_sports_num'] as int?,
      msgNum: json['msg_num'] as int?,
      smallSportsAndAnimationNum:
          json['small_sports_and_animation_num'] as int?,
      mediumNum: json['medium_num'] as int?,
    );

Map<String, dynamic> _$TranConfigReplyToJson(TranConfigReply instance) =>
    <String, dynamic>{
      'err_code': instance.errCode,
      'type': instance.type,
      'evt_type': instance.evtType,
      'sport_type': instance.sportType,
      'icon_width': instance.iconWidth,
      'icon_height': instance.iconHeight,
      'format': instance.format,
      'block_size': instance.blockSize,
      'big_sports_num': instance.bigSportsNum,
      'msg_num': instance.msgNum,
      'small_sports_and_animation_num': instance.smallSportsAndAnimationNum,
      'medium_num': instance.mediumNum,
    };
