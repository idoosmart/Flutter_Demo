//  设置v2智能提醒
//  设置v2运动快捷
//  设置运动识别

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

Map<String, List<String>> paraMap = {
                                    S.current.setsmartnotfity:[
                                                                S.current.connected,
                                                                S.current.subswitch,
                                                                S.current.delaytime,
                                                                S.current.callreminder,
                                                                'space',
                                                                S.current.sms,
                                                                S.current.email,
                                                                S.current.wechat,
                                                                S.current.qq,
                                                                S.current.sinaweibo,
                                                                S.current.facebook,
                                                                S.current.twitter,
                                                                'space',
                                                                S.current.whatsapp,
                                                                S.current.messenger,
                                                                S.current.instagram,
                                                                S.current.linkedin,
                                                                S.current.calendarevent,
                                                                S.current.skype,
                                                                S.current.alarmevent,
                                                                S.current.pokeman,
                                                                'space',
                                                                S.current.vkontakte,
                                                                S.current.line,
                                                                S.current.viber,
                                                                S.current.kakaotalk,
                                                                S.current.gmail,
                                                                S.current.outlook,
                                                                S.current.snapchat,
                                                                S.current.telegram,
                                                                'space',
                                                                'chatwork',
                                                                'slack',
                                                                'yahoo mail',
                                                                'tumblr',
                                                                'youtube',
                                                                'yahoo pinterest',
                                                                'keep',
                                                                'tiktok',
                                                                'space'
                                                                'redbus',
                                                                'dailyhunt',
                                                                'hotstar',
                                                                'inshorts',
                                                                'paytm',
                                                                'amazon',
                                                                'flipkart',
                                                                'prime',
                                                                'space'
                                                                'netflix',
                                                                'gpay',
                                                                'phonpe',
                                                                'swiggy',
                                                                'zomato',
                                                                'make my trip',
                                                                'jio tv',
                                                                'microsoft',
                                                                'space',
                                                                'whats app business',
                                                                'noise fit',
                                                                'did not call',
                                                                'matters remind',
                                                                'uber',
                                                                'ola',
                                                                'yt music',
                                                                'google meet',
                                                                'mormaii smart watch',
                                                                'space',
                                                                'technos connect',
                                                                'enioei',
                                                                'aliexpress',
                                                                'shopee',
                                                                'teams',
                                                                '99 taxi',
                                                                'uber eats',
                                                                'lfood',
                                                                'space',
                                                                'rappi',
                                                                'mercado liver',
                                                                'magalu',
                                                                'americanas',
                                                                'yahoo',
                                                                S.current.setnoticeswitchbutton],
                                    S.current.setsportshortcut:[
                                                              S.current.connected,
                                                              S.current.walk,
                                                              S.current.run,
                                                              S.current.ride,
                                                              S.current.hike,
                                                              S.current.swim,
                                                              S.current.mountainclimbing,
                                                              S.current.badminton,
                                                              S.current.other,
                                                              'space',
                                                              S.current.fitness,
                                                              S.current.spinning,
                                                              S.current.ellipticalmachine,
                                                              S.current.treadmill,
                                                              S.current.sitUps,
                                                              S.current.pushUps,
                                                              S.current.dumbbells,
                                                              S.current.weightlifting,
                                                              'space',
                                                              S.current.calisthenics,
                                                              S.current.yoga1,
                                                              S.current.ropeskipping,
                                                              S.current.tabletennis,
                                                              S.current.basketball,
                                                              S.current.football,
                                                              S.current.volleyball,
                                                              S.current.tennis,
                                                              'space',
                                                              S.current.golf,
                                                              S.current.baseball,
                                                              S.current.skiing,
                                                              S.current.rollerskating,
                                                              S.current.dancing,
                                                              S.current.setsportshortcuts],
                                    S.current.setsportidentifyswitch:[
                                                              S.current.connected,
                                                              S.current.walkonoff,
                                                              S.current.runonoff,
                                                              S.current.bicycleonoff,
                                                              S.current.autopauseonoff,
                                                              S.current.endremindonoff,
                                                              S.current.autoellipticalmachineswitch,
                                                              S.current.autorowingmachineswitch,
                                                              S.current.autoswimmingswitch,
                                                              S.current.setsportidentifyswitch,
                                                              ],

};

List<String> paList = paraMap[S.current.setsmartnotfity]!;



class SmartNotfitySet extends StatelessWidget {
  final String navTitle;

  const SmartNotfitySet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    paList = paraMap[navTitle]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: SmartNotfityContent(navTitle: navTitle,),
    );
  }
}

class SmartNotfityContent extends StatefulWidget {
  final String navTitle;

  const SmartNotfityContent({super.key, required this.navTitle});

