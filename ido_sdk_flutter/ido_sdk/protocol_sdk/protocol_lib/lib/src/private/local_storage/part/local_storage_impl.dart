part of '../local_storage.dart';

class _LocalStorage implements LocalStorage {
  /// SDK 缓存根目录名
  static const _dirName = 'ido_sdk';

  /// SDK根目录
  static String? _pathSDKStatic;

  /// 缓存的设备列表索引文件名
  static const _indexName = 'device_list';
  static const _devicesDirName = 'devices';

  static const _keyDeviceInfo = 'device-info';
  static const _keyFunctionTable = 'func-table';
  static const _keyBindEncryptedData = 'bind-encrypted-data';
  static const _keyBindAuthData = 'bind-auth-data';
  static const _keyFwVersion = 'device-fw-info';
  static const _keyIconInfo = 'app-icon-info';
  static const _keyUserMsgIconInfo = 'msg-icon-user_set';

  static const _keyIsAuthCodeBindMode = 'bind-mode-code-data1';
  static const _keyIsBindState = 'bind-state1';

  static const _keyConfigLogProtocol = 'log-protocol';
  static const _keyConfigLogClib = 'log-clib';

  static const _keyOtaInfo = 'ota-info';

  String? _pathSDK;
  String? _pathMsgIcon;
  String? _pathDevices;
  String? _pathDeviceLog;
  String? _pathAlexa;
  String? _pathCLibFuncTable;
  String? _pathDevicesOTA;

  final _debouncer = _Debouncer(milliseconds: 100);

  final _deviceExtMap = <String, DeviceInfoExtModel>{};

  GetStorage? _getStorage;

  _LocalStorage._internal(this.config) {
    getStorage();
    loadDeviceExtListByDisk();
  }

  @override
  late LocalStorageConfig config;

  @override
  Future<bool>initStorage() async {
    await getStorage();
    return Future(() => true);
  }

  @override
  Future<String?> getString({required String key}) async {
    final storage = await getStorage();
    return Future(() => storage.read<String>(k(key)));
  }

  @override
  Future<bool> remove({required String key, String? macAddress}) async {
    final storage = await getStorage();
    await storage.remove(k(key, macAddress));
    return Future(() => true);
  }

  @override
  Future<bool> setString({required String key, required String value}) async {
    final storage = await getStorage();
    await storage.write(k(key), value);
    return Future(() => true);
  }

  @override
  DeviceInfoExtModel? loadDeviceInfoExtWith(String? macAddress) {
    macAddress ??= config.macAddress;
    logger?.d('devInfo ext - _deviceExtMap: ${_deviceExtMap.toString()} macAddress: $macAddress');
    return _deviceExtMap[macAddress];
  }

