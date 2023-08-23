// 设置血压校准
// 设置表盘参数

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
/// 确定是哪一个页面
String viewTypeStr = '';

class BloodPressureCalibration extends StatelessWidget {
  final String navTitle;


  BloodPressureCalibration({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    viewTypeStr = navTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const BloodPressureCalibrationContent(),
    );
  }
}


class BloodPressureCalibrationContent extends StatefulWidget {
  const BloodPressureCalibrationContent({Key? key}) : super(key: key);

  @override
  State<BloodPressureCalibrationContent> createState() => _BloodPressureCalibrationContentState();
}




class _BloodPressureCalibrationContentState extends State<BloodPressureCalibrationContent> {

  // 血压校准
  BloodPressureCalibrationSetModel _bloodPressureCaliModel =  BloodPressureCalibrationSetModel();
  // 表盘参数
  int dialParameters = 2;


  Map<String,List<String>> paraMap = {S.current.setbloodpressurecalibration:[S.current.connected,S.current.diastolic,
                                                                            S.current.shrinkage, S.current.setbloodpressuredata,],
                                      S.current.setdialparameters:[S.current.connected,S.current.setdialparameters,S.current.setdialparameters],


                                     };
  List<String> leftList = [];



  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    leftList = paraMap[viewTypeStr]!;

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
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [ leftList[tInt] ], (o) {
        // 执行相关的蓝牙命令
        executeBleCmd(viewTypeStr);
      });
    }
    else{
      if (viewTypeStr == S.current.setbloodpressurecalibration) {       // 设置血压校准
        if (tInt == 1) {
          return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_bloodPressureCaliModel.shrinkage.toString()],
                  (o) {
                dealwithPointerUp(leftList[tInt], _bloodPressureCaliModel.shrinkage .toString(),
                        (o) {
                      print('------${o}');
                      _bloodPressureCaliModel.shrinkage = int.parse(o.toString());
                      _updateInformation();
                    });

              });
        }
        else if (tInt == 2) {
          return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_bloodPressureCaliModel.diastolic.toString()],
                  (o) {
                dealwithPointerUp(leftList[tInt], _bloodPressureCaliModel.diastolic.toString(),
                        (o) {
                      print('------${o}');
                      _bloodPressureCaliModel.diastolic = int.parse(o.toString());
                      _updateInformation();
                    });
              }
          );
        }
      }
      else if (viewTypeStr == S.current.setdialparameters){             // 设置表盘参数
        return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], dialParameters.toString()],
                (o) {
              dealwithPointerUp(leftList[tInt], dialParameters.toString(),
                      (o) {
                    print('------${o}');
                    dialParameters = int.parse(o.toString());
                    _updateInformation();
                  });

            });
      }

    }


    return const Text('test');
  }


  // 执行相关的蓝牙命令
  executeBleCmd(String typeString){
    if (typeString == S.current.setbloodpressurecalibration) {
      TestCmd e = TestCmd(cmd: CmdEvtType.setBpCalibration, name: typeString , json: _bloodPressureCaliModel.toMap()   );
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
    }
    else{

    }
  }



// 生成相对应的内容
  List<String> obainCellTextString() {
    List<String> list = [];
    for (int i = 50; i <= 300; i++) {
      list.add(i.toString());
    }
    return list;
  }

  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
      List<String> dataList = [];
      if (viewTypeStr == S.current.setbloodpressurecalibration) {
        dataList = obainCellTextString();
      }
      else if (viewTypeStr == S.current.setdialparameters){
        dataList = commonUI.obainCellTextString(SelectType.showTimeType);
      }

      //int? type = await _showModalBottomSheet(SelectType.useridType);
      Pickers.showSinglePicker(
        context,
        data:  dataList ,
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





