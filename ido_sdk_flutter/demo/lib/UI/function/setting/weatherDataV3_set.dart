// 设置V3天气数据

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


class WeatherDataV3Set extends StatelessWidget {
  final String navTitle;


  const WeatherDataV3Set({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const WeatherDataV3SetContent(),
    );
  }
}


class WeatherDataV3SetContent extends StatefulWidget {
  const WeatherDataV3SetContent({Key? key}) : super(key: key);

  @override
  State<WeatherDataV3SetContent> createState() => _WeatherDataV3SetContentState();
}

class _WeatherDataV3SetContentState extends State<WeatherDataV3SetContent> {

  WeatherDataV3SetModel _weathDataSetModel = WeatherDataV3SetModel();

  List<String> leftList = [S.current.connected,
    S.current.weathertype,
    S.current.currentweather,
    S.current.maxweather,
    S.current.minweather,
    S.current.airquality,
    S.current.Precipitationprobability,
    S.current.humidity,
    S.current.uvintensity,
    S.current.windSpeed,
    S.current.week,
    S.current.monthday,
    S.current.sunrisetime,
    S.current.sunsettime,
    S.current.cityname,
    S.current.setweatherdata,
  ];

  // 天气类型的数组
  List<String> typeList = [S.current.other,S.current.sunnydays,
    S.current.cloudy1,S.current.cloudy2,
    S.current.rain1,S.current.rain2,
    S.current.thunderstorm,S.current.snow,
    S.current.snowrain,S.current.typhoon,
    S.current.sandstorm,S.current.shineatnight,
    S.current.hot,S.current.cold,
    S.current.breezy,S.current.windy,
    S.current.misty,S.current.showers,
    S.current.cloudytoclear,S.current.Nmoon,
    S.current.WXCmoon,S.current.FQmoon,
    S.current.WXGmoon,S.current.Fmoon,
    S.current.WNGmoon,S.current.LQmoon,
    S.current.WNCmoon];

