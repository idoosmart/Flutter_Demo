// 设置血氧开关


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


class Spo2Switch extends StatelessWidget {
  final String navTitle;


  Spo2Switch({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const Spo2SwitchContent(),
    );
  }
}


class Spo2SwitchContent extends StatefulWidget {
  const Spo2SwitchContent({Key? key}) : super(key: key);

  @override
  State<Spo2SwitchContent> createState() => _Spo2SwitchContentState();
}




class _Spo2SwitchContentState extends State<Spo2SwitchContent> {

  Spo2SwitchSetModel _spo2SwitchSetModel =  Spo2SwitchSetModel();

  List<String> leftList = [S.current.connected,S.current.setspo2switch,
    S.current.setstarttime,S.current.setendtime,
    S.current.lowbloodoxygenswitch,S.current.lowbloodoxygenthreshold,
    S.current.setspo2switch];


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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_spo2SwitchSetModel.spo2SwitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_spo2SwitchSetModel.spo2SwitchFlag = true:_spo2SwitchSetModel.spo2SwitchFlag = false;
        _updateInformation();

      });
    }

    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt] ,_spo2SwitchSetModel.startHour.toString(),_spo2SwitchSetModel.startMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _spo2SwitchSetModel.startHour.toString(),
                      (o)
                  {
                    _spo2SwitchSetModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _spo2SwitchSetModel.startMinute.toString(),
                      (o)
                  {
                    _spo2SwitchSetModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt] ,_spo2SwitchSetModel.stopHour.toString(),_spo2SwitchSetModel.stopMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _spo2SwitchSetModel.stopHour.toString(),
                      (o)
                  {
                    _spo2SwitchSetModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _spo2SwitchSetModel.stopMinute.toString(),
                      (o)
                  {
                    _spo2SwitchSetModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 4){
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_spo2SwitchSetModel.lowbloodoxygenswitchFlag.toString() ], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_spo2SwitchSetModel.lowbloodoxygenswitchFlag = true:_spo2SwitchSetModel.lowbloodoxygenswitchFlag = false;
        _updateInformation();
      });
    }
    else if (tInt == 5){
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_spo2SwitchSetModel.lowbloodoxygenthreshold.toString() ], (o) {
        dealwithPointerUp(S.current.setshowlongtime, _spo2SwitchSetModel.lowbloodoxygenthreshold.toString() , (o) {
          _spo2SwitchSetModel.lowbloodoxygenthreshold = int.parse(o.toString()) ;
          _updateInformation();
        });
      });

    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setSpo2Switch, name: o.toString(), json: _spo2SwitchSetModel.toMap()   );
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





