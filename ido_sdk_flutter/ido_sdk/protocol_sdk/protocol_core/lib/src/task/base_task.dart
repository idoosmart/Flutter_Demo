import '../manager/manager_clib.dart';
import '../manager/response.dart';

/// 状态
enum TaskStatus {
  waiting,
  running,
  finished,
  canceled,
  stopped,
  timeout
}

abstract class BaseTask {

  late final _coreManager = IDOProtocolClibManager();

  /// 创建
  BaseTask.create();

  /// 执行
  Future<CmdResponse> call();

  /// 取消
  cancel();

  /// 状态
  TaskStatus get status;

  IDOProtocolClibManager get coreManager => _coreManager;

}
