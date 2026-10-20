// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_dail_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchDailInfo _$WatchDailInfoFromJson(Map<String, dynamic> json) =>
    WatchDailInfo(
      blockSize: (json['block_size'] as num?)?.toInt(),
      familyName: json['family_name'] as String?,
      format: (json['format'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      sizex100: (json['sizex100'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatchDailInfoToJson(WatchDailInfo instance) =>
    <String, dynamic>{
      'block_size': instance.blockSize,
      'family_name': instance.familyName,
      'format': instance.format,
      'height': instance.height,
      'sizex100': instance.sizex100,
      'width': instance.width,
    };
