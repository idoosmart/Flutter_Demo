// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_detail_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialDetailObj _$DialDetailObjFromJson(Map<String, dynamic> json) =>
    DialDetailObj(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      faceTypeName: json['faceTypeName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      otaFaceName: json['otaFaceName'] as String? ?? '',
      faceType: json['faceType'] as String? ?? '',
      sid: json['sid'] as String? ?? '',
      otaFaceVersion: json['otaFaceVersion'] == null
          ? null
          : OtaFaceVersion.fromJson(
              json['otaFaceVersion'] as Map<String, dynamic>),
      customFaceType: json['customFaceType'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      collected: json['collected'] as bool? ?? false,
    );

Map<String, dynamic> _$DialDetailObjToJson(DialDetailObj instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'faceTypeName': instance.faceTypeName,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'otaFaceName': instance.otaFaceName,
      'faceType': instance.faceType,
      'sid': instance.sid,
      'otaFaceVersion': instance.otaFaceVersion,
      'customFaceType': instance.customFaceType,
      'enabled': instance.enabled,
      'collected': instance.collected,
    };

OtaFaceVersion _$OtaFaceVersionFromJson(Map<String, dynamic> json) =>
    OtaFaceVersion(
      json['id'] as int,
      json['faceId'] as int,
      json['enabled'] as bool,
      json['linkUrl'] as String,
      json['size'] as int?,
      json['md5'] as String?,
      json['sha256'] as String?,
      json['sha512'] as String?,
      json['sha128'] as String?,
      json['supportFaceVersion'] as String,
      json['version'] as String?,
      json['type'] as String?,
      json['otaFace'] as String?,
      json['remark'] as String?,
    );

Map<String, dynamic> _$OtaFaceVersionToJson(OtaFaceVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'faceId': instance.faceId,
      'enabled': instance.enabled,
      'linkUrl': instance.linkUrl,
      'size': instance.size,
      'md5': instance.md5,
      'sha256': instance.sha256,
      'sha512': instance.sha512,
      'sha128': instance.sha128,
      'supportFaceVersion': instance.supportFaceVersion,
      'version': instance.version,
      'type': instance.type,
      'otaFace': instance.otaFace,
      'remark': instance.remark,
    };