  @override
  State<SmartNotfityContent> createState() => _SmartNotfityContentState(navTitle: navTitle);
}



class _SmartNotfityContentState extends State<SmartNotfityContent> {
  final String navTitle;
  _SmartNotfityContentState({ required this.navTitle});
  
  var dataModel;
  
  

  SmartNotifitySetModel _smartNotiModel = SmartNotifitySetModel();
  SportRecognitionSetModel _sportRecognitionModel = SportRecognitionSetModel();



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

      itemCount: (paList.length ),
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
      return commonUI.productionWidget(WidType.headTextInfo, [], (o) {});
    } else if (tInt == ( paList.length - 1)) {
      return commonUI.productionWidget(
          WidType.buttonInfo, [paList[tInt] ], (o) {
        executeBleCmd(navTitle);

      });
    } else {
      final leftStr = paList[tInt];
      print('-----${leftStr}');

      if (leftStr == S.current.delaytime) {
        return commonUI.productionWidget(WidType.textOneText,
            [leftStr, _smartNotiModel.delayTime.toString()], (o) { dealwithPointerUp();  });
      }
      else if (leftStr == 'space') {
        return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
      }
      else {
        
        List<dynamic> tlist = [];
        tlist.add(leftStr);
        if (navTitle == S.current.setsportidentifyswitch) {   // 设置运动识别
            if (leftStr == S.current.walkonoff) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_walk == 1).toString());
            }
            else if (leftStr == S.current.runonoff) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_run == 1).toString());
            }
            else if (leftStr == S.current.bicycleonoff) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_bicycle == 1).toString());
            }
            else if (leftStr == S.current.autopauseonoff) {
              tlist.add((_sportRecognitionModel.auto_pause_on_off == 1).toString());
            }
            else if (leftStr == S.current.endremindonoff) {
              tlist.add((_sportRecognitionModel.auto_end_remind_on_off_on_off == 1).toString());
            }
            else if (leftStr == S.current.autoellipticalmachineswitch) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_elliptical == 1).toString());
            }
            else if (leftStr == S.current.autorowingmachineswitch) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_rowing == 1).toString());
            }
            else if (leftStr == S.current.autoswimmingswitch) {
              tlist.add((_sportRecognitionModel.auto_identify_sport_swim == 1).toString());
            }
        }

        else{
          tlist.add('0');
        }

        return commonUI.productionWidget(
            WidType.textSwitch, tlist, (o) {
              int reInt =   o.toString() == 'true'?1:0;
              if (navTitle == S.current.setsportidentifyswitch) {  // 设置运动识别
                if (leftStr == S.current.walkonoff) {
                  _sportRecognitionModel.auto_identify_sport_walk = reInt;
                }
                else if (leftStr == S.current.runonoff) {
                  _sportRecognitionModel.auto_identify_sport_run = reInt;
                }
                else if (leftStr == S.current.bicycleonoff) {
                  _sportRecognitionModel.auto_identify_sport_bicycle = reInt;
                }
                else if (leftStr == S.current.autopauseonoff) {
                  _sportRecognitionModel.auto_pause_on_off = reInt;
                }
                else if (leftStr == S.current.endremindonoff) {
                  _sportRecognitionModel.auto_end_remind_on_off_on_off = reInt;
                }
                else if (leftStr == S.current.autoellipticalmachineswitch) {
                  _sportRecognitionModel.auto_identify_sport_elliptical = reInt;
                }
                else if (leftStr == S.current.autorowingmachineswitch) {
                  _sportRecognitionModel.auto_identify_sport_rowing = reInt;
                }
                else if (leftStr == S.current.autoswimmingswitch) {
                  _sportRecognitionModel.auto_identify_sport_swim = reInt;
                }
              }


              _updateInformation();
        });
      }
    }

    return const Text('test');
  }


  // 执行相关的蓝牙的命令
  void executeBleCmd(String navStr)
  {
    if (navStr == S.current.setsportidentifyswitch) {  // 设置运动识别
      TestCmd e = TestCmd(cmd: CmdEvtType.setActivitySwitch, name: S.current.setsportidentifyswitch, json: _sportRecognitionModel.toMap()   );
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



  }



  // 生成相对应的内容
  List<String> obainCellTextString() {
    List<String> list = [];

    for (int i = 0; i <= 10; i++) {
      list.add(i.toString());
    }

    return list;
  }

//处理相关的弹框需求
  Future<void> dealwithPointerUp() async {
    //int? type = await _showModalBottomSheet(SelectType.useridType);

    Pickers.showSinglePicker(
      context,
      data: obainCellTextString(),
      selectData: _smartNotiModel.delayTime.toString(),
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');

        _smartNotiModel.delayTime = int.parse(p);
        _updateInformation();

      },
      onChanged: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('数据发生改变：$p');
      },
    );
  }
}
