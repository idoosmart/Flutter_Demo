// 设置目标信息
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';

class TargetSet extends StatelessWidget {
  final String navTitle;


  const TargetSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const TargetContent(),
    );
  }
}


class TargetContent extends StatefulWidget {
  const TargetContent({Key? key}) : super(key: key);

  @override
  State<TargetContent> createState() => _TargetContentState();
}

class _TargetContentState extends State<TargetContent> {

  Map<String,dynamic> jsonMap = {
    "calorie":1000,
    "distance":10000,
    "calorie_min":100,
    "calorie_max":666,
    "mid_high_time_goal":600,
    "walk_goal_time":600,
    "time_goal_type":0
  };

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },

      itemCount: 8,
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
      return commonUI.productionWidget(WidType.textTextField, [S.current.setTargetStep,'10000'], (o) { });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textTwoTextField, [S.current.setargetsleep,'8','0'], (o) { });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTextField, [S.current.settargetweight,'60'], (o) { });
    }
    else if (tInt == 4) {

      // todo 没有找到 设置步数睡眠体重
      return commonUI.productionWidget(WidType.buttonInfo, [S.current.settargetstep_sleep_weight], (o) {


      });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textTextField, [S.current.settargetcalorie,'1000'], (o) {
        jsonMap['calorie'] =  int.parse(o.toString());
      });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textTextField, [S.current.settargetdistance,'10000'], (o) {
        jsonMap['distance'] = int.parse(o.toString());
      });
    }
    else if (tInt == 7) {
      return commonUI.productionWidget(WidType.buttonInfo, [S.current.settargetcalorie_distance], (o) {
        TestCmd e = TestCmd(cmd: CmdEvtType.setCalorieDistanceGoal, name: S.current.settargetcalorie_distance, json: jsonMap   );
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




    // else if (tInt == 1) {
    //   return  Padding(
    //     padding: const  EdgeInsets.only(top: 20, bottom: 30),
    //     child: ElevatedButton(
    //       child:  Text(S.current.setuserbutton),
    //       onPressed: () {},
    //     ),
    //   );
    //
    // }



    return const Text('test');
  }

}




