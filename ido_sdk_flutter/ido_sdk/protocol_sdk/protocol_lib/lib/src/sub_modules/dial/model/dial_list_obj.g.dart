// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_list_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialListObj _$DialListObjFromJson(Map<String, dynamic> json) => DialListObj(
      (json['items'] as List<dynamic>?)
          ?.map((e) => FaceListItems.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['numRows'] as int,
      json['totalPages'] as int,
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$DialListObjToJson(DialListObj instance) =>
    <String, dynamic>{
      'items': instance.faceListItems,
      'numRows': instance.numRows,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

FaceListItems _$FaceListItemsFromJson(Map<String, dynamic> json) =>
    FaceListItems(
      json['id'] as int,
      json['faceId'] as int?,
      json['name'] as String,
      json['faceTypeName'] as String?,
      json['description'] as String?,
      json['linkUrl'] as String?,
      json['size'] as String?,
      json['imageUrl'] as String,
      json['md5'] as String?,
      json['sha256'] as String?,
      json['sha512'] as String?,
      json['sha128'] as String?,
      json['otaFaceName'] as String,
      json['faceType'] as String,
      json['sid'] as String?,
      json['customFaceType'] as String?,
    );

Map<String, dynamic> _$FaceListItemsToJson(FaceListItems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'faceId': instance.faceId,
      'name': instance.name,
      'faceTypeName': instance.faceTypeName,
      'description': instance.description,
      'linkUrl': instance.linkUrl,
      'size': instance.size,
      'imageUrl': instance.imageUrl,
      'md5': instance.md5,
      'sha256': instance.sha256,
      'sha512': instance.sha512,
      'sha128': instance.sha128,
      'otaFaceName': instance.otaFaceName,
      'faceType': instance.faceType,
      'sid': instance.sid,
      'customFaceType': instance.customFaceType,
    };
