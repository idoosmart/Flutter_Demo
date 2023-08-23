// 生成一些公共控件

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

//import 'package:fluttertoast/fluttertoast.dart';

// 各种组合widget的类型
enum WidType {
  headTextInfo, // 头部文字说明
  textOneText, // 一个text加一个Text
  textTwoText, // 一个text加两个Text
  textThreeText, // 一个text加三个Text
  textTextField, // 一个text加TextField
  textTwoTextField, // 一个text加两个TextField
  textDate, // 一个text加年月日的输入框
  textGender, // 一个text加性别
  buttonInfo, // 一个确定button按钮
  textSwitch, // 一个text加switch
  textSingle, // 单独一个text供单击选择专用
  textSingleShow, // 单独一个text只供显示
  spaceWidget,    // 空格

}

enum SelectType { showTimeType,
                  hourType,
                  minuteType,
                  monthType,
                  dayType,
                  longSitType,
                }


typedef OnClick = void Function(Object o);

class commonUI {
// 通用的widget组合 生产模式
  static Widget productionWidget(
      WidType wType, List<dynamic> plist, OnClick onClick) {
    if (wType == WidType.headTextInfo) {
      return Container(
        height: 30,
        color: Colors.grey,
        child: Text(
          S.current.deviceConnected,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else if (wType == WidType.textOneText) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[1],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {

                onClick(plist[0]);
              },
            ),
          ),
        ]),
      );
    }
    else if (wType == WidType.textTwoText) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[1],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {

                final hstr = plist[plist.length - 2];
                if (hstr == 'month') {
                  onClick(hstr);
                }
                else{
                  onClick('hour');
                }

              },
            ),
          ),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[2],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {
                final hstr = plist.last;
                if (hstr == 'day') {
                  onClick(hstr);
                }
                else{
                  onClick('minute');
                }

              },
            ),
          ),
        ]),
      );
    }
    else if (wType == WidType.textThreeText){
      return Padding(
        padding:
        const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[1],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {
                onClick('hour');
              },
            ),
          ),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[2],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {
                onClick('minute');
              },
            ),
          ),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[2],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {
                onClick('second');
              },
            ),
          ),
        ]),
      );

    }
    else if (wType == WidType.textTextField) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              //autofocus: true,
              //controller: _titleTxt,
              decoration: InputDecoration(hintText: plist[1]),
              keyboardType: plist.length == 3?TextInputType.text:TextInputType.number,

              onChanged: (string) {
                print("onChanged $string");
                onClick(string);

              },
            ),
          ),
        ]),
      );
    } else if (wType == WidType.textTwoTextField) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: plist[1]),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: plist[2]),
              keyboardType: TextInputType.number,
            ),
          ),
        ]),
      );
    } else if (wType == WidType.textGender) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          const SizedBox(width: 40),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    plist[1] == '1' ? Colors.blue : Colors.grey)),
            child: Text(S.current.man),
            onPressed: () {
              if (plist[1] != '1') {
                onClick('1');
              }
            },
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    plist[1] == '0' ? Colors.blue : Colors.grey)),
            child: Text(S.current.woman),
            onPressed: () {
              if (plist[1] != '0') {
                onClick('0');
              }
            },
          ),
        ]),
      );
    } else if (wType == WidType.textDate) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: Listener(
              child: Container(
                height: 48,
                alignment: Alignment.center, //卡片内文字居中 ,
                child: Text(
                  plist[1],
                  textAlign: TextAlign.center,
                ),
              ),
              onPointerUp: (event) {
                //dealwithPointerUp(plist[0]);
                onClick(plist[0]);
              },
            ),
          ),
        ]),
      );
    } else if (wType == WidType.buttonInfo) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: ElevatedButton(
          child: Text(plist[0]),
          onPressed: () {
            print('========');

            onClick(plist[0]);
          },
        ),
      );
    } else if (wType == WidType.textSwitch) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(children: [
          Text(plist[0]),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Switch(
                  value: (plist[1] == 'true') ? true : false,
                  onChanged: (value) {
                    print('-----${value.toString()}');
                    onClick(value);
                  }),
            ),
          ),
        ]),
      );
    } else if (wType == WidType.textSingle) {
      return Listener(
        child: Container(
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(
            plist[0],
            style: TextStyle(
                color: plist[1] ? Colors.red : Colors.black,
                fontSize: 18),
          ),
        ),
        onPointerUp: (e) {
          onClick(plist[0]);
        },
      );
    } else if (wType == WidType.textSingleShow) {
      return Container(
        //height: 35,
        alignment: Alignment.centerLeft,
        child: Text(
          plist[0],
          style: const TextStyle(
              fontSize: 17),
        ),
      );
    }
    else if (wType == WidType.spaceWidget) {
      return Container(
        height: 20,
        color: Colors.grey,
      );
    }

    return const Text("");
  }



// 生成相对应的内容
 static List<String> obainCellTextString(SelectType type)
  {
    List<String> list = [];

    if (type == SelectType.showTimeType)
    {
      for(int i= 0;i<=10;i++)
      {
        list.add(i.toString());
      }
    }
    else if (type == SelectType.hourType)
    {
      for(int i= 0;i<=23;i++)
      {
        list.add(i.toString());
      }
    }
    else if (type == SelectType.minuteType)
    {
      for(int i= 0;i<=59;i++)
      {
        list.add(i.toString());
      }
    }
    else if (type == SelectType.monthType)
    {
      for(int i = 1;i<=12;i++)
      {
        list.add(i.toString());
      }
    }
    else if (type == SelectType.dayType)
    {
      for(int i = 1;i<=30;i++)
      {
        list.add(i.toString());
      }
    }
    else if (type == SelectType.longSitType)
    {
      for(int i = 15;i<=240;i+=15)
      {
        list.add(i.toString());
      }


    }



    return list;
  }


}



