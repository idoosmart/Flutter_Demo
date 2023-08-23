// 科学睡眠开关

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


class SleepSwitchSet extends StatelessWidget {
  final String navTitle;


  const SleepSwitchSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const SleepSwitchContent(),
    );
  }
}


class SleepSwitchContent extends StatefulWidget {
  const SleepSwitchContent({Key? key}) : super(key: key);

  @override
  State<SleepSwitchContent> createState() => _SleepSwitchContentState();
}

class _SleepSwitchContentState extends State<SleepSwitchContent> {

  SleepSwitchSetModel _sleepSwitchModel = SleepSwitchSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setsleepswitchmodel,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.setup,
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
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _sleepSwitchModel.sleepSwitchModeFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_sleepSwitchModel.sleepSwitchModeFlag = true:_sleepSwitchModel.sleepSwitchModeFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_sleepSwitchModel.startHour.toString(),_sleepSwitchModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _sleepSwitchModel.startHour.toString(),
                      (o)
                  {
                    _sleepSwitchModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _sleepSwitchModel.startMinute.toString(),
                      (o)
                  {
                    _sleepSwitchModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_sleepSwitchModel.stopHour.toString(),_sleepSwitchModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _sleepSwitchModel.stopHour.toString(),
                      (o)
                  {
                    _sleepSwitchModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _sleepSwitchModel.stopMinute.toString(),
                      (o)
                  {
                    _sleepSwitchModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }

    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setScientificSleepSwitch, name:o.toString() , json: _sleepSwitchModel.toMap()   );
        libManager
            .send(evt: e.cmd, json: jsonEncode(e.json ?? {}))
            .listen((res) {
          debugPrint(
              '${e.name} ${e.cmd.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');

          if (res.code == 0) {

            //默认是显示在中间的
            Toast.toast(context,msg: "设置成功");

          }
          else{

            //默认是显示在中间的
            Toast.toast(context,msg: "设置失败");
          }

        });


      });
    }




    return const Text('test');
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == 'hour') {   //  小时
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
    }
    else if (tinStr == 'minute') {   //  分钟
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





