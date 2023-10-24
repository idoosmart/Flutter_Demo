part of '../upload_directives.dart';

class _UploadDirectivesAnalysis implements UploadDirectivesAnalysis {
  static String kContentTypeJSON = "application/json";
  static String kContentTypeAudio = "application/octet-stream";
  _FileTool? _fileReceive;
  String? _speechFinishedLastToken;
  StreamSubscription? _subscriptMp3Upload;

  /**< 解析上行流语音文本数据 */
  void parsingTextDirectivesAnalysis(
      {required VoiceReceivedData directives}) async {
    if (directives.modelList == null) {
      logger?.v('setRecognitionState Fail---------');
      libManager
          .send(evt: CmdEvtType.setRecognitionState, json: '{"phone_state":1}')
          .listen((event) {
        logger?.v('setRecognitionState Fail = ${event.toString()}');
      });
    } else if (directives.modelList != null) {
      logger?.v('parsingText directives analysis = ${directives}');
      parsingText(directivesModel: directives);
    }
  }

  void parsingText({required VoiceReceivedData directivesModel}) async {
    List directives = directivesModel.modelList!;

    String contents = "";
    bool isQuestions = false;
    var customFunc;
    var clearBehavior;
    String? audioPlayUrl;
    bool isCaption = false;

    //判断是否存在caption--说明文字
    for (DirectiveModel content in directives) {
      Payload? payload = content.payload;
      String? token = payload?.token;
      Caption? caption = payload?.caption;
      String? captionContent = caption?.content;
      if (token != null && captionContent != null) {
        isCaption = true;
        break;
      }
    }

    _speechFinishedLastToken = null;
    for (DirectiveModel content in directives) {
      Payload? payload = content.payload;
      String? token = payload?.token;
      Header? header = content.header;
      String? name = header?.name;
      String? type = payload?.type;
      AudioItem? audioPlayItem = payload?.audioItem;

      // final dialogRequestId = payload?.dialogRequestId;

      if (token != null) {
        /**< 发送结束指令 */
        setSpeechFinished(token);
      }

      if (name is String && name == "ExpectSpeech") {
        /**< 判断是否疑问句 */
        isQuestions = true;
      } else if (audioPlayItem is Map && audioPlayItem?.stream != null) {
        /**< 判断是否是音乐播放 */
        AudioStream? streamDic = audioPlayItem?.stream;
        if (streamDic?.url != null) {
          audioPlayUrl = streamDic?.url;
          break;
        }
      }

      /**< 抬头显示 */
      if (type == "ListTemplate1") {
        contents = parseTemplateRuntime(map: payload!);
        break;
      } else if (type == "BodyTemplate" && isCaption == false) {
        contents = parseBodyTemplate(map: payload!);
        break;
      }

      if (payload?.clearBehavior != null) {
        clearBehavior = payload?.clearBehavior;
      }
      /**< 截取文本内容 */
      if (contents.length > 0) {
        /**< 截取子文本 */
        String subContents = parseReturnText(map: payload!);
        contents = contents + "\n" + subContents;
      } else {
        /**< 截取文本 */
        contents = parseReturnText(map: payload!);
      }

      /**< 自定义功能 */
      customFunc = parseCustomFunctionality(map: payload);

      /**< 智能家居 */
      if (contents.length == 0 && token != null) {
        if (token.contains("amzn1.as-ct.v1.HomeAutomation")) {
          contents = "OK";
        }
      }
    }

    if (customFunc is Map) {
      if (customFunc.keys.length > 0) {
        /**< 不支持的自定义功能跳过 */
        final func = customFunc["func"];
        if (func != null && func is String && int.parse(func) != 6) {
          /**< 从服务器获取技能 -- 认证需要 */
          ServiceManager().getCustomFunc(sessionId: customFunc["sessionId"]);
          if (int.parse(func) != 7) {
            return;
          }
        }
        /**< 自定义技能不返回疑问句 */
        isQuestions = false;
      }
    }

    /**< 判断是否天气信息 */
    if (parseJsonWeather(arr: directives) && libManager.funTable.alexaSetWeatherV3) {
      if (isQuestions == false) {
        playAudio(path: directivesModel.audioFilePath);
      }
      return;
    }

    if (audioPlayUrl != null && audioPlayUrl!.isNotEmpty) {
      //有音乐url返回
      return;
    }

    if (clearBehavior == "CLEAR_ENQUEUED") {
      contents = "Sorry.Sound loud speaker are not supported on this device.";
    }

    /**< 重启下行流 */
    if (contents.contains("isn't responding.") ||
        contents.contains("reagiert nicht") ||
        contents.contains("ne répond pas") ||
        contents.contains("no responde") ||
        contents.contains("non risponde") ||
        contents.contains("não está respondendo") ||
        contents.contains("が応答していません") ||
        contents.contains("Please try reconnecting your device") ||
        contents.length == 0) {
      logger?.d('is not responding');
      // 创建下行流
      // AlexaClient().createNewDirectives();
    }

    //勿扰模式处理
    if (contents.contains("I won't disturb you") ||
        contents.contains("Do Not Disturb is already enabled")) {
      libManager
          .send(
              evt: CmdEvtType.setVoiceControlUi,
              json: '{"ui_type":2, "operation_type":0, "cmd":0}')
          .listen((event) {
        //发送最后文本给设备
        voiceRecognition(contents, isQuestions, directivesModel.audioFilePath);
      });
    } else if (contents.contains("Do Not Disturb is already turned off") ||
        contents.contains("Do not disturb is now off")) {
      libManager
          .send(
              evt: CmdEvtType.setVoiceControlUi,
              json: '{"ui_type":2, "operation_type":1, "cmd":0}')
          .listen((event) {
        //发送最后文本给设备
        voiceRecognition(contents, isQuestions, directivesModel.audioFilePath);
      });
    } else {
      //发送最后文本给设备
      voiceRecognition(contents, isQuestions, directivesModel.audioFilePath);
    }
  }

