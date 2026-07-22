part of '../commands_manager.dart';

class _IDOCommandsManager implements IDOCommandsManager {
  static final _instance = _IDOCommandsManager._internal();
  factory _IDOCommandsManager() => _instance;

  _IDOCommandsManager._internal();

  @override
  bool get isSupportNotice => libManager.funTable.reminderAncs;

  @override
  Future<IDONoticeStatusModel?> getNoticeStatus() async {
    if (!isSupportNotice) {
      logger?.w('[Commands] getNoticeStatus failed: ancs not supported');
      return null;
    }
    final rs = await libManager.send(
      evt: CmdEvtType.getNoticeStatus,
      json: '{}',
    ).first;
    if (!rs.isOK || rs.json == null || rs.json!.isEmpty) {
      logger?.e('[Commands] getNoticeStatus failed: error_code=${rs.code}');
      return null;
    }
    try {
      final jsonMap = jsonDecode(rs.json!) as Map<String, dynamic>;
      return IDONoticeStatusModel.fromJson(jsonMap);
    } catch (e, st) {
      logger?.e('[Commands] getNoticeStatus decode failed: $e\n$st');
      return null;
    }
  }

  @override
  Future<IDOCommandResult?> setNoticeStatus(IDONoticeStatusModel model) async {
    if (!isSupportNotice) {
      logger?.w('[Commands] setNoticeStatus failed: ancs not supported');
      return null;
    }
    final jsonStr = jsonEncode(model.toJson());
    final rs = await libManager.send(
      evt: CmdEvtType.setNotificationCenter,
      json: jsonStr,
    ).first;
    if (!rs.isOK || rs.json == null || rs.json!.isEmpty) {
      logger?.e('[Commands] setNoticeStatus failed: error_code=${rs.code}');
      return null;
    }
    try {
      final jsonMap = jsonDecode(rs.json!) as Map<String, dynamic>;
      return IDOCommandResult.fromJson(jsonMap);
    } catch (e, st) {
      logger?.e('[Commands] setNoticeStatus decode failed: $e\n$st');
      return null;
    }
  }
}
