part of dial_manager;

class _JsonHelper {
  //读取Json文件
  static Future<String> readJsonContent(String path, [fileName = 'iwf']) async {
    try {
      final file = File('$path/$fileName.json');
      var contents = await file.readAsString();
      return contents;
    } catch (e) {
      logger?.i('读取Json文件 error $e');
      return '';
    }
  }

  //读取Json文件
  static String readJsonContentSync(String path, [fileName = 'iwf']) {
    try {
      final file = File('$path/$fileName.json');
      var contents = file.readAsStringSync();
      return contents;
    } catch (e) {
      logger?.i('读取Json文件 error $e');
      return '';
    }
  }

  ///保存DialJsonObj对象 app.json
  // static void writeAppJsonToDocument(DialJsonObj? obj, String path) async {
  //   if (obj == null) {
  //     return;
  //   }
  //   var jsonMap = obj.toJson();
  //   var jsonStr = json.encode(jsonMap);
  //   final file = File('$path/app.json');
  //   file.writeAsString(jsonStr);
  // }

  ///保存对象 iwf.json
  static Future<void> writeDialIwfToDocument(Map? obj, String path, [fileName = 'iwf']) async {
    if (obj == null) {
      return;
    }
    var jsonStr = json.encode(obj);
    final file = File('$path/$fileName.json');
    await file.writeAsString(jsonStr);
  }

  ///解压 压缩包
  static Future<String> unarchiveFromDisk(String savePath, String folderName, [forcedExtract = false]) async {
    final dir = Directory('$savePath/$folderName');
    if (!forcedExtract && dir.existsSync()) {
      return dir.path;
    }
    if (forcedExtract) {
      await storage?.removeDir(absoluteDirPath: '$savePath/$folderName');
    }

    try {
      //await IdoNativeHost().unzipFileAtPath('$savePath/$folderName.zip', '$savePath/$folderName');
      final inputStream = InputFileStream('$savePath/$folderName.zip');
      final archive = ZipDecoder().decodeBuffer(inputStream);
      //解压
      // extractFileToDisk(savePath, extractPath);
      await extractArchiveToDisk(archive, '$savePath/$folderName');
      return '$savePath/$folderName';
    } catch (e) {
      logger?.i('解压压缩包 error $e');
      return '';
    }
  }

  ///解压 压缩包
  static Future<String?> unarchiveToDisk({required String zipPath,  required String targetPath}) async {
    //await storage?.removeDir(absoluteDirPath: targetPath);
    try {
      _FileManager.removeDirectory(targetPath);
      final inputStream = InputFileStream(zipPath);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      await extractArchiveToDisk(archive, targetPath);
      final unzipPath = await _FileManager.findFileInDirectory(targetPath);
      return unzipPath;
    } catch (e) {
      logger?.i('解压压缩包 error $e');
      return null;
    }
  }

  ///解压 压缩包
  static String unarchiveFromDiskSync(String savePath, String folderName, [forcedExtract = false]) {
    final dir = Directory('$savePath/$folderName');
    if (!forcedExtract && dir.existsSync()) {
      return dir.path;
    }
    if (forcedExtract) {
      final dir = Directory('$savePath/$folderName');
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    }
    try {
      //await IdoNativeHost().unzipFileAtPath('$savePath/$folderName.zip', '$savePath/$folderName');
      final inputStream = InputFileStream('$savePath/$folderName.zip');
      final archive = ZipDecoder().decodeBuffer(inputStream);
      //解压
      // extractFileToDisk(savePath, extractPath);
      extractArchiveToDiskSync(archive, '$savePath/$folderName');
      return '$savePath/$folderName';
    } catch (e) {
      logger?.i('解压压缩包 error $e');
      return '';
    }
  }

  ///压缩 文件 archivePath: **/**/*.zip
  static Future<String> archiveToDisk(
      {required String inputFilePath,
      required String outputFilePath,
      required String fileName,
      required bool isSifli}) async {
    // if (IDOFileManager.existFile(outputFilePath)) {
    //   IDOFileManager.deleteFile(outputFilePath);
    // }

    if (isSifli) {
      // 返回 0成功 非0失败 -1: 没有控件 -2: json文件加载失败 -3: 文件制作失败
      //await IDOFileManager.deleteFiles("$inputFilePath/dyn/dynamic_app/watchface/custom1/ezip", []);
      storage?.removeDir(absoluteDirPath: "$inputFilePath/dyn/dynamic_app/watchface/custom1/ezip");
      final state = await libManager.tools
          .makeSifliDialFile(inputFilePath: inputFilePath, fileName: fileName, outputFilePath: outputFilePath);
      if (state == 0) {
        return outputFilePath;
      } else {
        return "";
      }
    }

    // var encoder = ZipFileEncoder();
    // encoder.zipDirectory(Directory(archivePath), filename: filename);
    // encoder.close();
    //上面的压缩方法会报错，使用下面的方法
    var encoder = ZipFileEncoder();
    var dir = Directory(inputFilePath);

    encoder.create(outputFilePath);
    List all = await dir.list().toList();
    for (FileSystemEntity file in all) {
      if (await FileSystemEntity.isFile(file.path)) {
        await encoder.addFile(File(file.path));
      } else if (await FileSystemEntity.isDirectory(file.path)) {
        await encoder.addDirectory(Directory(file.path));
      }
    }

    encoder.close();

    return outputFilePath;
  }
}
