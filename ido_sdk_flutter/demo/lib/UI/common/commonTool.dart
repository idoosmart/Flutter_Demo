import '../../generated/l10n.dart';
import 'package:protocol_lib/protocol_lib.dart';

List<String> weekDays = [S.current.monday,S.current.tuesday,
                        S.current.wednesday,S.current.thursday,
                        S.current.friday,S.current.saturday,
                        S.current.sunday
                        ];

class CommonTool
{
  static String obtainWeekDay(int wDay)
  {
    return weekDays[wDay - 1];
  }
}



class TestCmd {
  final CmdEvtType cmd;
  Map<String, dynamic>? json;
  final String name;
  TestCmd({required this.cmd, required this.name, this.json});
}