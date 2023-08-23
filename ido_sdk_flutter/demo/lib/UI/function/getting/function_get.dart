//  获取功能的通用样式

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import 'package:protocol_lib/protocol_lib.dart';
import '../../common/commonTool.dart';


class FunctionGet extends StatelessWidget {
 
  // nav的名字
  final String navTitle;

  const FunctionGet({super.key,  required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(navTitle),
      ),
      body: FunctionGetContent(navTitle),
    );


  }

  
}

class FunctionGetContent extends StatefulWidget {
  final String typeName;
  FunctionGetContent(this.typeName,{super.key});



  @override
  State<StatefulWidget> createState() => _FunctionGetContentState(typeName);



}


class _FunctionGetContentState extends State<FunctionGetContent> {
  final String typeName;
  _FunctionGetContentState(this.typeName);

  // 获取到字符串
  String resultStr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    executeGetCmd(typeName);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return  Text(
            S.current.deviceConnected,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          );
        }
        else if (index == 1) {
          return ElevatedButton(
              child: Column(
                children: [
                  Text(
                    typeName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              onPressed: () { executeGetCmd(typeName); }
          );
        }
        else if (index == 2){

          return  Text(resultStr);
        }


        return const Text('test');
      },
      itemCount: 3,
      // itemExtent: 70,
    );
  }


  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }




Map<String,TestCmd> cmdMap = {
  S.current.getfunctionlist:TestCmd(cmd: CmdEvtType.getFuncTable, name: S.current.getfunctionlist),
  S.current.getMacaddress:TestCmd(cmd: CmdEvtType.getMac, name: S.current.getMacaddress),
  S.current.getdeviceinformation:TestCmd(cmd: CmdEvtType.getDeviceInfo, name: S.current.getdeviceinformation),
  S.current.getRealTimeData:TestCmd(cmd: CmdEvtType.getLiveData, name: S.current.getRealTimeData),
  S.current.getthenumberofactivities:TestCmd(cmd: CmdEvtType.getGpsInfo, name: S.current.getthenumberofactivities),    // 获取活动数量
  S.current.getGPSinformation:TestCmd(cmd: CmdEvtType.getGpsInfo, name: S.current.getGPSinformation),
  S.current.getPressureThresholdinformation:TestCmd(cmd: CmdEvtType.getDeviceInfo, name: S.current.getPressureThresholdinformation),   // 获取压力阈值信息
  S.current.getnotificationstatus:TestCmd(cmd: CmdEvtType.getNoticeStatus, name: S.current.getnotificationstatus),
  S.current.getversioninformation:TestCmd(cmd: CmdEvtType.getVersionInfo, name: S.current.getversioninformation),
  S.current.getthenumberofstars:TestCmd(cmd: CmdEvtType.getDeviceInfo, name: S.current.getthenumberofstars),  // 获取星星个数
  S.current.getotaauthinformation:TestCmd(cmd: CmdEvtType.getEncryptedCode, name: S.current.getotaauthinformation),  // 获取授权信息
  S.current.getflashinfo:TestCmd(cmd: CmdEvtType.getFlashBinInfo, name: S.current.getflashinfo),
  S.current.getbatteryinfo:TestCmd(cmd: CmdEvtType.getBatteryInfo, name: S.current.getbatteryinfo),
  S.current.getdefaultlanguage:TestCmd(cmd: CmdEvtType.getBatteryInfo, name: S.current.getdefaultlanguage), // 获取默认语言
  S.current.getmenulist:TestCmd(cmd: CmdEvtType.getMenuList, name: S.current.getmenulist),
  S.current.getdefaultsporttype:TestCmd(cmd: CmdEvtType.getDefaultSportType, name: S.current.getdefaultsporttype),
  S.current.geterrorlogstate:TestCmd(cmd: CmdEvtType.getErrorRecord, name: S.current.geterrorlogstate),
  S.current.getv3alarmsinfo:TestCmd(cmd: CmdEvtType.getAlarmV3, name: S.current.getv3alarmsinfo),
  S.current.getv3heartratemode:TestCmd(cmd: CmdEvtType.getHeartRateMode, name: S.current.getv3heartratemode),
  S.current.getbluemtuinfo:TestCmd(cmd: CmdEvtType.getMtuInfo, name: S.current.getbluemtuinfo),
  S.current.getoverheatlog:TestCmd(cmd: CmdEvtType.getMtuInfo, name: S.current.getoverheatlog),  // 获取过热日志
  S.current.getdevicebatterylog:TestCmd(cmd: CmdEvtType.getDeviceLogState, name: S.current.getdevicebatterylog), // 电池日志
  S.current.getnotdisturbmode:TestCmd(cmd: CmdEvtType.getNotDisturbStatus, name: S.current.getnotdisturbmode),
  S.current.getencryptedcode:TestCmd(cmd: CmdEvtType.getEncryptedCode, name: S.current.getencryptedcode),  // 加密数据
  S.current.gettargetinfo:TestCmd(cmd: CmdEvtType.getBatteryInfo, name: S.current.gettargetinfo),  // 获取目标设置值
  // S.current.getwalkreminder:TestCmd(cmd: CmdEvtType.getDeviceInfo, name: S.current.getwalkreminder),
  S.current.gethealthswitchstate:TestCmd(cmd: CmdEvtType.getAllHealthSwitchState, name: S.current.gethealthswitchstate),
  S.current.getmainuisort:TestCmd(cmd: CmdEvtType.getMainSportGoal, name: S.current.getmainuisort),
  S.current.getschedulereminder:TestCmd(cmd: CmdEvtType.getBatteryInfo, name: S.current.getschedulereminder),  // 获取日程提醒
  // S.current.getV3notificationstatus:TestCmd(cmd: CmdEvtType., name: S.current.getV3notificationstatus),  // 获取v3通知状态
  S.current.getsportsort:TestCmd(cmd: CmdEvtType.getSportTypeV3, name: S.current.getsportsort),  // 获取运动排序
  S.current.obtainTheLevel3VersionNumber:TestCmd(cmd: CmdEvtType.getFirmwareBtVersion, name: S.current.obtainTheLevel3VersionNumber),

};






/// 执行相关的获取指令
  executeGetCmd(String tstr) {

    TestCmd? cmd = cmdMap[tstr];
    if (cmd == Null) {
      print('没有找到相关的类型');
    }
    else{
      TestCmd e = cmd!;
      libManager.send(evt: e.cmd, json: jsonEncode(e.json ?? {})).listen((res) {
        debugPrint(
            '${e.name} evtType:${e.cmd.evtType} code:${res.code} json: ${res.json ?? 'NULL'}');

        resultStr = res.json!;
        _updateInformation();

      });
    }

  }

}








