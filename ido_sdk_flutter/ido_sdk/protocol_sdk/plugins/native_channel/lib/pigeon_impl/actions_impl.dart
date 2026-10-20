import '../pigeon_generate/actions.g.dart';

typedef BlockActionsChannelLog = void Function(String logMsg);
typedef BlockActionsStateData = void Function(
    ActionsOTAState state, String errorMessage);
typedef BlockActionsProgressData = void Function(
    double progress, String message);

class ActionsChannelImpl extends ApiActionsFlutter {
  late final actionsHost = ApiActionsHost();
  static ActionsChannelImpl? _instance;
  factory ActionsChannelImpl() => _instance ??= ActionsChannelImpl._internal();
  ActionsChannelImpl._internal();

  BlockActionsChannelLog? logBlock;
  BlockActionsStateData? stateBlock;
  BlockActionsProgressData? progressBlock;

  @override
  void log(String logMsg) {
    logBlock?.call(logMsg);
  }

  @override
  void onOTAStateChanged(ActionsOTAState state, String errorMessage) {
    stateBlock?.call(state, errorMessage);
  }

  @override
  void onOTAProgress(double progress, String message) {
    progressBlock?.call(progress, message);
  }
}
