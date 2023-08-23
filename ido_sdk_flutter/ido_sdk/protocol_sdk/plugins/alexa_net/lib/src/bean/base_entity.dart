import 'package:json_annotation/json_annotation.dart';
part 'base_entity.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

/// 带泛型用这个
@JsonSerializable(genericArgumentFactories: true)
class BaseEntity<T> {
  final int status;
  final String message;
  @JsonKey(disallowNullValue: true)
  final T? result;

  final int? httpCode; // 预留

  bool get isOK => status == 0;

  const BaseEntity(
      {required this.status, required this.result, required this.message, this.httpCode});

  factory BaseEntity.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseEntityFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseEntityToJson(this, toJsonT);

  @override
  String toString() {
    return 'BaseEntity：{status: $status, httpCode:,$httpCode, message: $message, result: $result}';
  }
}
