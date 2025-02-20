// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_list_v2_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialListV2Obj _$DialListV2ObjFromJson(Map<String, dynamic> json) =>
    DialListV2Obj(
      json['available_count'] as int,
      json['file_max_size'] as int,
      (json['item'] as List<dynamic>?)
          ?.map((e) => DialListV2Items.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['version'] as int,
    );

Map<String, dynamic> _$DialListV2ObjToJson(DialListV2Obj instance) =>
    <String, dynamic>{
      'available_count': instance.availableCount,
      'file_max_size': instance.fileMaxSize,
      'item': instance.dialListV2Items,
      'version': instance.version,
    };

DialListV2Items _$DialListV2ItemsFromJson(Map<String, dynamic> json) =>
    DialListV2Items(
      json['file_name'] as String,
    );

Map<String, dynamic> _$DialListV2ItemsToJson(DialListV2Items instance) =>
    <String, dynamic>{
      'file_name': instance.fileName,
    };
