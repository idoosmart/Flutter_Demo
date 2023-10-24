/// 单个文件传输进度
typedef CallbackFileTransProgressSingle = void Function(double progress);

/// 单个文件传输状态
typedef CallbackFileTransStatusSingle = void Function(FileTransStatus status);

/// 文件传输进度
/// ```dart
/// currentIndex 当前传输的文件索引 (0 ~ totalCount -1)
/// totalCount 要传的文件数 (>= 1)
/// currentProgress 当前文件传输进度 (0 ~ 1.0)
/// totalProgress 总进度 (0 ~ 1.0)
/// ```
typedef CallbackFileTransProgressMultiple = void Function(int currentIndex,
    int totalCount, double currentProgress, double totalProgress);

/// 文件传输状态
/// ```dart
/// index 当前传输的文件索引
/// status 当前传输文件状态
/// ```
typedef CallbackFileTransStatusMultiple = void Function(
    int index, FileTransStatus status);

/// 文件传输错误码
/// ```dart
///
/// index 当前传输的文件索引
/// errorCode c库返回的错误码
/// errorCodeFromDevice 固件返回的错误码, 当errorCode是24、25，该值等于errorCode
/// finishingTime 固件预计整理时长， 当errorCode是24、25的时候 才会返回值, 其它情况都是0
///
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  sdk扩展补充:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
typedef CallbackFileTransErrorCode = void Function(
    int index, int errorCode, int errorCodeFromDevice, int finishingTime);

/// 传输文件类型
enum FileTransType {
  /// 固件升级
  fw({'.fw'}),

  /// 图片资源升级 (不指定后缀即不限后缀)
  fzbin({}),

  /// 字库升级
  bin({'.bin'}),

  /// 语言包升级 (不指定后缀即不限后缀)
  lang({}),

  /// BT升级
  bt({'.bt'}),

  /// 表盘
  iwf_lz({'.zip'}),

  /// 壁纸表盘
  wallpaper_z({'.jpg', '.png', '.bmp'}),

  /// 通讯录文件
  ml({'.json'}),

  /// agps 在线
  online_ubx({'.ubx', '.zip'}),

  /// agps 线下
  offline_ubx({'.ubx', '.zip'}),

  /// 音乐（使用 MusicFileModel）
  mp3({'.mp3'}),

  /// 消息图标 （使用 MessageFileModel）
  msg({'.jpg', '.png'}),

  /// 运动图标 - 单个（使用SportFileModel）
  sport({'.jpg', '.png', '.bmp'}),

  /// 运动图标 - 动画（使用SportFileModel）
  sports({'.jpg', '.png', '.bmp'}),

  /// epo升级
  epo({'.DAT'}),

  /// gps
  gps({'.gps'}),

  bpbin({'.bpbin'}),

  /// alexa 语音
  voice({'.mp3', '.pcm'}),

  /// 提示音
  ton({'.ton'});

  const FileTransType(this.typeNameSet);
  final Set<String> typeNameSet;

  /// 扩展名是否匹配
  bool isContainsExt(String ext) => typeNameSet.isEmpty || typeNameSet.contains(ext);
}

enum FileTransStatus {
  none,

  /// 无效类型
  invalid,

  /// 文件不存在
  notExists,

  /// 存在传输任务
  busy,

  /// 配置
  config,

  /// 传输前操作
  beforeOpt,

  /// 传输中
  trans,

  /// 传输完成
  finished,

  /// 快速配置中，不支持文件传输
  onFastSynchronizing,

  /// 传输失败
  error,
}
