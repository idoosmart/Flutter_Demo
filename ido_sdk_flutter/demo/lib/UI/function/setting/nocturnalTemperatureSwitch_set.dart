// 夜间体温开关


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


class NocturnalTemperatureSwitchSet extends StatelessWidget {
  final String navTitle;


  const NocturnalTemperatureSwitchSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const NocturnalTemperatureSwitchContent(),
    );
  }
}


class NocturnalTemperatureSwitchContent extends StatefulWidget {
  const NocturnalTemperatureSwitchContent({Key? key}) : super(key: key);

  @override
  State<NocturnalTemperatureSwitchContent> createState() => _NocturnalTemperatureSwitchContentState();
}

class _NocturnalTemperatureSwitchContentState extends State<NocturnalTemperatureSwitchContent> {

  NocturnalTemperatureSwitchSetModel _nocturnalTemperatureSwitchModel = NocturnalTemperatureSwitchSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setnocturnaltemperatureswitch,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.temperatureunit,
    S.current.setup,
  ];


  List<String> tempUnitList = [S.current.invalid,S.current.Celsius,S.current.Fahrenheit,];



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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _nocturnalTemperatureSwitchModel.nocturnalTemperatureSwitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_nocturnalTemperatureSwitchModel.nocturnalTemperatureSwitchFlag = true:_nocturnalTemperatureSwitchModel.nocturnalTemperatureSwitchFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_nocturnalTemperatureSwitchModel.startHour.toString(),_nocturnalTemperatureSwitchModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _nocturnalTemperatureSwitchModel.startHour.toString(),
                      (o)
                  {
                    _nocturnalTemperatureSwitchModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _nocturnalTemperatureSwitchModel.startMinute.toString(),
                      (o)
                  {
                    _nocturnalTemperatureSwitchModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_nocturnalTemperatureSwitchModel.stopHour.toString(),_nocturnalTemperatureSwitchModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _nocturnalTemperatureSwitchModel.stopHour.toString(),
                      (o)
                  {
                    _nocturnalTemperatureSwitchModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _nocturnalTemperatureSwitchModel.stopMinute.toString(),
                      (o)
                  {
                    _nocturnalTemperatureSwitchModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 4){
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],tempUnitList[_nocturnalTemperatureSwitchModel.temperatureUnit] ], (o) {
        dealwithPointerUp(leftList[tInt], tempUnitList[_nocturnalTemperatureSwitchModel.temperatureUnit], (o) {
          _nocturnalTemperatureSwitchModel.temperatureUnit = int.parse(o.toString());
          _updateInformation();
        });
      });

    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setTemperatureSwitch, name: o.toString(), json: _nocturnalTemperatureSwitchModel.toMap()   );
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
    else if (tinStr == S.current.temperatureunit){    // 温度单位

      Pickers.showSinglePicker(
        context,
        data: tempUnitList,
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(position);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );

    }


  }


}





