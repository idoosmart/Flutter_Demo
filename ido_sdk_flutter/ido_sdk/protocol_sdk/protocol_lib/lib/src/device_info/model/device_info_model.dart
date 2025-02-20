import 'package:json_annotation/json_annotation.dart';

part 'device_info_model.g.dart';

@JsonSerializable()
class DeviceInfoModel {
  @JsonKey(name: 'batt_status')
  final int? battStatus;
  @JsonKey(name: 'bind_confirm_method')
  final int? bindConfirmMethod;
  @JsonKey(name: 'bind_confirm_timeout')
  final int? bindConfirmTimeout;
  @JsonKey(name: 'bootload_version')
  final int? bootloadVersion;
  @JsonKey(name: 'bt_name')
  dynamic btName;
  @JsonKey(name: 'cloud_clock_dial_version')
  final int? cloudClockDialVersion;
  @JsonKey(name: 'deivce_id')
  final int? deivceId;
  @JsonKey(name: 'dev_type')
  final int? devType;
  final int? energe;
  @JsonKey(name: 'firmware_version')
  int? firmwareVersion;
  final int? mode;
  @JsonKey(name: 'pair_flag')
  final int? pairFlag;
  final int? platform;
  final int? reboot;
  final int? shape;
  @JsonKey(name: 'show_bind_choice_ui')
  final int? showBindChoiceUi;
  @JsonKey(name: 'user_defined_dial_main_version')
  final int? userDefinedDialMainVersion;
  dynamic sn;
  @JsonKey(name: "gps_platform")
  final int? gpsPlatform;

  DeviceInfoModel({
    this.battStatus,
    this.bindConfirmMethod,
    this.bindConfirmTimeout,
    this.bootloadVersion,
    this.btName,
    this.cloudClockDialVersion,
    this.deivceId,
    this.devType,
    this.energe,
    this.firmwareVersion,
    this.mode,
    this.pairFlag,
    this.platform,
    this.reboot,
    this.shape,
    this.showBindChoiceUi,
    this.userDefinedDialMainVersion,
    this.sn,
    this.gpsPlatform
  });

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoModelToJson(this);
}