  // 星期
  List<String> weekList = [S.current.monday,S.current.tuesday,
    S.current.wednesday,S.current.thursday,
    S.current.friday,S.current.saturday,
    S.current.sunday,];




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
    else if (tInt == 1) {  // 天气类型
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], typeList[_weathDataSetModel.weathertype] ], (o) {
        dealwithPointerUp(leftList[tInt], typeList[_weathDataSetModel.weathertype], (o) {
          _weathDataSetModel.weathertype = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 2 )  // 当前的温度
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_weathDataSetModel.currentweather.toString()],
              (o) {

              dealwithPointerUp(leftList[tInt], _weathDataSetModel.currentweather.toString(),
                      (o)
                  {
                    _weathDataSetModel.currentweather = int.parse(o.toString());
                    _updateInformation();
                  });


          });
    }
    else if (tInt == 3 ) // 最大温度
    {
      return commonUI.productionWidget(WidType.textOneText, [S.current.currentweather,_weathDataSetModel.maxweather.toString()],
              (o) {

            dealwithPointerUp(leftList[tInt], _weathDataSetModel.maxweather.toString(),
                    (o)
                {
                  _weathDataSetModel.maxweather = int.parse(o.toString());
                  _updateInformation();
                });


          });
    }
    else if (tInt == 4)  // 最小温度
    {
      return commonUI.productionWidget(WidType.textOneText, [S.current.currentweather, _weathDataSetModel.minweather.toString() ], (o) {
        dealwithPointerUp(leftList[tInt],_weathDataSetModel.minweather.toString(), (o) {
          _weathDataSetModel.minweather = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 5)  // 空气质量
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _weathDataSetModel.airquality.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _weathDataSetModel.airquality.toString(), (o) {
          _weathDataSetModel.airquality = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 6)  // 降水概率
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _weathDataSetModel.Precipitationprobability.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _weathDataSetModel.Precipitationprobability.toString(), (o) {
          _weathDataSetModel.Precipitationprobability = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 7)  // 湿度
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _weathDataSetModel.humidity.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _weathDataSetModel.humidity.toString(), (o) {
          _weathDataSetModel.humidity = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 8)  // 紫外线强度
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _weathDataSetModel.uvintensity.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _weathDataSetModel.uvintensity.toString(), (o) {
          _weathDataSetModel.uvintensity = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 9)  // 风速
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _weathDataSetModel.windspeed.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _weathDataSetModel.windspeed.toString(), (o) {
          _weathDataSetModel.windspeed = int.parse(o.toString());
          _updateInformation();
        });
      });
    }

    else if (tInt == 10)  // 星期
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],  weekList[ _weathDataSetModel.week]  ], (o) {
        dealwithPointerUp(leftList[tInt],weekList[ _weathDataSetModel.week], (o) {
          _weathDataSetModel.week = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 11)  // 月日
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt], _weathDataSetModel.month.toString(),_weathDataSetModel.day.toString(),'month','day' ], (o) {
        if (o.toString() == 'month') {
          dealwithPointerUp('month',_weathDataSetModel.month.toString(), (o) {
            _weathDataSetModel.month = int.parse(o.toString());
            _updateInformation();
          });
        }
        else if (o.toString() == 'day'){
          dealwithPointerUp('day',_weathDataSetModel.day.toString(), (o) {
            _weathDataSetModel.day = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    }
    else if(tInt == 12)  // 日出
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt], _weathDataSetModel.sunrisetimeHour.toString(),_weathDataSetModel.sunrisetimeMinute.toString() ], (o) {
        if (o.toString() == 'hour') {
          dealwithPointerUp('hour',_weathDataSetModel.sunrisetimeHour.toString(), (o) {
            _weathDataSetModel.sunrisetimeHour = int.parse(o.toString());
            _updateInformation();
          });
        }
        else if (o.toString() == 'minute'){
          dealwithPointerUp('minute',_weathDataSetModel.sunrisetimeMinute.toString(), (o) {
            _weathDataSetModel.sunrisetimeMinute = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    }
    else if(tInt == 13)  // 日落
      {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt], _weathDataSetModel.sunsettimeHour.toString(),_weathDataSetModel.sunsettimeMinute.toString() ], (o) {
        if (o.toString() == 'hour') {
          dealwithPointerUp('hour',_weathDataSetModel.sunsettimeHour.toString(), (o) {
            _weathDataSetModel.sunsettimeHour = int.parse(o.toString());
            _updateInformation();
          });
        }
        else if (o.toString() == 'minute'){
          dealwithPointerUp('minute',_weathDataSetModel.sunsettimeMinute.toString(), (o) {
            _weathDataSetModel.sunsettimeMinute = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    }
    else if(tInt == 14)  // 城市名称
      {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_weathDataSetModel.cithName ,'1'], (o) { });

    }
    else
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]],
              (o) {
                TestCmd e = TestCmd(cmd: CmdEvtType.setWeatherV3, name: o.toString() , json: _weathDataSetModel.toMap()   );
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


  // 设置目标步数
  List<String>  obainCellTextString(String tStr ) {
    List<String> reList = [];
    if (tStr == S.current.currentweather) {   // 当前的温度    最大温度   最小温度
      for(int i = -50;i <= 60;i++){
        reList.add(i.toString());
      }
    }


    return reList;
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == 'hour') {   //  小时
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.hourType),
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
    else if (tinStr == 'minute') {   //  分钟
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.minuteType),
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
    else if (tinStr == 'month'){   // 月
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.monthType),
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
    else if (tinStr == 'day'){   // 日
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.dayType),
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
    else if(tinStr == S.current.weathertype){  // 天气类型
      Pickers.showSinglePicker(
        context,
        data: typeList,
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(position);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    }
    else if(tinStr == S.current.currentweather){  // 当前的温度
      Pickers.showSinglePicker(
        context,
        data: obainCellTextString(S.current.currentweather),
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
    else if(tinStr == S.current.week){  // 星期
      Pickers.showSinglePicker(
        context,
        data: weekList,
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(position);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );

    }

    else {
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.showTimeType),
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


}






