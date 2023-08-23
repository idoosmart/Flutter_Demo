// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairCode _$PairCodeFromJson(Map<String, dynamic> json) => PairCode(
      userCode: json['user_code'] as String?,
      deviceCode: json['device_code'] as String?,
      verificationUri: json['verification_uri'] as String?,
      expiresIn: json['expires_in'] as int?,
      interval: json['interval'] as int?,
    );

Map<String, dynamic> _$PairCodeToJson(PairCode instance) => <String, dynamic>{
      'user_code': instance.userCode,
      'device_code': instance.deviceCode,
      'verification_uri': instance.verificationUri,
      'expires_in': instance.expiresIn,
      'interval': instance.interval,
    };
