// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_info_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreenInfoObj _$ScreenInfoObjFromJson(Map<String, dynamic> json) =>
    ScreenInfoObj(
      json['block_size'] as int,
      json['family_name'] as String,
      json['format'] as int,
      json['height'] as int,
      json['sizex100'] as int,
      json['width'] as int,
    );

Map<String, dynamic> _$ScreenInfoObjToJson(ScreenInfoObj instance) =>
    <String, dynamic>{
      'block_size': instance.blockSize,
      'family_name': instance.familyName,
      'format': instance.format,
      'height': instance.height,
      'sizex100': instance.sizex100,
      'width': instance.width,
    };
