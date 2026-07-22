/// 通用指令返回结果
class IDOCommandResult {
  /// 状态码
  final int statusCode;
  /// 错误码
  final int errCode;
  /// 响应的原始数据 JSON Map
  final Map<String, dynamic> rawJson;

  IDOCommandResult({
    required this.statusCode,
    required this.errCode,
    required this.rawJson,
  });

  factory IDOCommandResult.fromJson(Map<String, dynamic> json) {
    return IDOCommandResult(
      statusCode: json['status_code'] as int? ?? (json['notify_switch'] as int? ?? 0),
      errCode: json['err_code'] as int? ?? 0,
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'err_code': errCode,
      ...rawJson,
    };
  }

  @override
  String toString() {
    return 'IDOCommandResult{statusCode: $statusCode, errCode: $errCode, rawJson: $rawJson}';
  }
}