  ////**< 发送文本或者语音给设备 */
  void voiceRecognition(String contents, bool question, String? path) {
    /**< 显示文本 */
    if (contents.length > 0) {
      final utf8List = utf8.encode(contents);
      /**< 最多500个字节 */
      if (utf8List.length > 500) {
        contents = contents.substring(0, 500);
      }
      if (AlexaClient().isSmartHomeSkill != null) {
        if (AlexaClient().isSmartHomeSkill == true){
          logger?.v('SmartHomeSkill');
          return;
        }
      }
      int flag_is_continue = 1;
      if (question == false) {
        flag_is_continue = 0;
      }


      final map = {"version":2,
        "flag_is_continue":flag_is_continue,
        "title":"",
        "text_content":contents
      };
      final json = jsonEncode(map);

      logger?.v('voiceRecognition text json = ${json}');

      libManager.send(
          evt: CmdEvtType.setVoiceReplyTxtV3,
          json: json).listen((event) {
        if (question == false) {
          logger?.v('is question, 准备播放音频');
          /**< 音频播放 */
          playAudio(path: path);
        }
      });

    } else {

      final map = {"phone_state":1};
      final json = jsonEncode(map);
      libManager.send(
          evt: CmdEvtType.setRecognitionState, json: json).listen((event) {
        logger?.v('setRecognitionState Fail = ${event.toString()}');
      });
    }
  }

  ////**< 发送结束指令 */
  void setSpeechFinished(String? token) async {
    if (_speechFinishedLastToken != null && _speechFinishedLastToken == token) {
      return;
    }
    _speechFinishedLastToken = token;

    String uploadStreamUniqueID = AlexaClient().messageId;
    final map = {
      "event": {
        "header": {
          "namespace": "SpeechSynthesizer",
          "name": "SpeechFinished",
          "messageId": uploadStreamUniqueID
        },
        "payload": {"token": token}
      }
    };

    ServiceManager()
        .sendEventPart(
            accessToken: Auth().accessToken!,
            dataBody: map.toData(),
            label: 'setSpeechFinished')
        .then((value) {
      logger?.v('setSpeechFinished  = ${value}');
    });
  }

  ////**< 播放语音 */
  void playAudio({String? path}) async {
    if(libManager.funTable.setSupportAppSendVoiceToBle == false){
      logger?.v('功能表 播放语音---> not supportAppSendVoiceToBle');
      return;
    }
    if (path != null) {
      // 播放语音
      _tranFile(path);
    }
  }

