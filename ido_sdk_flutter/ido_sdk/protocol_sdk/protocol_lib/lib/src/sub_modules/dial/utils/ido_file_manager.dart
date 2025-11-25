part of dial_manager;

class _FileManager {
  ///所有目录路径一次创建完成，循环创建目录
  static Future<void> createDirToDocument(String dirPath) async {
    try {
      //创建文件夹
      if (!existDirectory(dirPath)) {
        var dir = Directory(dirPath);
        var result = await dir.create(recursive: true);
        logger?.i('新建文件夹:$dirPath$result');
      }
    } catch (e) {
      logger?.i('catch error $e');
    }
  }

  ///目录是否存在
  static bool existDirectory(String dirPath) {
    var dir = Directory(dirPath);
    bool exist = dir.existsSync();
    if (exist) {
      logger?.i("文件夹已存在$dirPath");
    } else {
      logger?.i("文件不存在$dirPath");
    }
    return exist;
  }

  /// 删除目录
  static void removeDirectory(String dirPath) {
    var dir = Directory(dirPath);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  ///创建文件
  static Future<bool> createFile(String filePath) async {
    try {
      if (!existFile(filePath)) {
        var file = File(filePath);
        var result = await file.create();
        logger?.i('新建文件:$filePath$result');
      }
      return true;
    } catch (e) {
      logger?.i('catch error $e');
    }
    return false;
  }

  ///文件是否存在
  static bool existFile(String filePath) {
    var file = File(filePath);
    bool exist = file.existsSync();
    // if (exist) {
    // } else {}
    return exist;
  }

  ///删除文件
  static Future<void> deleteFile(String atPath) async {
    var file = File(atPath);
    if (file.existsSync()) {
      await file.delete(recursive: true);
    }
  }

  ///删除目录下的所有文件，outsideList除外
  static Future<void> deleteFiles(String atPath, List outsideList) async {
    if (!existDirectory(atPath)) {
      return;
    }
    var dir = Directory(atPath);
    List all = await dir.list().toList();
    for (FileSystemEntity file in all) {
      var uri = file.uri;
      String name = uri.pathSegments.last.split('.').first;
      if (outsideList.contains(name)) {
        continue;
      }
      await deleteFile(uri.path);
    }
  }

  ///目录下的所有文件名，outsideList除外
  static Future<List<String>> allFiles(String atPath, {List? outsideList}) async {
    if (!existDirectory(atPath)) {
      return [];
    }

    List<String> fileNames = List.empty(growable: true);
    var dir = Directory(atPath);
    List all = await dir.list().toList();
    for (FileSystemEntity file in all) {
      var uri = file.uri;
      String name = uri.pathSegments.last;
      if (outsideList != null && outsideList.contains(name)) {
        continue;
      }
      fileNames.add(uri.pathSegments.last);
    }
    return fileNames;
  }

  ///copy文件
  static copyFile(String atPath, String toPath) {
    // logger?.i("copy文件" + atPath);
    var file = File(atPath);
    file.copy(toPath);
  }

  ///文件压缩
  static Future<bool> zipDirectory(
      {required String zipFilePath, List<Directory>? directoryList, List<File>? fileList}) async {
    directoryList ??= [];
    fileList ??= [];
    var encoder = ZipFileEncoder();
    var zipFile = File(zipFilePath);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }
    encoder.create(zipFilePath);
    for (var itemDirectory in directoryList) {
      await encoder.addDirectory(itemDirectory);
    }
    for (var itemFile in fileList) {
      await encoder.addFile(itemFile);
    }
    encoder.close();
    return Future(() => true);
  }

  ///获取文件的大小 单位 KB
  static Future<double> fileSize(String atPath) async {
    // logger?.i("copy文件" + atPath);
    final file = File(atPath);
    try {
      int fileSizeInBytes = await file.length();
      return fileSizeInBytes / 1024.0;
    } catch (e) {
      logger?.i('获取文件大小失败: $e');
    }
    return 0;
  }

  ///获取文件的创建时间
  static Future<DateTime?> fileCreateTime(String atPath) async {
    final file = File(atPath);
    try {
      final fileStat = await file.stat();
      return fileStat.changed;
    } catch (e) {
      logger?.i('无法获取文件信息: $e');
    }
    return null;
  }

  ///计算文件的 MD5 值
  static Future<String> calculateFileMD5(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final md5Hash = md5.convert(bytes);
    return md5Hash.toString();
  }

  static Future<String?> findFileInDirectory(String directoryPath, [String fileName = "iwf.json"]) async {
    try {
      // 获取指定目录
      final directory = Directory(directoryPath);

      // 检查目录是否存在
      if (!await directory.exists()) {
        debugPrint('目录不存在: $directoryPath');
        return null;
      }

      // 遍历目录中的所有文件和子目录
      final files = await directory.list(recursive: true).toList();

      // 查找名为 iwf.json 的文件
      for (final FileSystemEntity entity in files) {
        if (entity is File && entity.path.basename() == fileName) {
          // 返回文件所在的目录路径
          final parentDir = entity.parent.path;
          //debugPrint('找到 $fileName 文件: ${entity.path}');
          return parentDir;
        }
      }

      // 如果没有找到 iwf.json 文件，返回 null
      debugPrint('未找到 $fileName 文件');
      return null;
    } catch (e) {
      debugPrint('发生错误: $e');
      return null;
    }
  }

}