  @override
  Future<bool?> getBool({required String key, String? macAddress}) async {
    final storage = await getStorage();
    return Future(() => storage.read<bool>(k(key, macAddress)));
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
  Future<String> pathRoot() async {
    final rootDir = await createRootDir();
    final cachePath =
        '$rootDir/${_LocalStorage._devicesDirName}/${config.macAddress.toLowerCase()}';
    return _createDir(cachePath);
  }

  @override
  Future<String> pathSDK() async {
    return createRootDir();
  }

  @override
  Future<DeviceInfoModel?> loadDeviceInfoByDisk() async {
    final json = await getString(key: _keyDeviceInfo);
    if (json != null) {
      return Future(() => DeviceInfoModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<FunctionTableModel?> loadFunctionTableWith(
      {required String macAddress}) async {
    final storage = await getStorage();
    final json = storage.read<String>(k(_keyFunctionTable, macAddress));
    if (json != null) {
      return Future(() => FunctionTableModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<List<DeviceInfoModel>> loadDeviceInfoListByDisk({bool sortDesc = true}) async {
    final rsList = <DeviceInfoModel>[];
    final list = await loadDeviceExtListByDisk(sortDesc: sortDesc);
    final storage = await getStorage();
    for (var e in list) {
      final json = storage.read<String>(k(_keyDeviceInfo, e.macAddress));
      if (json != null) {
        rsList.add(DeviceInfoModel.fromJson(jsonDecode(json)));
      }
    }
    return rsList;
  }

  @override
  Future<FunctionTableModel?> loadFunctionTableByDisk() async {
    final json = await getString(key: _keyFunctionTable);
    if (json != null) {
      return Future(() => FunctionTableModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveDeviceInfoToDisk(DeviceInfoModel deviceInfoModel) {
    final map = deviceInfoModel.toJson();
    final json = jsonEncode(map);
    // logger?.d(' save deviceInfo len: ${json.length}');
    return setString(key: _keyDeviceInfo, value: json);
  }

  @override
  Future<bool> saveFunctionTableToDisk(FunctionTableModel functionTableModel) {
    final map = functionTableModel.toJson();
    final json = jsonEncode(map);
    logger?.d(' save functionTable len: ${json.length}');
    return setString(key: _keyFunctionTable, value: json);
  }

  @override
  Future<String?> loadBindEncryptedDataByDisk() {
    return getString(key: _keyBindEncryptedData);
  }

  @override
  Future<bool> saveBindEncryptedDataToDisk(String data) {
    // logger?.d('缓存授权码');
    return setString(key: _keyBindEncryptedData, value: data);
  }

  @override
  Future<bool> cleanBindEncryptedData() {
    // logger?.d('清除授权码缓存');
    return remove(key: _keyBindEncryptedData);
  }

  @override
  Future<bool> cleanBindAuthData() {
    // logger?.d('清除配对码缓存');
    return remove(key: _keyBindAuthData);
  }

  @override
  Future<bool> loadBindStatus({required String macAddress}) async {
    return await getBool(key: _keyIsBindState, macAddress: macAddress) ?? false;
  }

  @override
  Future<bool> cleanBindStatus({required String macAddress}) async {
    return await remove(key: _keyIsBindState, macAddress: macAddress);
  }

  @override
  Future<String?> loadBindAuthDataByDisk() {
    return getString(key: _keyBindAuthData);
  }

  @override
  Future<bool> saveBindAuthDataToDisk(String data) {
    // logger?.d('缓存配对码');
    return setString(key: _keyBindAuthData, value: data);
  }

  @override
  Future<FirmwareVersionModel?> loadFirmwareVersionByDisk() async {
    final json = await getString(key: _keyFwVersion);
    if (json != null) {
      return Future(() => FirmwareVersionModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveFirmwareVersionToDisk(FirmwareVersionModel fwVersion) {
    final map = fwVersion.toJson();
    final json = jsonEncode(map);
    return setString(key: _keyFwVersion, value: json);
  }

  @override
  Future<bool> saveDeviceInfoExtToDisk(DeviceInfoExtModel deviceInfoExt) {
    final oldExt = _deviceExtMap[deviceInfoExt.macAddress];
    // 保留历史bt macAddress
    if (oldExt != null &&
        oldExt.macAddressBt != null &&
        oldExt.macAddressBt != deviceInfoExt.macAddressBt) {
      deviceInfoExt.macAddressBt = oldExt.macAddressBt;
      logger?.d("devInfo ext - btAddress不相同，使用新值");
    }
    _deviceExtMap[deviceInfoExt.macAddress] = deviceInfoExt;
    logger?.d("devInfo ext - _deviceExtMap: ${_deviceExtMap.toString()} macAddress: ${deviceInfoExt.macAddress}");
    return _saveDeviceExtListToDisk();
  }

  @override
  Future<List<DeviceInfoExtModel>> loadDeviceExtListByDisk(
      {bool sortDesc = true}) async {
    return _debouncer.run(() async {
      final map = await _loadDeviceExtListByDisk();
      if (map != null) {
        _deviceExtMap.clear();
        _deviceExtMap.addAll(map);
      }
      final list = _deviceExtMap.values.toList();
      list.sort((a, b) =>
      sortDesc ? b.updateTime - a.updateTime : a.updateTime - b.updateTime);
      return list;
    });
  }

  @override
  Future<bool> cleanIconInfoData(String macAddress) {
    logger?.d('clean icon info data == $macAddress');
    return remove(key: _keyIconInfo,macAddress: macAddress);
  }
  
  @override
  Future<bool> removeIconDir(String dirPath) async{
    final del = await storage?.removeDir(absoluteDirPath: dirPath) ?? false;
    if (del) {
      _pathMsgIcon = null;
    }  
    return del;
  }

  @override
  Future<IDOAppIconInfoModel?> loadUserDefaultMsgIconByDisk() async {
    final json = await getString(key: _keyUserMsgIconInfo);
    if (json != null) {
      logger?.d(' load user msg_icon info json len: ${json.length}');
      return Future(() => IDOAppIconInfoModel.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveUserDefaultMsgIconToDisk(IDOAppIconInfoModel model) {
    final map = model.toJson();
    final json = jsonEncode(map);
    logger?.d(' save user set msg_icon info json len: ${json.length}');
    return setString(key: _keyUserMsgIconInfo, value: json);
  }

  @override
  Future<bool> cleanUserMsgDefaultIcon() {
    // TODO: implement cleanAll
    throw UnimplementedError();
  }


  @override
  Future<IDOAppIconInfoModel?> loadIconInfoDataByDisk() async {
    final json = await getString(key: _keyIconInfo);
    if (json != null) {
      //logger?.d(' load icon info data : $json');
      return Future(() => IDOAppIconInfoModel.fromJson(jsonDecode(json)));
    }
    logger?.d('loadIconInfoDataByDisk json len: ${(json ?? '').length}');
    return Future(() => null);
  }

  @override
  Future<bool> saveIconInfoDataToDisk(IDOAppIconInfoModel model) {
    final map = model.toJson();
    final json = jsonEncode(map);
    //logger?.d(' save icon info data: $json');
    logger?.d('saveIconInfoDataToDisk json len: ${json.length}');
    return setString(key: _keyIconInfo, value: json);
  }

  @override
  Future<bool> cleanAll() {
    // TODO: implement cleanAll
    throw UnimplementedError();
  }

  @override
  void resetCachePathOnDeviceChanged() {
    logger?.v("resetCachePathOnDeviceChanged");
    _pathCLibFuncTable = null;
    _pathDeviceLog = null;
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
  Future<String> pathDeviceLog() async {
    if (_pathDeviceLog != null) {
      return Future(() => _pathDeviceLog!);
    }
    final rootDir = await pathRoot();
    final cachePath = '$rootDir/device_logs';
    final path = await _createDir(cachePath);
    _pathDeviceLog = path;
    return Future(() => _pathDeviceLog!);
  }

  @override
  Future<String> pathCLibFuncTable() async {
    if (_pathCLibFuncTable != null) {
      return Future(() => _pathCLibFuncTable!);
    }
    final rootDir = await pathRoot();
    final cachePath = '$rootDir/c_files';
    final path = await _createDir(cachePath);
    _pathCLibFuncTable = path;
    return Future(() => _pathCLibFuncTable!);
  }

  @override
  Future<String> pathOTA() async {
    if (_pathDevicesOTA != null) {
      return Future(() => _pathDevicesOTA!);
    }
    final rootDir = await createRootDir();
    final cachePath = '$rootDir/${_LocalStorage._devicesDirName}/ota';
    final path = await _createDir(cachePath);
    _pathDevicesOTA = path;
    return Future(() => _pathDevicesOTA!);
  }

  @override
  Future<String> pathMessageIcon() async {
    if (_pathMsgIcon != null) {
      return Future(() => _pathMsgIcon!);
    }
    final rootDir = await createRootDir();
    final cachePath = '$rootDir/message_icon';
    final path = await _createDir(cachePath);
    _pathMsgIcon = path;
    return Future(() => _pathMsgIcon!);
  }

  @override
  Future<String> pathAlexa() async {
    if (_pathAlexa != null) {
      return Future(() => _pathAlexa!);
    }
    final rootDir = await createRootDir();
    final cachePath = '$rootDir/alexa';
    final path = await _createDir(cachePath);
    _pathAlexa = path;
    return Future(() => _pathAlexa!);
  }

  @override
  Future<String> pathDevices() async {
    if (_pathDevices != null) {
      return Future(() => _pathDevices!);
    }
    final rootDir = await createRootDir();
    final cachePath = '$rootDir/${_LocalStorage._devicesDirName}';
    final path = await _createDir(cachePath);
    _pathDevices = path;
    return Future(() => _pathDevices!);
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

  /// 加载授权模式
  ///
  /// 授权模式（0 未知，1 授权码，2 配对码)
  @override
  Future<int> loadAuthMode() async {
    return await getInt(key: _keyIsAuthCodeBindMode) ?? 0;
  }

  /// 保存授权模式
  ///
  /// 授权模式（0 未知，1 授权码，2 配对码)
  @override
  Future<bool?> saveAuthMode(int authMode) async {
    return await setInt(key: _keyIsAuthCodeBindMode, value: authMode);
  }

  @override
  Future<bool> cleanAuthMode([String? macAddress]) async {
    return await remove(key: _keyIsAuthCodeBindMode, macAddress: macAddress);
  }

  /// 保存绑定状态
  @override
  Future<bool?> saveBindStatus(bool isBind) async {
    return await setBool(key: _keyIsBindState, value: isBind);
  }


  /// 日志文件保存策略
  @override
  Future<Map<String, dynamic>?> loadLogConfigProtocol() async {
    final storage = await getStorage();
    final ctx = storage.read<String>(_keyConfigLogProtocol);
    //logger?.v("loadLogConfigProtocol txt = $ctx");
    return ctx != null ? jsonDecode(ctx) : null;
  }

  @override
  Future<int?> loadLogConfigClib() async {
    final storage = await getStorage();
    final val = storage.read<int>(_keyConfigLogClib);
    //logger?.v("loadLogConfigClib val = $val");
    return val;
  }

  @override
  Future<bool> saveLogConfigProtocol(int fileSize, fileCount) async {
    final map = {
      "fileSize": fileSize,
      "fileCount": fileCount
    };
    logger?.v("saveLogConfigProtocol map = $map");
    final storage = await getStorage();
    await storage.write(_keyConfigLogProtocol, jsonEncode(map));
    return true;
  }

  @override
  Future<bool> saveLogConfigClib(int saveDay) async {
    final storage = await getStorage();
    logger?.v("saveLogConfigClib saveDay = $saveDay");
    await storage.write(_keyConfigLogClib, saveDay);
    return true;
  }

  /// 获取当前sdk根目录
  /// ```
  /// 返回：/xx/../ido_sdk
  /// ```
  static Future<String> pathSDKStatic() async {
    if (_pathSDKStatic == null) {
      final dirDocument = await ToolsImpl().getDocumentPath();
      final rootDir = '${dirDocument!}/${_LocalStorage._dirName}';
      _pathSDKStatic = rootDir;
      return Future(() => rootDir);
    } else {
      return Future(() => _pathSDKStatic!);
    }
  }

  @override
  Future<IDODeviceOtaInfo?> loadOtaInfoByDisk() async {
    final json = await getString(key: _keyOtaInfo);
    if (json != null) {
      logger?.d('load ota info: $json');
      return Future(() => IDODeviceOtaInfo.fromJson(jsonDecode(json)));
    }
    return Future(() => null);
  }

  @override
  Future<bool> saveOtaInfoToDisk(IDODeviceOtaInfo otaInfo) {
    final map = otaInfo.toJson();
    final json = jsonEncode(map);
    logger?.d('save ota info: $json');
    return setString(key: _keyOtaInfo, value: json);
  }

  @override
  Future<bool> removeOtaInfo(String macAddress) async {
    return remove(key: _keyOtaInfo, macAddress: macAddress);
  }

  @override
  Future<bool> removeCLibFuncTableCache(String macAddress) async {
    if (macAddress.isEmpty) {
      logger?.d('removeCLibFuncTableCache macAddress is empty');
      return false;
    }
    final rootDir = await createRootDir();
    final cachePath =
        '$rootDir/${_LocalStorage._devicesDirName}/${macAddress.toLowerCase()}/c_files';
    final rs = await removeDir(absoluteDirPath: cachePath);
    logger?.d('removeCLibFuncTableCache rs:$rs dir: $cachePath');
    return rs;
  }


  @override
  Future<String?> getCLibFuncTableCachePath(String macAddress) async {
    if (macAddress.isEmpty) {
      logger?.d('getCLibFuncTableCachePath macAddress is empty');
      return null;
    }
    final rootDir = await createRootDir();
    final cachePath =
        '$rootDir/${_LocalStorage._devicesDirName}/${macAddress.toLowerCase()}/c_files';
    final dir = Directory(cachePath);
    if (dir.existsSync()) {
      return cachePath;
    }
    return null;
  }

}

extension _LocalStorageExt on _LocalStorage {
  Future<GetStorage> getStorage() async {
    _LocalStorage._pathSDKStatic ??= await _LocalStorage.pathSDKStatic();
    await GetStorage.init('storage', '${_LocalStorage._pathSDKStatic}/local_storage');
    _getStorage ??=
        GetStorage('storage');
    return Future(() => _getStorage!);
  }

  /// 创建SDK缓存根目录(固定）
  Future<String> createRootDir() async {
    if (_pathSDK != null) {
      return Future(() => _pathSDK!);
    }
    final dirDocument = await ToolsImpl().getDocumentPath();
    final rootDir = '${dirDocument!}/${_LocalStorage._dirName}';
    final path = await _createDir(rootDir);
    _pathSDK = path;
    return Future(() => _pathSDK!);
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

  Future<bool> _saveDeviceExtListToDisk() async {
    final rootDir = await createRootDir();
    final indexFilePath =
        '$rootDir/${_LocalStorage._devicesDirName}/${_LocalStorage._indexName}';
    final file = File(indexFilePath);
    if (!await file.exists()) {
      file.createSync(recursive: true);
    }
    if (!file.existsSync()) {
      logger?.e("devInfo ext - 文件$indexFilePath 创建失败");
    }
    final jsonObj =
        _deviceExtMap.map((key, value) => MapEntry(key, value.toJson()));
    final jsonStr = jsonEncode(jsonObj);
    final rs = await (await file.writeAsString(jsonStr, flush: true)).exists();
    logger?.d("devInfo ext - saveDeviceExtListToDisk rs = $rs  json:$jsonStr}");
    return Future(() => rs);
  }

  Future<Map<String, DeviceInfoExtModel>?> _loadDeviceExtListByDisk() async {
    final rootDir = await createRootDir();
    final indexFilePath =
        '$rootDir/${_LocalStorage._devicesDirName}/${_LocalStorage._indexName}';
    final file = File(indexFilePath);
    if (!await file.exists()) {
      file.createSync(recursive: true);
      await file.writeAsString('{}');
      logger?.d("devInfo ext - 初始创建文件：$indexFilePath json:{} rs: ${file.existsSync()}");
      return Future(() => {});
    }
    final jsonStr = await file.readAsString();
    logger?.d("devInfo ext - 读取文件：$indexFilePath json:$jsonStr");
    if (jsonStr.isNotEmpty) {
      try {
        final jsonObj = jsonDecode(jsonStr) as Map;
        logger?.d("devInfo ext - jsonObj = $jsonObj");
        final map = <String, DeviceInfoExtModel>{};
        for (var key in jsonObj.keys) {
          map[key] = DeviceInfoExtModel.fromJson(jsonObj[key]);
        }
        logger?.d("devInfo ext - map = $jsonObj");
        return Future(() => map);
      } catch (e) {
        logger?.e("_loadDeviceExtListByDisk jsonStr $jsonStr $e");
        return Future(() => {});
      }
    }else {
      logger?.e("devInfo ext - 文件$indexFilePath 不存在");
      return Future(() => {});
    }
  }

  /// key
  String k(String key, [String? macAddress]) {
    final aKey = '_pm_${macAddress ?? config.macAddress}_$key'.toUpperCase();
    //logger?.d('aKey = $aKey');
    return aKey;
  }
}


/// 节流器
class _Debouncer {
  final int milliseconds;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  Future<T> run<T>(Future<T> Function() action) async {
    if (_timer != null) {
      _timer!.cancel();
    }
    final completer = Completer<T>();
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      try {
        final result = await action();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });
    return completer.future;
  }
}