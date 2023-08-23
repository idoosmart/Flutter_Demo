// 环境音量的开关

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


class NoiseSwitchSet extends StatelessWidget {
  final String navTitle;


  const NoiseSwitchSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const NoiseSwitchContent(),
    );
  }
}


class NoiseSwitchContent extends StatefulWidget {
  const NoiseSwitchContent({Key? key}) : super(key: key);

  @override
  State<NoiseSwitchContent> createState() => _NoiseSwitchContentState();
}

class _NoiseSwitchContentState extends State<NoiseSwitchContent> {

  NoiseSwitchSetModel _noiseSwitchModel = NoiseSwitchSetModel();


  List<String> leftList = [S.current.connected,
    S.current.alldaynoisemodelswitch,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.thresholdswitch,
    S.current.threshold,
    S.current.setup
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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _noiseSwitchModel.noiseSwitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_noiseSwitchModel.noiseSwitchFlag = true:_noiseSwitchModel.noiseSwitchFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_noiseSwitchModel.startHour.toString(),_noiseSwitchModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _noiseSwitchModel.startHour.toString(),
                      (o)
                  {
                    _noiseSwitchModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _noiseSwitchModel.startMinute.toString(),
                      (o)
                  {
                    _noiseSwitchModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_noiseSwitchModel.stopHour.toString(),_noiseSwitchModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _noiseSwitchModel.stopHour.toString(),
                      (o)
                  {
                    _noiseSwitchModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _noiseSwitchModel.stopMinute.toString(),
                      (o)
                  {
                    _noiseSwitchModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }

    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _noiseSwitchModel.thresholdswitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_noiseSwitchModel.thresholdswitchFlag = true:_noiseSwitchModel.thresholdswitchFlag = false;
        _updateInformation();

      });
    }


    else if (tInt == 5){
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _noiseSwitchModel.threshold.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _noiseSwitchModel.threshold.toString(), (o) {
          _noiseSwitchModel.threshold = int.parse(o.toString());
          _updateInformation();
        });
      });

    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setV3Noise, name: o.toString(), json: _noiseSwitchModel.toMap()   );
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




  List<String> obainThresholdTextString()
  {
    List<String> threList = [];
    for(int i = 1;i <= 100; i++){
      threList.add(i.toString());
    }
    return threList;
  }


  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {

      Pickers.showSinglePicker(
        context,
        data: obainThresholdTextString(),
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





