import '../pigeon_generate/sifli.g.dart';

typedef BlockSifliChannelLog = void Function(String logMsg);
typedef BlockSifliStateData = void Function(OTAUpdateState state, String desc);
typedef BlockSifliProgressData = void Function(double progress, String message);

class SifliChannelImpl extends ApiSifliFlutter {
  late final sifliHost = ApiSifliHost();
  static SifliChannelImpl? _instance;
  factory SifliChannelImpl() => _instance ??= SifliChannelImpl._internal();
  SifliChannelImpl._internal();

  BlockSifliChannelLog? logBlock;
  BlockSifliStateData? stateBlock;
  BlockSifliProgressData? progressBlock;

  @override
  void log(String logMsg) {
    logBlock?.call(logMsg);
  }

  @override
  bool updateManageState(OTAUpdateState state, String desc) {
    stateBlock?.call(state, desc);
    return true;
  }

  @override
  bool updateManagerProgress(double progress, String message) {
    progressBlock?.call(progress, message);
    return true;
  }
}
