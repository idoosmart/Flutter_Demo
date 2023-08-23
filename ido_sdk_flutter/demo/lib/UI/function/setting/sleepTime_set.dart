// 设置睡眠时间

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

class SleepTime extends StatelessWidget {
  final String navTitle;


  SleepTime({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const SleepTimeContent(),
    );
  }
}


class SleepTimeContent extends StatefulWidget {
  const SleepTimeContent({Key? key}) : super(key: key);

  @override
  State<SleepTimeContent> createState() => _SleepTimeContentState();
}




class _SleepTimeContentState extends State<SleepTimeContent> {

  SleepTimeSetModel _sleepTimeSetModel =  SleepTimeSetModel();

  List<String> leftList = [S.current.connected,S.current.setsleeptimeswitch,
                          S.current.setstarttime,S.current.setendtime,
                          S.current.setsleeptime];


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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_sleepTimeSetModel.sleepTimeFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_sleepTimeSetModel.sleepTimeFlag = true:_sleepTimeSetModel.sleepTimeFlag = false;
        _updateInformation();

      });
    }

    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt] ,_sleepTimeSetModel.startHour.toString(),_sleepTimeSetModel.startMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _sleepTimeSetModel.startHour.toString(),
                      (o)
                  {
                    _sleepTimeSetModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _sleepTimeSetModel.startMinute.toString(),
                      (o)
                  {
                    _sleepTimeSetModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt] ,_sleepTimeSetModel.stopHour.toString(),_sleepTimeSetModel.stopMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _sleepTimeSetModel.stopHour.toString(),
                      (o)
                  {
                    _sleepTimeSetModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _sleepTimeSetModel.stopMinute.toString(),
                      (o)
                  {
                    _sleepTimeSetModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }


          });
    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setSleepPeriod, name: o.toString() , json: _sleepTimeSetModel.toMap()   );
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
    if (tinStr == S.current.setshowlongtime) {   // 显示时长
      //int? type = await _showModalBottomSheet(SelectType.useridType);
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
    else if (tinStr == 'hour') {   //  小时
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





