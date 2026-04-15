import '../pigeon_generate/nordic.g.dart';

typedef BlockNordicChannelLog = void Function(String logMsg);
typedef BlockNordicStateData = void Function(
    NordicDFUState state, String errorMessage);
typedef BlockNordicProgressData = void Function(double progress, String speed);

class NordicChannelImpl extends ApiNordicFlutter {
  late final nordicHost = ApiNordicHost();
  static NordicChannelImpl? _instance;
  factory NordicChannelImpl() => _instance ??= NordicChannelImpl._internal();
  NordicChannelImpl._internal();

  BlockNordicChannelLog? logBlock;
  BlockNordicStateData? stateBlock;
  BlockNordicProgressData? progressBlock;

  @override
  void log(String logMsg) {
    logBlock?.call(logMsg);
  }

  @override
  void onDFUStateChanged(NordicDFUState state, String errorMessage) {
    stateBlock?.call(state, errorMessage);
  }

  @override
  void onDFUProgress(double progress, String speed) {
    progressBlock?.call(progress, speed);
  }
}
