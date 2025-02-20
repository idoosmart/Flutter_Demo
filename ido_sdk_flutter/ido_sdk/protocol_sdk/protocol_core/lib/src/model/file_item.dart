
/// 传输文件压缩类型
enum FileTranCompressionType {
  /// 不压缩
  none,

  /// zlib 压缩
  zlib,

  ///fastlz 压缩
  fastlz
}

/// 传输文件类型
enum FileTranDataType {
  ///
  unknown,

  /// AGPS
  agps,

  /// gps固件
  gps_fw,

  /// 表盘
  dial,

  /// 字库
  word,

  /// 图片文件
  photo,

  /// alexa 语音
  voice_alexa,

  /// 固件
  fw
}

/// 文件传输优先级（默认 normal)
enum FileTranPriority { normal, high, veryHigh }


/// 传输文件项
class FileTranItem {
  /// 文件绝对地址
  final String filePath;

  /// 文件名 （文件名+后缀 xx.yy）
  final String fileName;

  /// 文件类型
  final FileTranDataType dataType;

  /// 压缩类型
  FileTranCompressionType compressionType;

  /// 文件传输优先级
  final FileTranPriority tranPriority;

  /// 压缩前文件大小（部分设备表盘使用）
  int? originalFileSize;

  /// 文件大小
  int fileSize;

  /// 索引 (内部使用）
  int? index;

  /// 使用spp传输
  bool useSpp = false;

  /// 设备macAddress
  String? macAddress;

  /// 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6, 30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
  /// 60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤, 80:5340, 90: 炬芯, 97: 恒玄, 98: 思澈1, 99: 思澈2
  int? platform;

  FileTranItem({
    required this.filePath,
    required this.fileName,
    required this.dataType,
    this.compressionType = FileTranCompressionType.none,
    this.tranPriority = FileTranPriority.normal,
    this.fileSize = 0,
    this.originalFileSize = 0,
    this.macAddress,
    this.platform,
  });
}