// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tran_config_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranConfigReply _$TranConfigReplyFromJson(Map<String, dynamic> json) =>
    TranConfigReply(
      errCode: (json['err_code'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      evtType: (json['evt_type'] as num?)?.toInt(),
      sportType: (json['sport_type'] as num?)?.toInt(),
      iconWidth: (json['icon_width'] as num?)?.toInt(),
      iconHeight: (json['icon_height'] as num?)?.toInt(),
      format: (json['format'] as num?)?.toInt(),
      blockSize: (json['block_size'] as num?)?.toInt(),
      bigSportsNum: (json['big_sports_num'] as num?)?.toInt(),
      msgNum: (json['msg_num'] as num?)?.toInt(),
      smallSportsAndAnimationNum:
          (json['small_sports_and_animation_num'] as num?)?.toInt(),
      mediumNum: (json['medium_num'] as num?)?.toInt(),
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
