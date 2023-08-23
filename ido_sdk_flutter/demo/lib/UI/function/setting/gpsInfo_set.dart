// 设置GPS信息

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


class GpsInfo extends StatelessWidget {
  final String navTitle;


  GpsInfo({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const GpsInfoContent(),
    );
  }
}


class GpsInfoContent extends StatefulWidget {
  const GpsInfoContent({Key? key}) : super(key: key);

  @override
  State<GpsInfoContent> createState() => GpsInfoContentState();
}




class GpsInfoContentState extends State<GpsInfoContent> {

  GpsInfoSetModel _gpsInfoModel =  GpsInfoSetModel();


  List<String> leftList = [S.current.connected,S.current.startupmode,
                          S.current.operationmode, S.current.positioningcycle,
                          S.current.positioningmode, S.current.setGPSconfigurationinformation,];


  Map<String,List<String>> paraMap = {S.current.startupmode:[S.current.invalid,S.current.coldstart,S.current.hotstart],
                                      S.current.operationmode:[S.current.invalid,S.current.normal,S.current.lowpower,S.current.balance,S.current.pps1],
                                      S.current.positioningmode:[S.current.invalid,S.current.GPS,S.current.GLONASS,S.current.GPSGLONASS]
                                    };



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
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setGpsConfig, name: o.toString(), json: _gpsInfoModel.toMap()   );
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
    else  {
      String secStr = '';
      List<String> dataList = [];
      if (leftList[tInt] == S.current.startupmode) {
        dataList = paraMap[leftList[tInt]]!;
        secStr = dataList[_gpsInfoModel.startMode];
      }  
      else if (leftList[tInt] == S.current.operationmode){
        dataList = paraMap[leftList[tInt]]!;
        secStr = dataList[_gpsInfoModel.operateMode];
      }
      else if (leftList[tInt] == S.current.positioningcycle){
        dataList = obainCellTextString();
        secStr = _gpsInfoModel.locationCycle.toString();
      }
      else if (leftList[tInt] == S.current.positioningmode){
        dataList = paraMap[leftList[tInt]]!;
        secStr = dataList[_gpsInfoModel.locationMode];
      }
      
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],secStr], (o) { 
         dealwithPointerUp(leftList[tInt], secStr, dataList, (o) {
           if (leftList[tInt] == S.current.startupmode) {
             _gpsInfoModel.startMode = int.parse(o.toString());
           }
           else if (leftList[tInt] == S.current.operationmode){
             _gpsInfoModel.operateMode = int.parse(o.toString());
           }
           else if (leftList[tInt] == S.current.positioningcycle){
             _gpsInfoModel.locationCycle = int.parse(o.toString());
           }
           else if (leftList[tInt] == S.current.positioningmode){
             _gpsInfoModel.locationMode = int.parse(o.toString());
           }
           _updateInformation();
           
         });
        
      
      });
    }

    return const Text('test');
  }



// 生成相对应的内容
  List<String> obainCellTextString() {
    List<String> list = [];
    for (int i = 1000; i <= 10000; i += 1000) {
      list.add(i.toString());
    }
    return list;
  }




  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,List<String> dataList,OnSelect onSelect)
  async {

    //int? type = await _showModalBottomSheet(SelectType.useridType);
    Pickers.showSinglePicker(
      context,
      data:  dataList ,
      selectData: conStr,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        if (tinStr == S.current.positioningcycle) {
          onSelect(p);
        }
        else{
          onSelect(position);
        }

      },
      onChanged: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('数据发生改变：$p');
      },
    );




  }

}





