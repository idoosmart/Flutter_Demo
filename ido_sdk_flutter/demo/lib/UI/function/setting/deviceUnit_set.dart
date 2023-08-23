// 设置设备单位

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

class DeviceUnitSet extends StatelessWidget {
  final String navTitle;


  const DeviceUnitSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const DeviceUnitContent(),
    );
  }
}


class DeviceUnitContent extends StatefulWidget {
  const DeviceUnitContent({Key? key}) : super(key: key);

  @override
  State<DeviceUnitContent> createState() => _DeviceUnitContentState();
}

class _DeviceUnitContentState extends State<DeviceUnitContent> {

  DeviceUnitSetModel _deviceUnitModel = DeviceUnitSetModel();

  List<String> leftList = [S.current.connected,
    S.current.distanceunit,
    S.current.weightunit,
    S.current.temperatureunit,
    S.current.currentlanguage,
    S.current.walkingsteplength,
    S.current.runningsteplength,
    S.current.gpsstridecalibration,
    S.current.timeformat,
    S.current.weekstart,
    S.current.calorieunit,
    S.current.swimpoolunit,
    S.current.cyclingunit,
    S.current.walkrununit,
    S.current.setdeviceunit,
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
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setUnit, name: o.toString(), json: _deviceUnitModel.toMap()   );
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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],obainSelectStrforTstr(leftList[tInt])],
              (o) {
            dealwithPointerUp(leftList[tInt], obainSelectStrforTstr(leftList[tInt]), (o)
            {
              executeSelectContentStr(leftList[tInt], int.parse(o.toString()) );
              _updateInformation();
            });
          });
    }



    return const Text('test');
  }


  // 生成相对应的内容
  List<String> obainCellTextString(String typeStr) {

    Map<String,List<String>> paraMap = {
      // 距离单位
      S.current.distanceunit:[S.current.invalid,S.current.km,S.current.mi],
      // 体重单位
      S.current.weightunit:[S.current.invalid,S.current.kg,S.current.lb,S.current.st],
      // 温度单位
      S.current.temperatureunit:[S.current.invalid,S.current.Celsius,S.current.Fahrenheit,],
      // 当前语言
      S.current.currentlanguage:[S.current.invalid,S.current.chinese,S.current.english,
        S.current.french,S.current.german,S.current.italian,
        S.current.spanish,S.current.japanese,S.current.polish,
        S.current.czech,S.current.romania,S.current.lithuanian,
        S.current.dutch,S.current.slovenia,S.current.hungarian,
        S.current.russian,S.current.ukrainian,S.current.slovak,
        S.current.korean,S.current.hindi,S.current.portuguese,
        S.current.turkey,S.current.vietnamese,S.current.burmese,
        S.current.filipino,S.current.traditionalchinese,S.current.greek,
        S.current.arabic,S.current.sweden,S.current.finland,
        S.current.persia,S.current.norwegian
      ],
      // 走路步长
      // S.current.walkingsteplength:obainCellTextString(),
      // S.current.runningsteplength:[],
      // GPS 步幅校准
      S.current.gpsstridecalibration:[S.current.invalid,S.current.open,S.current.off,],
      // 时间格式
      S.current.timeformat:[S.current.invalid,S.current.hours24,S.current.hours12,],
      // 周开始
      S.current.weekstart:[S.current.invalid,S.current.monday,S.current.tuesday,
        S.current.wednesday,S.current.thursday,S.current.friday,
        S.current.saturday,S.current.sunday,],
      // 卡路里单位
      S.current.calorieunit:[S.current.invalid,S.current.kilocalorie,S.current.calories,S.current.kilojoules],
      // 泳池单位
      S.current.swimpoolunit:[S.current.invalid,S.current.meter,S.current.yard,],
      // 骑行单位
      S.current.cyclingunit:[S.current.invalid,S.current.km,S.current.miles,],
      // 跑步单位
      S.current.walkrununit:[S.current.invalid,S.current.km,S.current.miles,],
    };
    if (typeStr == S.current.walkingsteplength || typeStr == S.current.runningsteplength)
    {
      List<String> list = [];
      for (int i = 1; i <= 100; i++) {
        list.add(i.toString());
      }
      return list;
    }
    else
    {
      return paraMap[typeStr]!;
    }

  }


  // 获取所选择的标签内容
  String obainSelectStrforTstr(String typeStr)
  {
    List<String> dataList = obainCellTextString(typeStr);
    if (typeStr == S.current.distanceunit)
    {
      return dataList[ _deviceUnitModel.distanceUnit];
    }
    else if (typeStr == S.current.weightunit)
    {
      return dataList[ _deviceUnitModel.weightUnit];
    }
    else if (typeStr == S.current.temperatureunit)
    {
      return dataList[ _deviceUnitModel.temperatureUnit];
    }
    else if (typeStr == S.current.currentlanguage)
    {
      return dataList[ _deviceUnitModel.currentLanguage];
    }
    else if (typeStr == S.current.walkingsteplength)
    {
      return dataList[ _deviceUnitModel.walkStepLength];
    }
    else if (typeStr == S.current.runningsteplength)
    {
      return dataList[ _deviceUnitModel.runningStepLength];
    }
    else if (typeStr == S.current.gpsstridecalibration)
    {
      return dataList[ _deviceUnitModel.gpsStrideCalibration];
    }
    else if (typeStr == S.current.timeformat)
    {
      return dataList[ _deviceUnitModel.timeFormat];
    }
    else if (typeStr == S.current.weekstart)
    {
      return dataList[ _deviceUnitModel.weekStart];
    }
    else if (typeStr == S.current.calorieunit)
    {
      return dataList[ _deviceUnitModel.calorieUnit];
    }
    else if (typeStr == S.current.swimpoolunit)
    {
      return dataList[ _deviceUnitModel.swimPoolUnit];
    }
    else if (typeStr == S.current.cyclingunit)
    {
      return dataList[ _deviceUnitModel.cyclingUnit];
    }
    else if (typeStr == S.current.walkrununit)
    {
      return dataList[ _deviceUnitModel.runUnit];
    }
    else
    {
      return "";
    }

  }


  // 执行所选的内容
  void executeSelectContentStr(String typeStr,int pint)
  {
    if (typeStr == S.current.distanceunit)
    {
       _deviceUnitModel.distanceUnit = pint;
    }
    else if (typeStr == S.current.weightunit)
    {
      _deviceUnitModel.weightUnit = pint;
    }
    else if (typeStr == S.current.temperatureunit)
    {
       _deviceUnitModel.temperatureUnit = pint;
    }
    else if (typeStr == S.current.currentlanguage)
    {
       _deviceUnitModel.currentLanguage = pint;
    }
    else if (typeStr == S.current.walkingsteplength)
    {
       _deviceUnitModel.walkStepLength = pint;
    }
    else if (typeStr == S.current.runningsteplength)
    {
       _deviceUnitModel.runningStepLength = pint;
    }
    else if (typeStr == S.current.gpsstridecalibration)
    {
      _deviceUnitModel.gpsStrideCalibration = pint;
    }
    else if (typeStr == S.current.timeformat)
    {
      _deviceUnitModel.timeFormat = pint;
    }
    else if (typeStr == S.current.weekstart)
    {
      _deviceUnitModel.weekStart = pint;
    }
    else if (typeStr == S.current.calorieunit)
    {
      _deviceUnitModel.calorieUnit = pint;
    }
    else if (typeStr == S.current.swimpoolunit)
    {
      _deviceUnitModel.swimPoolUnit = pint;
    }
    else if (typeStr == S.current.cyclingunit)
    {
      _deviceUnitModel.cyclingUnit = pint;
    }
    else if (typeStr == S.current.walkrununit)
    {
      _deviceUnitModel.runUnit = pint;
    }
    else
    {
      
    }
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
      List<String> dataList = obainCellTextString(tinStr);

      Pickers.showSinglePicker(
        context,
        data: dataList,
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(position);
        },
        onChanged: (p, position) {

        },
      );


  }


}





