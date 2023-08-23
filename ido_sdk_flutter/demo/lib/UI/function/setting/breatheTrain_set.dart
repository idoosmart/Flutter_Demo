// 设置呼吸训练

import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


Map<String,List<String>> paraMap =
{ 
  S.current.setbreathetrain:[S.current.connected,S.current.setbreathetrain,S.current.setbreathetrain],
};

List<String> paList = paraMap[S.current.setbreathetrain]!;


typedef OnSelect = void Function(Object o);

class BreatheTrainSet extends StatelessWidget {
  final String navTitle;


  const BreatheTrainSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    paList = paraMap[navTitle]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const BreatheTrainContent(),
    );
  }
}


class BreatheTrainContent extends StatefulWidget {
  const BreatheTrainContent({Key? key}) : super(key: key);

  @override
  State<BreatheTrainContent> createState() => _BreatheTrainContentState();
}

class _BreatheTrainContentState extends State<BreatheTrainContent> {



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


  String tempStr = '1';

  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1) {

      
        return commonUI.productionWidget(WidType.textOneText, [paList[tInt],tempStr], (o) {
          dealwithPointerUp(tempStr, (o) {
            tempStr = o.toString();
            _updateInformation();
          });
        });
      
      
    }
    else {
      return commonUI.productionWidget(WidType.buttonInfo, [paList[tInt]],
              (o) {
            print('object=====${o}');
            TestCmd e = TestCmd(cmd: CmdEvtType.setBreatheTrain, name: o.toString(), json: {'frequency': int.parse(tempStr) }   );
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
  }
  
  
  /// 获取选择的数组
  List<String> obainPriList()
  {
    List<String> reList = [];
    for(int i = 1;i <= 100;i++){
      reList.add(i.toString());
    }
    return reList;
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String conStr,OnSelect onSelect)
  async {

    //int? type = await _showModalBottomSheet(SelectType.useridType);
    Pickers.showSinglePicker(
      context,
      data: obainPriList(),
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