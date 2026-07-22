import 'base_file_model.dart';
import '../type_define/type_define.dart';

/// 吃药提醒图标（`.medic`，传输 type `0x1C`）
class MedicineFileModel extends BaseFileModel {
  MedicineFileModel({
    required super.filePath,
    required super.fileName,
    super.fileSize,
  }) : super(fileType: FileTransType.medic);

  @override
  String toString() {
    return 'MedicineFileModel{fileType: $fileType, filePath: $filePath, '
        'fileName: $fileName, fileSize: $fileSize}';
  }
}
