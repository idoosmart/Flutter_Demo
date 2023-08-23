import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  @JsonKey(name: 'error_description')
  final String? errorDescription;
  final String? error;

  const AuthModel(
      {this.accessToken,
      this.refreshToken,
      this.tokenType,
      this.expiresIn,
      this.errorDescription,
      this.error});

  bool get isOK {
    return (accessToken != null &&
        refreshToken != null &&
        tokenType != null &&
        expiresIn != null);
  }

  @override
  String toString() {
    return "AuthModel{"
    "accessToken: $accessToken,"
    "refresh_token: $refreshToken,"
    "tokenType: $tokenType,"
    "expiresIn: $expiresIn,"
    "errorDescription: $errorDescription,"
    "error: $error}";
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
