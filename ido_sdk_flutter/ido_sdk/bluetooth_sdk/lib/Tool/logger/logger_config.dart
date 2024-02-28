import 'package:logger/logger.dart';

/*
verbose：最详细的日志等级，通常用于记录所有细节信息，包括调试信息、状态信息、事件信息等。
         这个等级的日志可能会非常冗长，但可以帮助开发人员了解系统的运行情况和调试问题。
debug：用于记录调试信息，通常包括变量值、函数调用、代码路径等。这个等级的日志通常用于调试应用程序，以解决代码问题。
info：用于记录一般信息，通常包括重要事件、状态变化、用户操作等。这个等级的日志可以帮助管理员了解系统的运行情况和用户行为。
warning：用于记录警告信息，通常表示一些潜在的问题或异常情况。这个等级的日志可以帮助管理员识别可能的问题并采取相应措施。
error：用于记录错误信息，通常表示系统发生了错误，无法继续执行。这个等级的日志可以帮助管理员快速识别问题并采取恢复措施。
wtf：用于记录非常严重的错误信息，通常表示系统发生了无法预料的异常情况，可能会导致严重后果。这个等级的日志通常用于记录系统崩溃、安全漏洞等问题。
nothing：表示不记录任何日志信息，通常用于关闭日志记录功能，或在某些情况下不需要记录日志信息。*/
/// 日志等级
enum LoggerLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
  nothing,
}

enum LoggerModule { any, ffi, core, lib, alexa }

/// 日志配置
class LoggerConfig {
  /// 存放日志文件的目录绝对路径
  final String dirPath;

  /// 写文件
  final bool writeToFile;

  /// 控制台打印
  final bool outputToConsole;

  /// 单文件最大空间占用 （单位 字节)
  final int maximumFileSize;

  /// 滚动周期（单位 秒）(暂未启用）
  final int rollingFrequency;

  /// 最大文件个数
  final int maximumNumberOfLogFiles;

  /// 带分组样式
  final bool noBoxingByDefault;

  final LoggerLevel level;

  final LoggerModule module;

  bool get isEnable => writeToFile || outputToConsole;

  LoggerConfig({
    required this.dirPath,
    required this.writeToFile,
    required this.outputToConsole,
    this.maximumFileSize = 2 * 1024 * 1024,
    this.rollingFrequency = 24 * 60 * 60,
    this.maximumNumberOfLogFiles = 4,
    this.noBoxingByDefault = true,
    this.level = LoggerLevel.info,
    this.module = LoggerModule.any,
  });
}
