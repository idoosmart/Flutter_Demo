// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_photo_log_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialPhotoLogObj _$DialPhotoLogObjFromJson(Map<String, dynamic> json) =>
    DialPhotoLogObj(
      json['id'] as int,
      json['imageUrl'] as String,
      json['linkUrl'] as String,
      json['otaFaceName'] as String,
      json['fileSize'] as int,
    );

Map<String, dynamic> _$DialPhotoLogObjToJson(DialPhotoLogObj instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'linkUrl': instance.linkUrl,
      'otaFaceName': instance.otaFaceName,
      'fileSize': instance.size,
    };
