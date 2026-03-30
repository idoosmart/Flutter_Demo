import 'package:shared_preferences/shared_preferences.dart';

class BindStateStorage {
  static const String _bindStatePrefix = 'bind_state_';

  static Future<bool> load(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final isBinded = prefs.getBool('$_bindStatePrefix$macAddress') ?? false;
    print("获取缓存绑定状态：$isBinded $macAddress");
    return isBinded;
  }

  static Future<void> save(String macAddress, bool isBinded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_bindStatePrefix$macAddress', isBinded);
    print("缓存绑定状态：$isBinded $macAddress");
  }

  static Future<void> clear(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_bindStatePrefix$macAddress');
    print("清除缓存的绑定状态：$macAddress");
  }
}
