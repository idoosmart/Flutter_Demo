
import '../manager/manager_clib.dart';
import '../manager/response.dart';
import '../spp/spp_trans_manager.dart';

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

  late final _sppTransManager = SppTransManager();

  /// 创建
  BaseTask.create();

  /// 执行
  Future<CmdResponse> call();

  /// 取消
  cancel();

  /// 状态
  TaskStatus get status;

  IDOProtocolClibManager get coreManager => _coreManager;

  SppTransManager get sppTransManager => _sppTransManager;
}
