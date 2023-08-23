// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseEntity<T> _$BaseEntityFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  $checkKeys(
    json,
    disallowNullValues: const ['result'],
  );
  return BaseEntity<T>(
    status: json['status'] as int,
    result: _$nullableGenericFromJson(json['result'], fromJsonT),
    message: json['message'] as String,
    httpCode: json['httpCode'] as int?,
  );
}

Map<String, dynamic> _$BaseEntityToJson<T>(
  BaseEntity<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{
    'status': instance.status,
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('result', _$nullableGenericToJson(instance.result, toJsonT));
  val['httpCode'] = instance.httpCode;
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
