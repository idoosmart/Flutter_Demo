import '../type_define/type_define.dart';
import '../model/base_file_model.dart';

abstract class AbstractFileOperate {
  final FileTransType type;
  final BaseFileModel fileItem;
  /// 须由[makeFileIfNeed]内部赋值，转换后的文件项
  BaseFileModel? newFileItem;

  AbstractFileOperate(this.type, this.fileItem);

  /// 类型检查
  Future<bool> verifyFileType();

  /// 检查文件是否存在
  Future<bool> checkExists();

  /// 配置参数
  Future<bool> configParamIfNeed();

  /// 文件传输前的数据处理
  ///
  /// 根据文件后缀，对文件进行压缩、转换等操作
  /// 返回处理后的文件路径
  Future<BaseFileModel> makeFileIfNeed();

  /// 文件传输
  Future<bool> tranFile();

  /// 取消
  void cancel();
}
