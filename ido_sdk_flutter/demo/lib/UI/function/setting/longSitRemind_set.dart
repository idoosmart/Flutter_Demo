// 设置久坐提醒

import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';

typedef OnSelect = void Function(Object o);

class LongSitRemindSet extends StatelessWidget {
  final String navTitle;

  const LongSitRemindSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const LongSitRemindContent(),
    );
  }
}

class LongSitRemindContent extends StatefulWidget {
  const LongSitRemindContent({Key? key}) : super(key: key);

  @override
  State<LongSitRemindContent> createState() => _LongSitRemindContentState();
}

class _LongSitRemindContentState extends State<LongSitRemindContent> {
  Map<String, dynamic> jsonMap = {};

  LongSitRemindSetModel _longsitModel = LongSitRemindSetModel();

  List<String> leftList = [
    S.current.connected,
    S.current.setlongsitnoticeswitch,
    S.current.sethowmanyminuteslaternotice,
    S.current.setstarttime,
    S.current.setendtime,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.setlongsitremind,
  ];

  void _updateInformation() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },

      itemCount: leftList.length,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }

  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo, [], (o) {});
    } else if (tInt == 1) {
      return commonUI.productionWidget(WidType.textSwitch,
          [leftList[tInt], _longsitModel.longSitFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'
            ? _longsitModel.longSitFlag = true
            : _longsitModel.longSitFlag = false;
        _updateInformation();
      });
    } else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText,
          [leftList[tInt], _longsitModel.remindTime.toString()], (o) {
        dealwithPointerUp(leftList[tInt], _longsitModel.remindTime.toString(),
            (o) {
          print('------${o}');
          _longsitModel.remindTime = int.parse(o.toString());
          _updateInformation();
        });
      });
    } else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTwoText, [
        leftList[tInt],
        _longsitModel.startHour.toString(),
        _longsitModel.startMinute.toString()
      ], (o) {
        if (o.toString() == 'hour') {
          dealwithPointerUp('hour', _longsitModel.startHour.toString(), (o) {
            _longsitModel.startHour = int.parse(o.toString());
            _updateInformation();
          });
        } else if (o.toString() == 'minute') {
          dealwithPointerUp('minute', _longsitModel.startMinute.toString(),
              (o) {
            _longsitModel.startMinute = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    } else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textTwoText, [
        leftList[tInt],
        _longsitModel.endHour.toString(),
        _longsitModel.endMinute.toString()
      ], (o) {
        if (o.toString() == 'hour') {
          dealwithPointerUp('hour', _longsitModel.endHour.toString(), (o) {
            _longsitModel.endHour = int.parse(o.toString());
            _updateInformation();
          });
        } else if (o.toString() == 'minute') {
          dealwithPointerUp('minute', _longsitModel.endMinute.toString(), (o) {
            _longsitModel.endMinute = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    } else if (tInt == 5) {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) {});
    } else if (tInt == 13) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]],
          (o) {
        print('object=====');
        executeCmd(o.toString());
      });
    } else {
      bool pt = false;
      if (_longsitModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt], pt],
          (o) {
        print('--------${o.toString()}');
        String chStr = o.toString();
        if (_longsitModel.weekList.contains(chStr)) {
          _longsitModel.weekList.remove(chStr);
        } else {
          _longsitModel.weekList.add(chStr);
        }
        _updateInformation();
      });
    }

    return const Text('test');
  }

  // 久坐提醒
  executeCmd(String typeStr) {


    jsonMap = _longsitModel.toMap();

    TestCmd e =
        TestCmd(cmd: CmdEvtType.setLongSit, name: typeStr, json: jsonMap);
    libManager.send(evt: e.cmd, json: jsonEncode(e.json ?? {})).listen((res) {
      debugPrint(
          '${e.name} ${e.cmd.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');

      if (res.code == 0) {
        //默认是显示在中间的
        Toast.toast(context, msg: "设置成功");
      } else {
        //默认是显示在中间的
        Toast.toast(context, msg: "设置失败");
      }
    });
  }

  //处理相关的弹框需求
  Future<void> dealwithPointerUp(
      String tinStr, String conStr, OnSelect onSelect) async {
    if (tinStr == S.current.sethowmanyminuteslaternotice) {
      // 显示时长
      //int? type = await _showModalBottomSheet(SelectType.useridType);
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.longSitType),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    } else if (tinStr == 'hour') {
      //  小时
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.hourType),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    } else if (tinStr == 'minute') {
      //  分钟
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.minuteType),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    }
  }
}
