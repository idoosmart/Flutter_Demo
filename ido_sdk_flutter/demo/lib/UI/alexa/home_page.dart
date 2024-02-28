import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:protocol_alexa/protocol_alexa.dart';

import 'web_page.dart';

class AlexaTestHomePage extends StatefulWidget {
  const AlexaTestHomePage({super.key, required this.title, required this.did});

  final String title;
  final int did;

  @override
  State<AlexaTestHomePage> createState() => _AlexaTestHomePageState();
}

class _AlexaTestHomePageState extends State<AlexaTestHomePage> {
  late final alexa = IDOProtocolAlexa();
  String? userCode;
  String? verificationUri;
  LoginState loginState = LoginState.logout;
  String btnTitle = '';
  Color btnColor = Colors.green;
  bool isEnable = false;

  @override
  void initState() {
    loginState = alexa.isLogin ? LoginState.logined : LoginState.logout;
    _refreshUI(loginState);
    alexa.listenLoginStateChanged((state) {
      _refreshUI(state);
    });
    super.initState();
  }

  static int _idx = 0;
  void _testChangeLan() async {
    // //IDOProtocolAlexa.changeLanguage(AlexaLanguageType.usa);
    // return;
    const items = AlexaLanguageType.values;
    if (++_idx >= items.length) {
      _idx = 0;
    }
    for (int i = 0; i < items.length; i++) {
      if (i == _idx) {
        debugPrint('切换语言 ${alexa.currentLanguage} to ${items[i]}');
        IDOProtocolAlexa.changeLanguage(items[i]);
        break;
      }
    }
  }

  void _refreshToken() async {
    final rs = await alexa.refreshToken();
    print('rs = $rs');
  }

  void _refreshUI(LoginState state) {
    String? txt;
    Color? color;
    switch (state) {
      case LoginState.logging:
        txt = '取消登录';
        color = Colors.orange;
        break;
      case LoginState.logined:
        txt = '退出登录';
        color = Colors.red;
        break;
      case LoginState.logout:
        txt = '登录';
        color = Colors.green;
        break;
    }
    setState(() {
      loginState = state;
      btnTitle = txt!;
      btnColor = color!;
      isEnable = state == LoginState.logined;
    });
  }

  void _onClick() {
    switch (loginState) {
      case LoginState.logging:
        _stopLogin();
        break;
      case LoginState.logined:
        _logout();
        break;
      case LoginState.logout:
        _login();
        break;
    }
  }

  void _login() async {
    // 定制 ColorFit_Pro_3_Alpha
    // IDW01、ID208_BT、IDW05、id206、GT01_Pro、GT01_Pro_Beta
    // ：Ks2_Beta
    alexa.authorizeRequest(
            productId: 'Ks2_Beta', //GT01_Pro
            func: (userCode, url) {
              // 打开webView
              debugPrint('$userCode  -  $url');
              this.userCode = userCode;
              verificationUri = url;
              showAlertDialog(context, true);
            })
        .then((rs) {
      if (rs == LoginResponse.successful) {
        debugPrint('登录成功');
      } else {
        debugPrint('登录失败 $rs');
        showAlertDialog(context, false);
      }
    });
  }

  void _stopLogin() {
    alexa.stopLogin();
  }

  void _logout() {
    alexa.logout();
  }

  showAlertDialog(BuildContext context, bool success) {
    final btnList = <Widget>[];
    btnList.add(TextButton(
      child: Text(success ? "取消" : '知道了'),
      onPressed: () {
        Navigator.pop(context);
        _stopLogin();
      },
    ));
    if (success) {
      btnList.add(TextButton(
        child: const Text("拷贝并继续"),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: userCode!));
          Navigator.pop(context);
          jumpDetail(verificationUri!);
        },
      ));
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("提示"),
      content: Text(success ? '你的验证码为：$userCode, 将打开Alexa登录页，是否继续？' : '登录失败'),
      actions: btnList,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  jumpDetail(String url) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WebPageHome(url)));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () => _onClick(),
              style: TextButton.styleFrom(backgroundColor: btnColor),
              child: Text(btnTitle),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}