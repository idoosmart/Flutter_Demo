import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:native_channel/native_channel.dart';

class IDOKvEngine {

  static late Box _box;
  static const String _boxName = "ido-kvStore";
  static late  String _rootDir;
  static bool _init = false;
  static Future<void> init({String? rootDir}) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (rootDir == null) {
      final path = await ToolsImpl().getDocumentPath();
      if (path == null) {
        throw FlutterError("getDocumentPath 获取失败");
      }
      debugPrint("getDocumentPath:$path");
      rootDir = '$path/ido_sdk/local_storage';
    }
    _rootDir = rootDir;
    Hive.init(_rootDir);
    _box = await Hive.openBox(_boxName);
    _init = true;
    _cache[_boxName] = IDOKvWrapper(_boxName, _box);
  }

   static final Map<String,IDOKvWrapper> _cache = {};
   static IDOKvEngine get instance => _instance ??= IDOKvEngine._();
   static IDOKvEngine? _instance;
   IDOKvEngine._();

  static Future<IDOKvWrapper> withDir(String? boxName) async {
    assert(_init, () {
      throw "请先初始化";
    });
    String retBox = boxName ?? _boxName;
    IDOKvWrapper? kvWrapper = _cache[retBox];
    if (kvWrapper == null) {
      Box box = await Hive.openBox(_boxName);
      kvWrapper = IDOKvWrapper(retBox, box);
      _cache[retBox] = kvWrapper;
    }
    return kvWrapper;
  }
  //
  static IDOKvWrapper withDefault() {
    assert(_init, () {
      throw FlutterError( "请先初始化");
    });
    return _cache[_boxName]!;
  }

}

class IDOKvWrapper {
  final String _boxName;
  final Box _box;
  const IDOKvWrapper(this._boxName,this._box);

  void putString(String key, String value) {
    _box.put(key, value);
  }

  String getString(String key, {String defaultStr = ""}) {
    return _box.get(key, defaultValue: defaultStr) as String;
  }

  void putInt(String key, int value) {
    _box.put(key, value);
  }

  int getInt(String key, {int defaultInt = 0}) {
    return _box.get(key, defaultValue: defaultInt) as int;
  }

  void putDouble(String key, double value) {
    _box.put(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _box.get(key, defaultValue: defaultValue) as double;
  }

  void putBool(String key, bool value) {
    _box.put(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _box.get(key, defaultValue: defaultValue) as bool;
  }
  
  void remove(String key){
    _box.delete(key);
  }

}