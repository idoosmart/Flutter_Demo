// 设置屏幕亮度

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


class ScreenBrightness extends StatelessWidget {
  final String navTitle;


  ScreenBrightness({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const ScreenBrightnessContent(),
    );
  }
}


class ScreenBrightnessContent extends StatefulWidget {
  const ScreenBrightnessContent({Key? key}) : super(key: key);

  @override
  State<ScreenBrightnessContent> createState() => _ScreenBrightnessContentState();
}




class _ScreenBrightnessContentState extends State<ScreenBrightnessContent> {

  ScreenBrightnessSetModel _screenBrightModel =  ScreenBrightnessSetModel();


  List<String> paList = [S.current.connected,
                         S.current.screenbrightnesslevel,
                          S.current.setismanualswitch,
                          S.current.setscreenmode,
                          S.current.setstarttime,
                          S.current.setendtime,
                          S.current.nightbrightnesslevel,
                          S.current.showinterval,
                          S.current.setscreenbrightness,];

  List<String> modeList = [S.current.turnoffautotune,
                          S.current.useambientlightsensors,
                          S.current.autobrightnessatnight,
                          S.current.settimefornightdimming,];



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

      itemCount: paList.length,
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
      return commonUI.productionWidget(WidType.textOneText, [paList[tInt], _screenBrightModel.screenBrightnessLevel.toString()],
              (o) {
                dealwithPointerUp(paList[tInt], _screenBrightModel.screenBrightnessLevel.toString(), (o) {
                  _screenBrightModel.screenBrightnessLevel = int.parse(o.toString());
                  _updateInformation();
                });

          });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textSwitch, [paList[tInt],_screenBrightModel.userAdjustFlag.toString()],
              (o) {
                String sValue = o.toString();
                sValue == 'true'?_screenBrightModel.userAdjustFlag = true:_screenBrightModel.userAdjustFlag = false;
                _updateInformation();

          }
      );
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textOneText, [paList[tInt], modeList[_screenBrightModel.screenBrightnessMode] ], (o) {
        dealwithPointerUp(paList[tInt], modeList[_screenBrightModel.screenBrightnessMode], (o) {
          _screenBrightModel.screenBrightnessMode = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textTwoText, [paList[tInt],_screenBrightModel.startHour.toString(),_screenBrightModel.startMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _screenBrightModel.startHour.toString(),
                      (o)
                  {
                    _screenBrightModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _screenBrightModel.startMinute.toString(),
                      (o)
                  {
                    _screenBrightModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textTwoText, [paList[tInt],_screenBrightModel.stopHour.toString(),_screenBrightModel.stopMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _screenBrightModel.stopHour.toString(),
                      (o)
                  {
                    _screenBrightModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _screenBrightModel.stopMinute.toString(),
                      (o)
                  {
                    _screenBrightModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textOneText, [paList[tInt],_screenBrightModel.nightBrightnessLevel.toString()],
              (o) {
        dealwithPointerUp(paList[tInt], _screenBrightModel.nightBrightnessLevel.toString(), (o) {
          _screenBrightModel.nightBrightnessLevel = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 7) {   // 显示间隔
      return commonUI.productionWidget(WidType.textOneText, [paList[tInt],_screenBrightModel.showInterval.toString()],
              (o) {
         dealwithPointerUp(paList[tInt], _screenBrightModel.showInterval.toString(),
                 (o) {
                    _screenBrightModel.showInterval = int.parse(o.toString());
                    _updateInformation();
                 });
      });
    }
    else if (tInt == 8) {
      return commonUI.productionWidget(WidType.buttonInfo, [paList[tInt]], (o) {
        print('object=====');

        TestCmd e = TestCmd(cmd: CmdEvtType.setScreenBrightness, name: o.toString() , json: _screenBrightModel.toMap()   );
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


  List<String> obainSbCellTextString()
  {
    List<String> rlist = [];
    for(int i=1;i<=100;i++){
      rlist.add(i.toString());
    }
    return rlist;
  }


  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == S.current.showinterval) {   // 显示间隔
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
    else if (tinStr == S.current.screenbrightnesslevel || tinStr == S.current.nightbrightnesslevel) {    // 屏幕亮度等级     夜间亮度级别
      Pickers.showSinglePicker(
        context,
        data: obainSbCellTextString(),
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
    else if (tinStr == S.current.setscreenmode){  // 设置亮度模式
      Pickers.showSinglePicker(
        context,
        data: modeList,
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