  /**< 解析自定义功能 */
  Map parseCustomFunctionality({required Payload map}) {
    Title? title = map.title;
    var textField = map.textField;
    if (title == null || textField == null) {
      return Map();
    }

    logger?.v('parseCustomFunctionality = ${textField}');

    if (textField is String) {
      try {
        textField = json.decode(textField);
      } catch (e) {
        logger?.e(e);
        return Map();
      }
    }
    if (textField is Map) {
      final directive = textField["directive"];
      if (directive is Map) {
        Map directiveMap = {
          "func": directive["type"],
          "type": directive["data"],
          "sessionId": textField["sessionId"]
        };
        return directiveMap;
      }
    }
    return Map();
  }

  ///解析文本
  String parseTemplateRuntime({required Payload map}) {
    String content = "";
    Title? title = map.title;
    String? mainTitle = title?.mainTitle;
    if (mainTitle is String) {
      content = mainTitle;
      List? listItems = map.listItems;
      if (listItems is List) {
        for (final item in listItems) {
          if (item is Map) {
            final leftTextField = item["leftTextField"];
            final rightTextField = item["rightTextField"];
            if (leftTextField is String && rightTextField is String) {
              content = content + "\n" + leftTextField + rightTextField;
            }
          } else {
            return content;
          }
        }
      }
    }
    return content;
  }

  String parseReturnText({required Payload map}) {
    String content = "";
    AudioItem? audioItem = map.audioItem;
    Caption? caption;
    if (audioItem is Map) {
      AudioStream? stream = audioItem?.stream;
      caption = stream?.caption;
    }

    if (caption == null) {
      caption = map.caption;
    }
    if (caption == null) {
      return content;
    }

    String text = caption.content!;
    text = text.replaceAll("WEBVTT", "");
    text = text.replaceAll("\n\n", "\n");
    List arr = text.split("\n");
    String newText = "";
    for (int i = 0; i < arr.length; i++) {
      if (i % 3 == 0) {
        newText = newText + arr[i];
      }
    }
    return newText;
  }

  String parseBodyTemplate({required Payload map}) {
    String content = "";
    Title? title = map.title;
    String? mainTitle = title?.mainTitle;
    String? textField = map.textField;
    if (textField is String) {
      content = mainTitle! + "\n" + textField!;
    }
    return content;
  }

  /**< 获取天气信息 */
  bool parseJsonWeather({required List arr}) {
    if (arr.length <= 0) {
      return false;
    }
    List resultObjs = [];
    for (DirectiveModel dic in arr) {
      Payload? payloadObj = dic?.payload;
      String? payloadType = payloadObj?.type;
      if (payloadType == "WeatherTemplate") {
        //当前的天气
        String? currentWeather = payloadObj?.currentWeather;
        //当前位置名称
        Title? titleObj = payloadObj?.title;
        String? locationName = titleObj?.mainTitle;

        //天气状态
        var todayWeatherState = "";
        Map? currentWeatherIconObj = payloadObj?.currentWeatherIcon;
        if (currentWeatherIconObj != null) {
          todayWeatherState = currentWeatherIconObj["contentDescription"];
        }

        //最高温度
        var maxTemperatureStr = "";
        Map? maxTemperatureObj = payloadObj?.highTemperature;
        if (maxTemperatureObj != null) {
          maxTemperatureStr = maxTemperatureObj["value"];
        }

        //最低温度
        var minTemperatureStr = "";
        Map? minTemperatureObj = payloadObj?.lowTemperature;
        if (minTemperatureObj != null) {
          minTemperatureStr = minTemperatureObj["value"];
        }

        String todayMinMaxWeather = minTemperatureStr + "/" + maxTemperatureStr;

        //未来几天内的天气
        List futureWeathers = [];
        List? weatherForecastObj = payloadObj?.weatherForecast;
        if (weatherForecastObj is List) {
          List weatherForecastArr = weatherForecastObj;
          if (weatherForecastArr.length > 0) {
            for (Map subDic in weatherForecastArr) {
              //每天的最高最低温度
              String highTemperature = subDic["highTemperature"];
              String lowTemperature = subDic["lowTemperature"];
              String minMaxWeather = lowTemperature + "/" + highTemperature;

              //每天的天气情况
              var contentDescription = "";
              final imageDic = subDic["image"];
              if (imageDic is Map) {
                contentDescription = imageDic["contentDescription"];
              }
              //日期
              String dateStr = subDic["date"];
              String day = subDic["day"];
              Map weatherMap = {
                "date": day,
                "weather_state": contentDescription,
                "min_max_weather": minMaxWeather
              };

              futureWeathers.add(weatherMap);
            }
          }
        }

        Map alexaWeatherMap = {
          "version": 0,
          "location": locationName,
          "today_weather_state": todayWeatherState,
          "today_min_max_weather": todayMinMaxWeather,
          "future_weather_len": todayMinMaxWeather.length,
          "future_weather": futureWeathers
        };

        resultObjs.add(alexaWeatherMap);
      } else {
        continue;
      }
    }
    if (resultObjs.length > 0) {
      Map weatherMap = resultObjs.first;
      logger?.v('weatherMap = ${weatherMap}');
      String mapString = jsonEncode(weatherMap);
      libManager
          .send(evt: CmdEvtType.setAlexaWeather, json: '${mapString}')
          .listen((event) {
        logger?.v('setAlexaWeather = ${event.toString()}');
      });

      return true;
    }
    return false;
  }

