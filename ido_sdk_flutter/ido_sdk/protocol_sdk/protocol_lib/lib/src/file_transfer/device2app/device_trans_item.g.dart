// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_trans_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTransItem _$DeviceTransItemFromJson(Map<String, dynamic> json) =>
    DeviceTransItem(
      fileType: json['file_type'] as int?,
      fileSize: json['file_size'] as int?,
      fileCompressionType: json['file_compression_type'] as int?,
      fileName: json['file_name'] as String?,
      filePath: json['file_path'] as String?,
    );

Map<String, dynamic> _$DeviceTransItemToJson(DeviceTransItem instance) =>
    <String, dynamic>{
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'file_compression_type': instance.fileCompressionType,
      'file_name': instance.fileName,
      'file_path': instance.filePath,
    };
