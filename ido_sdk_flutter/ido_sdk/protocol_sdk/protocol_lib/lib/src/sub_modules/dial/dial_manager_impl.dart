part of dial_manager;

class _IDODialManager implements IDODialManager {
  _IDODialManager._();
  static final _instance = _IDODialManager._();
  factory _IDODialManager() => _instance;

  @override
  IPhotoDial get dialPhoto => PhotoDialImpl();
}