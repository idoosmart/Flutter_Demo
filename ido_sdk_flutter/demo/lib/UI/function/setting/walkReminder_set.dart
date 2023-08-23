// 设置走动提醒

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


class WalkReminderSet extends StatelessWidget {
  final String navTitle;


  const WalkReminderSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const WalkReminderContent(),
    );
  }
}


class WalkReminderContent extends StatefulWidget {
  const WalkReminderContent({Key? key}) : super(key: key);

  @override
  State<WalkReminderContent> createState() => _WalkReminderContentState();
}

class _WalkReminderContentState extends State<WalkReminderContent> {

  WalkReminderSetModel _walkRemindModel = WalkReminderSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setwalkreminder,
    S.current.setwalkremindertarget,
    S.current.setatargettime,
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
    S.current.setwalkreminder,
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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _walkRemindModel.walkReminderFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_walkRemindModel.walkReminderFlag = true:_walkRemindModel.walkReminderFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_walkRemindModel.walkReminderTarget.toString()],
              (o) {

            dealwithPointerUp(S.current.setwalkremindertarget, _walkRemindModel.walkReminderTarget.toString(),
                    (o)
                {
                  _walkRemindModel.walkReminderTarget = int.parse(o.toString());
                  _updateInformation();
                });


          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_walkRemindModel.targetTime.toString()],
              (o) {

              dealwithPointerUp('', _walkRemindModel.targetTime.toString(),
                      (o)
                  {
                    _walkRemindModel.targetTime = int.parse(o.toString());
                    _updateInformation();
                  });


          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_walkRemindModel.startHour.toString(),_walkRemindModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _walkRemindModel.startHour.toString(),
                      (o)
                  {
                    _walkRemindModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _walkRemindModel.startMinute.toString(),
                      (o)
                  {
                    _walkRemindModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_walkRemindModel.stopHour.toString(),_walkRemindModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _walkRemindModel.stopHour.toString(),
                      (o)
                  {
                    _walkRemindModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _walkRemindModel.stopMinute.toString(),
                      (o)
                  {
                    _walkRemindModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 6)
    {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setWalkRemind, name: o.toString(), json: _walkRemindModel.toMap()   );
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
    else
    {
      bool pt = false;
      if (_walkRemindModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_walkRemindModel.weekList.contains(chStr)) {
              _walkRemindModel.weekList.remove(chStr);
            }
            else{
              _walkRemindModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
  }


  List<String> obainTargetList(){
    List<String> reList = [];
    for(int i = 1000; i <= 10000; i+=1000)
    {
      reList.add(i.toString());
    }
    return reList;
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
    else if (tinStr == S.current.setwalkremindertarget){  // 设置提醒步数目标
      Pickers.showSinglePicker(
        context,
        data: obainTargetList(),
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
    else {
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.showTimeType),
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





