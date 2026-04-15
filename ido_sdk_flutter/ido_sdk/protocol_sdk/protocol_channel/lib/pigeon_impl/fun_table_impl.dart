import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/func_table.g.dart';

class FuncTableImpl extends FuncTable {

  @override
  Future<String> loadFuncTableByDisk(String macAddress) async {
    return await libManager.cache.loadFuncTableJsonByDisk(macAddress: macAddress) ?? '{}';
  }

  @override
  Future<String> exportFuncTableFile(String macAddress) async {
    return await libManager.funTable.exportFuncTableFile() ?? '';
  }
}