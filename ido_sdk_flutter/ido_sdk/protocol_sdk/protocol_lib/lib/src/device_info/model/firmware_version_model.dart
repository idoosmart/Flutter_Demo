import 'package:json_annotation/json_annotation.dart';

part 'firmware_version_model.g.dart';

@JsonSerializable()
class FirmwareVersionModel {
  @JsonKey(name: 'firmware_version1')
  int? firmwareVersion1;
  @JsonKey(name: 'firmware_version2')
  int? firmwareVersion2;
  @JsonKey(name: 'firmware_version3')
  int? firmwareVersion3;
  @JsonKey(name: 'BT_flag')
  final int? btFlag;
  @JsonKey(name: 'BT_version1')
  final int? btVersion1;
  @JsonKey(name: 'BT_version2')
  final int? btVersion2;
  @JsonKey(name: 'BT_version3')
  final int? btVersion3;
  @JsonKey(name: 'BT_match_version1')
  final int? btMatchVersion1;
  @JsonKey(name: 'BT_match_version2')
  final int? btMatchVersion2;
  @JsonKey(name: 'BT_match_version3')
  final int? btMatchVersion3;

  FirmwareVersionModel({
    this.firmwareVersion1,
    this.firmwareVersion2,
    this.firmwareVersion3,
    this.btFlag,
    this.btVersion1,
    this.btVersion2,
    this.btVersion3,
    this.btMatchVersion1,
    this.btMatchVersion2,
    this.btMatchVersion3,
  });

  factory FirmwareVersionModel.fromJson(Map<String, dynamic> json) =>
      _$FirmwareVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$FirmwareVersionModelToJson(this);
}