  _tranFile(String filePath) {

    Stream<List<bool>> exec(List<BaseFileModel> items) {
      final t = libManager.transFile.transferMultiple(
          fileItems: items,
          funcStatus: (index, FileTransStatus status) {
            logger?.v('状态： ${status.name}');
          },
          funcProgress: (int currentIndex, int totalCount,
              double currentProgress, double totalProgress) {
            logger?.v(
                '进度：${currentIndex + 1}/$totalCount $currentProgress $totalProgress');
          }, cancelPrevTranTask: true);
      _subscriptMp3Upload = t.listen((event) {
        logger?.v('传输结束 结果:${event.toString()}');
        _subscriptMp3Upload = null;
      });
      return t;
    }

    // mp3
    mp3() async {
      if (!libManager.funTable.setSupportAppSendVoiceToBle) {
        logger?.v('当前设备不支持');
        return;
      }

      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.voice, filePath: filePath, fileName: 'tmp')
      ];
      exec(fileItems);
    }

    mp3();
  }

  @override
  void cancelMp3Upload() {
    if (_subscriptMp3Upload != null) {
      logger?.v("取消执行中的reply.pcm到设备的发送任务");
      _subscriptMp3Upload?.cancel();
      _subscriptMp3Upload = null;
    }
  }
}

//文件写入操作
class _FileTool {
  io.IOSink? _ioSink;
  io.File? _voiceFile;
  String ext;
  String fileName;

  _FileTool({required this.fileName, required this.ext});

  // 写文件
  writeData(Uint8List data) async {
    if (_ioSink == null) {
      _voiceFile = await _createFile();
      _ioSink = _voiceFile?.openWrite();
    }
    _ioSink?.add(data.toList());
  }

  Future<String?> saveFile() async {
    try {
      if (_voiceFile != null && _voiceFile!.existsSync()) {
        final newPath = _voiceFile!.path.replaceAll('.tmp', '');
        final newFile = await _voiceFile!.rename(newPath);
        return newFile.path;
      }
    } catch (e) {
      logger?.e(e.toString());
    }
    _voiceFile = null;
    return null;
  }

  // 关闭
  close() async {
    await _ioSink?.flush();
    await _ioSink?.close();
    _ioSink = null;
  }

  // 写入
  flush() async {
    await _ioSink?.flush();
  }

  Future<io.File?> _createFile() async {
    try {
      final dirPath = await libManager.cache.alexaPath();
      final voicePath = '$dirPath/voice/${_fileName()}';
      final file = io.File(voicePath);
      // await file.delete();
      final voiceFile = await file.create(recursive: true);
      if (voiceFile.existsSync()) {
        return voiceFile;
      }
    } catch (e) {
      logger?.e(e.toString());
    }
    return null;
  }

  String _fileName() {
    return '$fileName.$ext.tmp'; // 固定名称
    final date = DateTime.now();
    final hms =
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
    final name = '$hms.$ext.tmp';
    return name;
  }
}
