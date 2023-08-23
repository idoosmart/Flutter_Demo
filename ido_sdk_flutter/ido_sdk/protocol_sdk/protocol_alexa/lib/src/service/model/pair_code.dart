import 'package:json_annotation/json_annotation.dart';

part 'pair_code.g.dart';

@JsonSerializable()
class PairCode {
  @JsonKey(name: 'user_code')
  final String? userCode;
  @JsonKey(name: 'device_code')
  final String? deviceCode;
  @JsonKey(name: 'verification_uri')
  final String? verificationUri;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  final int? interval;

  const PairCode({
    this.userCode,
    this.deviceCode,
    this.verificationUri,
    this.expiresIn,
    this.interval,
  });

  factory PairCode.fromJson(Map<String, dynamic> json) =>
      _$PairCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PairCodeToJson(this);
}
