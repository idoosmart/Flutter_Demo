// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_dial_iwf_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoDialIwfConfig _$PhotoDialIwfConfigFromJson(Map<String, dynamic> json) =>
    PhotoDialIwfConfig(
      version: (json['version'] as num?)?.toInt(),
      clouddialversion: (json['clouddialversion'] as num?)?.toInt(),
      preview: json['preview'] as String?,
      name: json['name'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      compress: json['compress'] as String?,
      item: (json['item'] as List<dynamic>?)
          ?.map((e) => IWFItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      jsonFilePath: json['jsonFilePath'] as String?,
    );

Map<String, dynamic> _$PhotoDialIwfConfigToJson(PhotoDialIwfConfig instance) =>
    <String, dynamic>{
      'version': instance.version,
      'clouddialversion': instance.clouddialversion,
      'preview': instance.preview,
      'name': instance.name,
      'author': instance.author,
      'description': instance.description,
      'compress': instance.compress,
      'item': instance.item,
      'jsonFilePath': instance.jsonFilePath,
    };

IWFItem _$IWFItemFromJson(Map<String, dynamic> json) => IWFItem(
      widget: json['widget'] as String?,
      type: json['type'] as String?,
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      bg: json['bg'] as String?,
      bgcolor: json['bgcolor'] as String?,
    );

Map<String, dynamic> _$IWFItemToJson(IWFItem instance) => <String, dynamic>{
      'widget': instance.widget,
      'type': instance.type,
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'bg': instance.bg,
      'bgcolor': instance.bgcolor,
    };
