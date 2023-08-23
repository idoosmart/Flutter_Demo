// 通用二级界面

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'setting/information_set.dart';
import 'setting/target_set.dart';
import 'setting/findPhone_set.dart';
import 'setting/handUpIdentify_set.dart';
import 'setting/preventLost_set.dart';
import 'setting/smartNotfity_set.dart';
import 'setting/currentTime_set.dart';
import 'setting/alarmRemind_set.dart';
import 'setting/longSitRemind_set.dart';
import 'setting/heartRateMode_set.dart';
import 'setting/heartInterval_Set.dart';
import 'setting/noDisturbMode_set.dart';
import 'setting/deviceUnit_set.dart';
import 'setting/bloodPressureCalibration_set.dart';
import 'setting/screenBrightness_set.dart';
import 'setting/gpsInfo_set.dart';
import 'setting/hotStartInfo_set.dart';
import 'setting/sleepTime_set.dart';
import 'setting/menstruationParameter_set.dart';
import 'setting/menstruationRemind_set.dart';
import 'setting/customSetFunc_set.dart';
import 'setting/drinkWaterReminder_set.dart';
import 'setting/heartRateV3Mode_set.dart';
import 'setting/spo2Switch_set.dart';
import 'setting/breatheTrain_set.dart';
import 'setting/walkReminder_set.dart';
import 'setting/pressureSwitch_set.dart';
import 'setting/washHandReminder_set.dart';
import 'setting/smartHeartrate_set.dart';
import 'setting/sleepSwitch_set.dart';
import 'setting/nocturnalTemperatureSwitch_set.dart';
import 'setting/noiseSwitch_set.dart';
import 'setting/fitnessGuidanceSwitch_set.dart';
import 'setting/sunRiseSunSet_set.dart';
import 'setting/weatherDataV3_set.dart';
import 'setting/sportParamSort_set.dart';
import 'setting/schedulerReminder_set.dart';
import 'setting/mainUISort_set.dart';
import 'setting/blueToothContact_set.dart';
import 'setting/appnotifyStatus_set.dart';
import 'setting/medicationRecord_set.dart';
import 'getting/function_get.dart';
import 'control/function_control.dart';

class FunctionGeneral extends StatelessWidget {
  // 数据源
  final List<String> listNames;
  // nav的名字
  final String navTitle;

  const FunctionGeneral(
      {super.key, required this.listNames, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: GeneralContent(listNames, navTitle),
    );
  }

  AppBar createAppBar() {
    if (navTitle == S.current.datamigration) {
      return AppBar(
        title: Text(navTitle),
        actions: [
          FloatingActionButton(
            onPressed: test(),
            child: Text(S.current.selectedfiles),
          )
        ],
      );
    } else {
      return AppBar(
        title: Text(navTitle),
      );
    }
  }

  test() {}
}

class GeneralContent extends StatefulWidget {
  final String typeName;
  final List<String>? listNames;
  const GeneralContent(this.listNames, this.typeName, {super.key});

  @override
  State<StatefulWidget> createState() {
    print('111-----$typeName');
    return _GeneralState(this.listNames, this.typeName);
  }
}

class _GeneralState extends State<GeneralContent> {
  final String typeName;
  final List<String>? listNames;
  _GeneralState(
    this.listNames,
    this.typeName,
  );

  String deviceConnectState =
      IDOBluetoothDeviceStateType.disconnected.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obainConnectState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return Text(
            deviceConnectState,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          );
        } else {
          final fName = listNames![index - 1];
          return ElevatedButton(
              child: Column(
                children: [
                  Text(
                    fName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              onPressed: () {
                jumpDetailCon(typeName!, fName, context);
              });
        }
      },
      itemCount: listNames!.length + 1,
      // itemExtent: 70,
    );
  }

