import 'package:json_annotation/json_annotation.dart';

part 'device_trans_item.g.dart';

@JsonSerializable()
class DeviceTransItem {

  /// 文件类型
  /// ```dart
  /// 0x13 语音备忘录文件 .voice
  /// 0x15 acc算法日志文件 .accdata
  /// 0x16 gps算法日志文件 .gpslog
  /// ```
  @JsonKey(name: 'file_type')
  final int? fileType;


  /// 文件大小 单位 字节
  @JsonKey(name: 'file_size')
  final int? fileSize;


  @JsonKey(name: 'file_compression_type')
  final int? fileCompressionType;


  /// 文件名称
  @JsonKey(name: 'file_name')
  final String? fileName;

  /// 接收成功后的文件路径
  @JsonKey(name: 'file_path')
  final String? filePath;

  const DeviceTransItem({
    this.fileType,
    this.fileSize,
    this.fileCompressionType,
    this.fileName,
    this.filePath,
  });

  factory DeviceTransItem.fromJson(Map<String, dynamic> json) =>
      _$DeviceTransItemFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTransItemToJson(this);
}
