// 设置v2心率模式

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

// 左边文字数组
List<String> leftList = [S.current.connected,S.current.heartratemode,
                          S.current.heartratetimerange,S.current.setstarttime,
                          S.current.setstarttime,S.current.setheartratemodebutton,];
// 心率模式选择框数组
List<String> hrModeList = [S.current.off,S.current.manualmode,
                          S.current.automode,S.current.continuouslymonitor,
                          ];

Map<String,int> modeMap = {S.current.off:85,S.current.manualmode:170,
  S.current.automode:136,S.current.continuouslymonitor:153,};


class HeartRateMode extends StatelessWidget {
  final String navTitle;


  HeartRateMode({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const HeartRateModeContent(),
    );
  }
}


class HeartRateModeContent extends StatefulWidget {
  const HeartRateModeContent({Key? key}) : super(key: key);

  @override
  State<HeartRateModeContent> createState() => _HeartRateModeContentState();
}




class _HeartRateModeContentState extends State<HeartRateModeContent> {

  HeartRateModeSetModel _heartRateModeSetModel = HeartRateModeSetModel();


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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],hrModeList[_heartRateModeSetModel.hrMode]], (o)
      {
        dealwithPointerUp(leftList[tInt], hrModeList[_heartRateModeSetModel.hrMode], (o)
        {
            _heartRateModeSetModel.hrMode = hrModeList.indexOf(o.toString());
            _heartRateModeSetModel.mode = modeMap[o.toString()]!;
            _updateInformation();
        });

      });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_heartRateModeSetModel.hrInteTimeFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_heartRateModeSetModel.hrInteTimeFlag = true:_heartRateModeSetModel.hrInteTimeFlag = false;
        _updateInformation();

      });
    }

    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTwoText, [S.current.setstarttime,_heartRateModeSetModel.startHour.toString(),_heartRateModeSetModel.startMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _heartRateModeSetModel.startHour.toString(),
                      (o)
                  {
                    _heartRateModeSetModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _heartRateModeSetModel.startMinute.toString(),
                      (o)
                  {
                    _heartRateModeSetModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textTwoText, [S.current.setendtime,_heartRateModeSetModel.endHour.toString(),_heartRateModeSetModel.endMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _heartRateModeSetModel.endHour.toString(),
                      (o)
                  {
                    _heartRateModeSetModel.endHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute',  _heartRateModeSetModel.endMinute.toString(),
                      (o)
                  {
                    _heartRateModeSetModel.endMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) {
        print('object=====');
        executeCmd(o.toString());
      });
    }







    return const Text('test');
  }


//
  executeCmd(String typeStr) {


    Map<String,dynamic> jsonMap = _heartRateModeSetModel.toMap();

    TestCmd e =
    TestCmd(cmd: CmdEvtType.setHeartMode, name: typeStr, json: jsonMap);
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
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == S.current.heartratemode) {   // 心率模式
      //int? type = await _showModalBottomSheet(SelectType.useridType);
      Pickers.showSinglePicker(
        context,
        data: hrModeList,
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