// 定制设置功能
  List<String> customList = [
    S.current.setthenumberofstars,
    S.current.setmessagecontent,
    S.current.setusername,
    S.current.setusernumber,
    S.current.setweathercityname,
    S.current.synciotbutton,
  ];

  // 设置功能 页面跳转
  Map<String, Widget> setJumpMap = {
    S.current.setuserinfo:
        InformationSet(navTitle: S.current.setuserinfo), // 设置个人信息
    S.current.settargetinfo:
        TargetSet(navTitle: S.current.settargetinfo), // 设置目标信息
    S.current.setfindphone:
        FindPhoneSet(navTitle: S.current.setfindphone), // 设置寻找手机
    S.current.sethandupidentify:
        HandUpIdentify(navTitle: S.current.sethandupidentify), // 设置抬腕识别
    S.current.setleftrighthand:
        FindPhoneSet(navTitle: S.current.setleftrighthand), // 设置左右手穿戴
    S.current.setpreventlost:
        PreventLostSet(navTitle: S.current.setpreventlost), // 设置丢失提醒
    S.current.setdisplaymode:
        PreventLostSet(navTitle: S.current.setdisplaymode), // 设置显示模式
    S.current.setsmartnotfity:
        SmartNotfitySet(navTitle: S.current.setsmartnotfity), // 设置v2智能提醒
    S.current.setcurrenttime:
        CurrentTimeSet(navTitle: S.current.setcurrenttime), // 设置当前时间
    S.current.setalarmremind:
        AlarmRemindSet(navTitle: S.current.setalarmremind), // 设置闹钟提醒
    S.current.setlongsitremind:
        LongSitRemindSet(navTitle: S.current.setlongsitremind), // 设置久坐提醒
    S.current.setweatherforecast:
        FindPhoneSet(navTitle: S.current.setweatherforecast), // 设置v2天气预报
    S.current.setheartratemode:
        HeartRateMode(navTitle: S.current.setheartratemode), // 设置v2心率模式
    S.current.setheartrateinterval:
        HeartIntervalSet(navTitle: S.current.setheartrateinterval), // 设置心率区间
    S.current.setnodisturbmode:
        NoDisturbModeSet(navTitle: S.current.setnodisturbmode), // 设置勿扰模式
    S.current.setdeviceunit:
        DeviceUnitSet(navTitle: S.current.setdeviceunit), // 设置设备单位
    S.current.setonekeysos:
        FindPhoneSet(navTitle: S.current.setonekeysos), // 设置一键呼叫
    S.current.setshortcutmode:
        PreventLostSet(navTitle: S.current.setshortcutmode), // 设置快捷方式
    S.current.setbloodpressurecalibration: BloodPressureCalibration(
        navTitle: S.current.setbloodpressurecalibration), // 设置血压校准
    S.current.setsportshortcut:
        SmartNotfitySet(navTitle: S.current.setsportshortcut), // 设置v2运动快捷
    S.current.setscreenbrightness:
        ScreenBrightness(navTitle: S.current.setscreenbrightness), // 设置屏幕亮度
    S.current.setmusicopenoff:
        FindPhoneSet(navTitle: S.current.setmusicopenoff), // 设置音乐开关
    S.current.setgpsinfo: GpsInfo(navTitle: S.current.setgpsinfo), // 设置GPS信息
    S.current.sethotstartinfo:
        HotStartInfo(navTitle: S.current.sethotstartinfo), // 设置启动参数
    S.current.setdialparameters: BloodPressureCalibration(
        navTitle: S.current.setdialparameters), // 设置表盘参数
    S.current.setsleeptime:
        SleepTime(navTitle: S.current.setsleeptime), // 设置睡眠时间
    S.current.setmenstruationparameter: MenstruationParameter(
        navTitle: S.current.setmenstruationparameter), // 设置经期参数
    S.current.setmenstruationremind:
        MenstruationRemind(navTitle: S.current.setmenstruationremind), // 设置经期提醒
    S.current.customsetfunc: CustomSetFunc(listNames: [
      S.current.setthenumberofstars,
      S.current.setmessagecontent,
      S.current.setusername,
      S.current.setusernumber,
      S.current.setweathercityname,
      S.current.synciotbutton,
    ], navTitle: S.current.customsetfunc), // 定制设置功能
    S.current.sendpromptmessage:
        CustomContentSet(navTitle: S.current.sendpromptmessage), // 发送提示信息
    S.current.setdrinkwaterreminder: DrinkWaterReminderSet(
        navTitle: S.current.setdrinkwaterreminder), // 设置喝水提醒
    S.current.setv3heartratemode:
        HeartRateV3ModeSet(navTitle: S.current.setv3heartratemode), // 设置v3心率模式
    S.current.setsportidentifyswitch:
        SmartNotfitySet(navTitle: S.current.setsportidentifyswitch), // 设置运动识别
    S.current.setspo2switch: Spo2Switch(
      navTitle: S.current.setspo2switch,
    ), // 设置血氧开关
    S.current.setbreathetrain: BreatheTrainSet(
      navTitle: S.current.setbreathetrain,
    ), // 设置呼吸训练
    S.current.setwalkreminder: WalkReminderSet(
      navTitle: S.current.setwalkreminder,
    ), // 设置走动提醒
    S.current.setpressureswitch: PressureSwitchSet(
      navTitle: S.current.setpressureswitch,
    ), // 设置压力开关
    S.current.setwashhandreminder: WashHandReminderSet(
      navTitle: S.current.setwashhandreminder,
    ), // 设置洗手提醒
    S.current.setsmartheartrate: SmartHeartRate(
      navTitle: S.current.setsmartheartrate,
    ), // 设置智能心率
    S.current.setsleepswitch:
        SleepSwitchSet(navTitle: S.current.setsleepswitch), // 科学睡眠开关
    S.current.setnocturnaltemperatureswitch: NocturnalTemperatureSwitchSet(
      navTitle: S.current.setnocturnaltemperatureswitch,
    ), // 夜间体温开关
    S.current.setnoiseswitch: NoiseSwitchSet(
      navTitle: S.current.setnoiseswitch,
    ), // 环境音量的开关
    S.current.fitnessguidanceswitch: FitnessGuidanceSwitchSet(
      navTitle: S.current.fitnessguidanceswitch,
    ), // 健身指导开关
    S.current.sunrisesunsettime: SunRiseSunSet(
      navTitle: S.current.sunrisesunsettime,
    ), //日落日出时间
    S.current.setV3weatherdata:
        WeatherDataV3Set(navTitle: S.current.setV3weatherdata), //设置v3天气数据
    S.current.setsportparamsort: SportParamSort(
      navTitle: S.current.setsportparamsort,
    ), // 运动子项数据排列
    S.current.setschedulereminder: SchedulerReminderSet(
      navTitle: S.current.setschedulereminder,
    ), //设置日程提醒
    S.current.mainUISort: MainUISortSet(
      navTitle: S.current.mainUISort,
    ), //主界面控件排序
    S.current.setbulecontact: BlueToothContactSet(
      navTitle: S.current.setbulecontact,
    ), //设置蓝牙联系人
    S.current.setappnotifystatus: AppNotifyStatusSet(
      navTitle: S.current.setappnotifystatus,
    ), //设置APP通知状态
    S.current.setUpMedicationRecord: MedicationRecordSet(
      navTitle: S.current.setUpMedicationRecord,
    ), //设置服药记录
    S.current.syncfunction: MedicationRecordSet(
      navTitle: S.current.setUpMedicationRecord,
    ), //
  };

  jumpDetailCon(String typeName, String conName, BuildContext context) {
    print('jumpDetailCon = ${typeName}==${conName}');

    if (typeName == S.current.setfunction) {
      // 设置功能
      final nWidgets = setJumpMap[conName];
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => nWidgets!));
    } else if (typeName == S.current.getfunction) {
      // 获取功能
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FunctionGet(
                    navTitle: conName,
                  )));
    } else if (typeName == S.current.controlfunction) {
      // 控制功能
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FunctionControl(
                    navTitle: conName,
                  )));
    }else if (typeName == S.current.syncfunction) {
      // 控制功能
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FunctionControl(
                navTitle: conName,
              )));
    }
  }

  void _updateInformation() {
    setState(() {
      //_counter++;
    });
  }

  //获取连接状态
  obainConnectState() {
    Future<IDOBluetoothDeviceStateType> states =
        bluetoothManager.getDeviceState();
    states.then((value) {
      if (value == IDOBluetoothDeviceStateType.connected) {
        deviceConnectState = S.current.connected;
        _updateInformation();
      }
    });
  }
}
