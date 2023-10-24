part of '../local_storage.dart';

class _LocalStorage implements LocalStorage {
  static const _keyAuth = 'auth-info';
  static const _keyLanType = 'language-type';
  static const _keyProductId = 'product-id';
  static const _DeviceKey = 'devices';

  GetStorage? _getStorage;

  _LocalStorage._internal(this.config) {
    getStorage();
  }

  @override
  late LocalStorageConfig config;

  @override
  Future<String> pathAlexaDeviceRoot({required String macAddr}) async {
    final path = await libManager.cache.alexaPath();
    final cachePath =
        '$path/${_DeviceKey}/${macAddr.toLowerCase()}';
    return _createDir(cachePath);
  }


  @override
  Future<String?> getString({required String key}) async {
    final storage = await getStorage();
    return Future(() => storage.read<String>(k(key)));
  }

  @override
  Future<bool> remove({required String key, String? macAddress}) async {
    final storage = await getStorage();
    await storage.remove(k(key));
    return Future(() => true);
  }

  @override
  Future<bool> setString({required String key, required String value}) async {
    final storage = await getStorage();
    await storage.write(k(key), value);
    return Future(() => true);
  }

  @override
  Future<bool?> getBool({required String key}) async {
    final storage = await getStorage();
    return Future(() => storage.read<bool>(k(key)));
  }

  @override
  Future<int?> getInt({required String key}) async {
    final storage = await getStorage();
    return Future(() => storage.read<int>(k(key)));
  }

  @override
  Future<bool> setBool({required String key, required bool value}) async {
    final storage = await getStorage();
    await storage.write(k(key), value);
    return Future(() => true);
  }

  @override
  Future<bool> setInt({required String key, required int value}) async {
    final storage = await getStorage();
    await storage.write(k(key), value);
    return Future(() => true);
  }

  @override
  Future<bool> cleanAll() {
    // TODO: implement cleanAll
    throw UnimplementedError();
  }

  @override
  Future<bool> createDir({required String absoluteDirPath}) async {
    final path = await _createDir(absoluteDirPath);
    return Future(() => path.isNotEmpty);
  }

  @override
  Future<bool> createFile({required String absoluteFilePath}) async {
    final path = await _createFile(absoluteFilePath);
    return Future(() => path.isNotEmpty);
  }

  @override
  Future<bool> removeDir({required String absoluteDirPath}) async {
    var rs = true;
    try {
      await _removeDir(absoluteDirPath);
    } catch (e) {
      rs = false;
      logger?.e(e);
    }
    return Future(() => rs);
  }

  @override
  Future<bool> removeFile({required String absoluteFilePath}) async {
    var rs = true;
    try {
      await _removeFile(absoluteFilePath);
    } catch (e) {
      rs = false;
      logger?.e(e);
    }
    return Future(() => rs);
  }

  @override
  Future<AuthModel?> loadAuthDataByDisk() async {
    final json = await getString(key: _keyAuth);
    logger?.d('loadAuthDataByDisk json:${json?.length}');
    if (json != null) {
      return Future(() => AuthModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveAuthDataToDisk(AuthModel model) async {
    final map = model.toJson();
    final json = jsonEncode(map);
    final rs = await setString(key: _keyAuth, value: json);
    logger?.d('saveAuthDataToDisk json:${json.length} rs:$rs');
    return rs;
  }

  @override
  void cleanAuthData() {
    remove(key: _keyAuth);
  }

  @override
  Future<AlexaLanguageType?> loadLanguageType() async {
    final name = await getString(key: _keyLanType);
    logger?.d('loadLanguageType type:$name');
    if (name != null) {
      return AlexaLanguageType.values.firstWhere((e) => e.name == name);
    }
    return null;
  }

  @override
  Future<bool> saveLanguageType(AlexaLanguageType countryType) async {
    final rs = await setString(key: _keyLanType, value: countryType.name);
    logger?.d('saveLanguageType type:${countryType.name} rs:$rs');
    return rs;
  }

  @override
  Future<String?> loadProductId() async {
    final rs = await getString(key: _keyProductId);
    logger?.d('loadProductId productId:$rs');
    return rs;
  }

  @override
  Future<bool> saveProductId(String productId) async {
    final rs = await setString(key: _keyProductId, value: productId);
    //logger?.d('saveProductId productId:$productId rs:$rs');
    return rs;
  }

  @override
  Future<List?> loadAlarmDataByDisk(String mac) async {
    String key = _DeviceKey+"_"+mac.toLowerCase();
    final json = await getString(key: key);
    logger?.d('loadAlarmDataByDisk mac = ${mac}, json = ${json?.length}');
    if (json != null) {
      List<dynamic> jsonList = jsonDecode(json);
      List<AlexaAlarmModel> userList = jsonList.map((json) => AlexaAlarmModel.fromJson(json)).toList();
      return Future(() => userList);
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveAlarmDataToDisk(String mac, List alexaAlarmList) async {
    if (mac != null){
      String key = _DeviceKey+"_"+mac.toLowerCase();
      String json = jsonEncode(alexaAlarmList.map((user) => user.toJson()).toList());
      final rs = await setString(key: key, value: json);
      logger?.d('saveAlarmDataToDisk mac = ${mac} json = ${json.length} rs:$rs');
      return rs;
    }
    logger?.d('saveAlarmDataToDisk mac = null');
    return false;
  }
}

extension _LocalStorageExt on _LocalStorage {
  Future<GetStorage> getStorage() async {
    final path = await libManager.cache.alexaPath();
    _getStorage ??= GetStorage('alexa_storage', '$path/alexa_storage');
    //logger?.v('_getStorage hashCode:${_getStorage.hashCode} path:$path/alexa_storage');
    return _getStorage!;
  }

  /// 创建目录
  Future<String> _createDir(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      final path = (await dir.create(recursive: true)).path;
      return Future(() => path);
    } else {
      return Future(() => dir.path);
    }
  }

  /// 创建文件
  Future<String> _createFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      final path = (await file.create(recursive: true)).path;
      return Future(() => path);
    } else {
      return Future(() => file.path);
    }
  }

  /// 删除指定文件
  _removeFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 删除指定目录
  _removeDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// key
  String k(String key) {
    final aKey = '${config.uniqueID}-$key'.toUpperCase();
    logger?.d('aKey = $aKey');
    return aKey;
  }
}
