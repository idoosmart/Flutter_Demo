/// 加密授权数据模型（对应 C 库 protocol_start_encrypted_auth）
/// Encrypted auth data model (maps to C struct protocol_start_encrypted_auth)
class IDOEncryptedAuthData {
  /// 授权数据（12 字节）
  /// Auth data (12 bytes)
  final List<int> authData;

  /// 加密方式版本（0: 原有，0x10: 新版）
  /// Encryption version (0: legacy, 0x10: new)
  final int encryptedVersion;

  /// 授权数据长度
  /// Auth data length
  final int authLength;

  IDOEncryptedAuthData({
    required this.authData,
    required this.encryptedVersion,
    required this.authLength,
  });

  /// 从 JSON 构造（兼容 C 库的 autu_data 和修正后的 auth_data）
  /// Construct from JSON (compatible with both C-lib's `autu_data` and corrected `auth_data`)
  factory IDOEncryptedAuthData.fromJson(Map<String, dynamic> json) {
    final data = json['auth_data'] ?? json['autu_data'];
    return IDOEncryptedAuthData(
      authData: (data as List).cast<int>(),
      encryptedVersion: json['encrypted_version'] as int,
      authLength: json['auth_length'] as int,
    );
  }

  /// 转换为 JSON（对外使用修正后的 auth_data）
  /// Convert to JSON (uses corrected `auth_data` key for external/cloud usage)
  Map<String, dynamic> toJson() => {
    'auth_data': authData,
    'encrypted_version': encryptedVersion,
    'auth_length': authLength,
  };

  /// 转换为 C 库兼容 JSON（内部使用，保留 autu_data 字段名）
  /// Convert to C-lib compatible JSON (internal use, keeps legacy `autu_data` key)
  Map<String, dynamic> toCLibJson() => {
    'autu_data': authData,
    'encrypted_version': encryptedVersion,
    'auth_length': authLength,
  };
}
