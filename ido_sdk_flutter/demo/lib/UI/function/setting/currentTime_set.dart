// 设置当前时间
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import 'dart:async';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';



const timeout2 = const Duration(seconds: 1); // 秒


class CurrentTimeSet extends StatelessWidget {
  final String navTitle;


  const CurrentTimeSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const CurrentTimeContent(),
    );
  }
}


class CurrentTimeContent extends StatefulWidget {
  const CurrentTimeContent({Key? key}) : super(key: key);

  @override
  State<CurrentTimeContent> createState() => _CurrentTimeContentState();
}

class _CurrentTimeContentState extends State<CurrentTimeContent> {

  Map<String,dynamic> jsonMap = {
  };


  DateTime today = DateTime.now();

  // 定时器
  Timer soundTimer = Timer(timeout2, () { }); // 定义定时器
  
  

  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }


  void startTimer(){
    soundTimer?.cancel(); // 取消定时器
    soundTimer = Timer.periodic(timeout2, (timer) {
      //TODO
      _updateInformation();
      
      print('Timer====');
      

    });
  }


  @override
  Widget build(BuildContext context) {
    // 开启定时器
    startTimer();
    today = DateTime.now();


    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },

      itemCount: 5,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print('dispose');

    soundTimer.cancel();
  }



  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1){
      String str = S.current.currenttime +  today.toString();
      return commonUI.productionWidget(WidType.textSingleShow, [str], (o) { });
    }
    else if (tInt == 2){
      
      print('-weekday---${today.weekday}');
      
      String str = CommonTool.obtainWeekDay(today.weekday);
      return commonUI.productionWidget(WidType.textSingleShow, [str], (o) { });
    }
    else if (tInt == 3){
      String str = today.timeZoneName;
      return commonUI.productionWidget(WidType.textSingleShow, [str], (o) { });
    }
    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.buttonInfo, [S.current.setcurrenttimebutton], (o) {   // 设置当前时间
        print('object=====');
        jsonMap['year'] = today.year;
        jsonMap['monuth'] = today.month;
        jsonMap['day'] = today.day;
        jsonMap['hour'] = today.hour;
        jsonMap['minute'] = today.minute;
        jsonMap['second'] = today.second;
        jsonMap['week'] = today.weekday;
        jsonMap['time_zone'] = 8;

        TestCmd e = TestCmd(cmd: CmdEvtType.setTime, name: S.current.settargetcalorie_distance, json: jsonMap   );
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

}





