part of '../capabilities_report.dart';

class _CapabilitiesReport implements CapabilitiesReport {
  List? endPointIDS;
  late final _service = ServiceManager();
  late final _auth = Auth();
  String? _appName;
  static final _instance = _CapabilitiesReport._internal();
  _CapabilitiesReport._internal() {
    logger?.v('_CapabilitiesReport._internal');
    //初始化其他操作...
    endPointIDS = [];
    // _auth.listenLoginStateChanged((state) {
    //   logger?.v('initUpdateDeviceCapabilities');
    //   if(_auth.isLogin){
    //      initUpdateDeviceCapabilities();
    //   }
    // });
  }
  factory _CapabilitiesReport() => _instance;

  @override
  Future<void> initUpdateDeviceCapabilities() async {
    if (_auth.isLogin == false) {
      logger?.v('initUpdateDeviceCapabilities  = Login is false');
      return;
    } else if (_auth.productId == null) {
      logger?.v('initUpdateDeviceCapabilities  = productId is null');
      return;
    }

    await IDOProtocolAlexa.changeLanguage(IDOProtocolAlexa().currentLanguage);
    // logger?.v('功能设置 - 语音 ');

    // 网关
    final rs_verifyGateway = await _service.sendEventPart(
        accessToken: _auth.accessToken!,
        dataBody: DataBox.verifyGateway(),
        label: '网关');
    logger?.v('技能上传 - 网关 = ${rs_verifyGateway.toString()}');

    //时区
    final rs_timeZone = await updateTimeZone();
    logger?.v('技能上传 - 时区 = ${rs_timeZone.toString()}');

    //基础技能
    final rs_basicSkills1 = await updateDeviceCapabilities();
    logger?.v('技能上传 - 基础技能声明1 = ${rs_basicSkills1.toString()}');

    final rs_basicSkills2 = await updateDeviceOtherCapabilities();
    logger?.v('技能上传 - 基础技能声明2 = ${rs_basicSkills2.toString()}');

    //开关和范围技能
    final rs_toggleAndRangeSkills = await updateToggleAndRangeCapabilities();
    logger?.v('技能上传 - 开关和范围技能 = ${rs_toggleAndRangeSkills.toString()}');

    //100种自定义运动 （支持100种运动排序或者100种运动跳转，PS：id = 7553是沃尔s2项目，虽然不支持100种运动，但是需要实现相关功能）
    if(libManager.funTable.setSet100SportSort || libManager.deviceInfo.deviceId == 7553 || libManager.funTable.alexaGetUIControllSports){
      final rs_toggle100SportSkills = await updateToggle100SportCapabilities();
      logger?.v('技能上传 - 100种自定义运动 = ${rs_toggle100SportSkills.toString()}');

      final rs_toggle100SportSkills2 = await updateToggle100Sport2Capabilities();
      logger?.v('技能上传 - 100种自定义运动2 = ${rs_toggle100SportSkills2.toString()}');

    }else{
      logger?.v('技能上传 - 不支持100种自定义运动');
    }

  }

  Future<dynamic> updateTimeZone() async {
    final Uint8List timezone = await DataBox.timeZoneChanged();
    final rs = await _service.sendEventPart(
        accessToken: _auth.accessToken!, dataBody: timezone, label: '更新时区');
    return rs;
  }

  /// 传统设备 -> 1:需要采用Capabilities API才能将对新的和已更改的Alexa接口的支持集成到您的设备中。
  /// 和updateDeviceOtherCapabilities功能是一样的，只是同一个接口上传，字符太长了，alexa后台请求容易失败，所以需要分开
  Future<dynamic> updateDeviceCapabilities() async {
    if (_auth.isLogin == false) {
      logger
          ?.v('AddFoundtionCapabilitiesinfo KCapabilities rs = Login is false');
      return null;
    }
    final rs =
        await _service.setTextBackCapabilities(accessToken: _auth.accessToken!);
    return rs;
  }

  /// 传统设备 -> 2:需要采用Capabilities API才能将对新的和已更改的Alexa接口的支持集成到您的设备中
  /// 和updateDeviceCapabilities功能是一样的，只是同一个接口上传，字符太长了，alexa后台请求容易失败，所以需要分开
  Future<dynamic> updateDeviceOtherCapabilities() async {
    if (_auth.isLogin == false) {
      logger?.v(
          'AddFoundtionCapabilitiesinfo Software KCapabilities rs  = Login is false');
      return null;
    }

    List softwareCapabilitiesList = [
      {
        "interface": "Alexa.SoftwareComponentReporter",
        "type": "AlexaInterface",
        "version": "1.0",
        "configurations": {
          "softwareComponents": [
            {
              "name": "com.ido.iosmediaplayer",
              "version": "1.0.0",
            }
          ]
        }
      }
    ];

    final instance = softwareCapabilitiesList.first["instance"];

    final mapEndpointId = await getSingleEndpoint(
        productId: _auth.productId,
        capList: softwareCapabilitiesList,
        instance: instance);

    Uint8List deviceOtherCapabilities =
        addOrUpdateReportBase(endPoints: [mapEndpointId]);

    final rs = await _service.sendEventPart(
        accessToken: _auth.accessToken!,
        dataBody: deviceOtherCapabilities,
        label: 'deviceOtherCapabilities');

    return rs;
  }

  /// 上传toggleControllerSkill_sport，100种运动技能上传
  Future<dynamic> updateToggle100SportCapabilities() async {
    if (_auth.isLogin == false) {
      logger?.v('AddOrUpdateReportSport KCapabilities rs  = login is false');
      return null;
    }
    String productIdKey = _auth.productId;

    ///**< 100 sport ToggleController */
    List toggle100List = [];
    if(libManager.funTable.alexaSetJumpUiV3) {
      final Map toggle100JsonResult =
      ToggleControllerSkillSport.getToggleControllerSkillSport();

      final toggle100SkillList = toggle100JsonResult["skill"];

      for (Map capability in toggle100SkillList) {
        List capabilityArr = capability["capability"];
        for (Map item in capabilityArr) {
          Map toggleitem = getToggleControllerSkillItem(item: item);
          toggle100List.add(toggleitem);
        }
      }
    }else{
      logger?.v('功能表 上传toggleControllerSkill_100sport技能---> not support alexaJumpUi');
    }


    final toggle100MapEndpointId = await getSingleEndpoint(
        productId: productIdKey, capList: toggle100List, instance: "Sport");

    Uint8List toggleRange100Capabilities =
        addOrUpdateReportBase(endPoints: [toggle100MapEndpointId]);

    final rs = await _service.sendEventPart(
        accessToken: _auth.accessToken!,
        dataBody: toggleRange100Capabilities,
        label: 'toggleRange100Capabilities');
    return rs;
  }

  /// 上传toggleControllerSkill_sport，100种运动技能上传（分开传，技能太多了）
  Future<dynamic> updateToggle100Sport2Capabilities() async {
    if (_auth.isLogin == false) {
      logger?.v('AddOrUpdateReportSport2 KCapabilities rs  = login is false');
      return null;
    }
    String productIdKey = _auth.productId;

    ///**< 100 sport ToggleController */
    List toggle100List = [];
    if(libManager.funTable.alexaSetJumpUiV3) {
      final Map toggle100JsonResult =
      ToggleControllerSkillSport2.getToggleControllerSkillSport2();

      final toggle100SkillList = toggle100JsonResult["skill"];

      for (Map capability in toggle100SkillList) {
        List capabilityArr = capability["capability"];
        for (Map item in capabilityArr) {
          Map toggleitem = getToggleControllerSkillItem(item: item);
          toggle100List.add(toggleitem);
        }
      }
    }else{
      logger?.v('功能表 上传toggleControllerSkill_100sport2技能---> not support alexaJumpUi');
    }


    final toggle100MapEndpointId = await getSingleEndpoint(
        productId: productIdKey, capList: toggle100List, instance: "Sport2");

    Uint8List toggleRange100Capabilities =
    addOrUpdateReportBase(endPoints: [toggle100MapEndpointId]);

    final rs = await _service.sendEventPart(
        accessToken: _auth.accessToken!,
        dataBody: toggleRange100Capabilities,
        label: 'toggleRange100Capabilities2');
    return rs;
  }

  /// 上传ToggleControllerSkill和RangeControllerSkill技能
  Future<dynamic> updateToggleAndRangeCapabilities() async {
    if (_auth.isLogin == false) {
      logger?.v('AddOrUpdateReport KCapabilities rs  = login is false');
      return null;
    }

    List softwareCapabilitiesList = [
      {
        "configurations": {
          "locales": [
            "de-DE",
            "en-AU",
            "en-CA",
            "en-GB",
            "en-IN",
            "en-US",
            "es-ES",
            "es-MX",
            "es-US",
            "fr-CA",
            "fr-FR",
            "it-IT",
            "ja-JP",
            "pt-BR"
          ]
        },
        "interface": "System",
        "type": "AlexaInterface",
        "version": "2.1"
      },
      {
        "interface": "InteractionModel",
        "type": "AlexaInterface",
        "version": "1.2"
      },
      {"interface": "Alexa", "type": "AlexaInterface", "version": "3"},
      {
        "interface": "Alexa.ApiGateway",
        "type": "AlexaInterface",
        "version": "1.0"
      },
      {
        "interface": "SpeechSynthesizer",
        "type": "AlexaInterface",
        "version": "1.3"
      },
      {
        "interface": "SpeechRecognizer",
        "type": "AlexaInterface",
        "version": "2.3"
      },
      {
        "configurations": {
          "maximumAlerts": {"alarms": 50, "overall": 53, "timers": 3}
        },
        "interface": "Alerts",
        "type": "AlexaInterface",
        "version": "1.3"
      },
      {
        "interface": "TemplateRuntime",
        "type": "AlexaInterface",
        "version": "1.0"
      },
      {
        "interface": "AudioPlayer",
        "type": "AlexaInterface",
        "version": "1.4",
        "configurations": {
          "fingerprint": {
            "package": "com.amazon.mediaplayer",
            "buildType": "mp3",
            "versionNumber": "1"
          }
        },
      },
      {
        "interface": "Notifications",
        "type": "AlexaInterface",
        "version": "1.0"
      },
      {"interface": "Geolocation", "type": "AlexaInterface", "version": "1.1"}
    ];

    String productIdKey = _auth.productId;
    List toggleRangeList = [];

    ///**< ToggleController */

    List toggleList = [];

    if(libManager.funTable.alexaSetJumpUiV3){
      final Map toggleJsonResult =
      ToggleControllerSkill.getToggleControllerSkill();
      final toggleSkillList = toggleJsonResult["skill"];

      for (Map capability in toggleSkillList) {
        List capabilityArr = capability["capability"];
        for (Map item in capabilityArr) {
          Map toggleitem = getToggleControllerSkillItem(item: item);
          toggleList.add(toggleitem);
        }
      }
    }else{
      logger?.v('功能表 上传ToggleControllerSkill技能---> not support alexaJumpUi');
    }

    softwareCapabilitiesList.addAll(toggleList);
    final toggleinstance = softwareCapabilitiesList.first["instance"];
    final toggleMapEndpointId = await getSingleEndpoint(
        productId: productIdKey,
        capList: softwareCapabilitiesList,
        instance: toggleinstance);

    ///1：添加开关技能
    toggleRangeList.add(toggleMapEndpointId);

    ///**< RangeControllerSkill */
    List rangeList = [];
    if(libManager.funTable.alexaSetJumpUiV3){
      final Map rangeJsonResult = RangeControllerSkill.getRangeControllerSkill();
      final rangeSkillList = rangeJsonResult["skill"];
      for (Map capability in rangeSkillList) {
        List capabilityArr = capability["capability"];
        for (Map item in capabilityArr) {
          Map rangeMap = getRangeControllerSkillItem(item: item);
          if (rangeMap != null) {
            rangeList.add(rangeMap);
          }
        }
      }

      for (Map capability in rangeList) {
        String instance = capability["instance"];
        final rangeMapEndpointId = await getSingleEndpoint(
            productId: productIdKey, capList: [capability], instance: instance);

        ///2：添加范围技能
        toggleRangeList.add(rangeMapEndpointId);
      }

    }else{
      logger?.v('功能表 上传RangeControllerSkill技能---> not support alexaJumpUi');
    }

    Uint8List deviceToggleRangeCapabilities =
        addOrUpdateReportBase(endPoints: toggleRangeList);

    final rs = await _service.sendEventPart(
        accessToken: _auth.accessToken!,
        dataBody: deviceToggleRangeCapabilities,
        label: 'deviceToggleRangeCapabilities');

    return rs;
  }

  /**< 范围控制器 */
  Map<dynamic, dynamic> getRangeControllerSkillItem({required Map item}) {
    Map supportedRange;
    List presets;
    Map configuration;
    Map properties;

    final brightness = item["instance"] as String;
    if (brightness == "brightness") {
      var brightnessvalue =
          libManager.funTable.setScreenBrightness5Level ? 5 : 3;
      if(libManager.funTable.setAlexaControll100brightness){
        brightnessvalue = 100;
      }

      supportedRange = {
        "maximumValue": brightnessvalue,
        "minimumValue": 1,
        "precision": 1
      };
      presets = [
        {
          "presetResources": {
            "friendlyNames": [
              {
                "@type": "asset",
                "value": {"assetId": "Alexa.Value.Minimum"}
              },
              {
                "@type": "asset",
                "value": {"assetId": "Alexa.Value.Low"}
              },
              {
                "@type": "text",
                "value": {"locale": "en-US", "text": "lowest"}
              },
              {
                "@type": "text",
                "value": {"locale": "en-US", "text": "Minimize"}
              }
            ]
          },
          "rangeValue": 1
        },
        {
          "presetResources": {
            "friendlyNames": [
              {
                "@type": "asset",
                "value": {"assetId": "Alexa.Value.Maximum"}
              },
              {
                "@type": "asset",
                "value": {"assetId": "Alexa.Value.High"}
              },
              {
                "@type": "text",
                "value": {"locale": "en-US", "text": "Highest"}
              },
              {
                "@type": "text",
                "value": {"locale": "en-US", "text": "Maximize"}
              }
            ]
          },
          "rangeValue": brightnessvalue
        }
      ];
      configuration = {"presets": presets, "supportedRange": supportedRange};
      properties = {
        "nonControllable": 0,
        "proactivelyReported": 0,
        "retrievable": 1,
        "supported": [
          {"name": "rangeValue"}
        ]
      };
    } else {
      supportedRange = {"maximumValue": 100, "minimumValue": 0, "precision": 1};
      configuration = {"supportedRange": supportedRange};
      properties = {
        "nonControllable": 1,
        "proactivelyReported": 0,
        "retrievable": 1,
        "supported": [
          {"name": "rangeValue"}
        ]
      };
    }

    List friendlyNameArr = [];
    for (Map friendlyName in item["friendlyNames"]) {
      Map newFriendlyName = {};
      newFriendlyName["@type"] = "text";
      newFriendlyName["value"] = friendlyName;
      friendlyNameArr.add(newFriendlyName);
    }

    Map newItem = {
      "configuration": configuration,
      "capabilityResources": {"friendlyNames": friendlyNameArr},
      "instance": item["instance"],
      "properties": properties,
      "interface": "Alexa.RangeController",
      "type": "AlexaInterface",
      "version": "3"
    };
    return newItem;
  }

  /**< 开关控制器技能 */
  Map<dynamic, dynamic> getToggleControllerSkillItem({required Map item}) {
    List friendlyNameArr = [];
    for (Map friendlyName in item["friendlyNames"]) {
      Map newFriendlyName = {};
      newFriendlyName["@type"] = "text";
      newFriendlyName["value"] = friendlyName;
      friendlyNameArr.add(newFriendlyName);
    }

    Map newItem = {
      "capabilityResources": {"friendlyNames": friendlyNameArr},
      "instance": item["instance"],
      "properties": {
        "nonControllable": 0,
        "proactivelyReported": 0,
        "retrievable": 1,
        "supported": [
          {"name": "toggleState"}
        ]
      },
      "interface": "Alexa.ToggleController",
      "type": "AlexaInterface",
      "version": "3"
    };
    return newItem;
  }

  Future<Map> getSingleEndpoint(
      {String? productId, List<dynamic>? capList, String? instance}) async {
    _appName ??= await ToolsImpl().getAppName();

    String description = "$productId on iOS";
    if (Platform.isAndroid) {
      description = "$productId on Android";
    }
    String appName = _appName!;
    String manufacturerName = "$productId";
    String endpointId = "${_auth.clientId}::$productId::ID2021SMARTALEXA ";
    String friendlyName = appName;
    if (instance != null) {
      endpointId = "$endpointId-$instance";
      friendlyName = "$appName $instance";
    }

    final map = {
      "endpointId": endpointId,
      "manufacturerName": manufacturerName,
      "description": description,
      "friendlyName": friendlyName,
      "displayCategories": ["WEARABLE"],
      "capabilities": capList
    };
    addEndPoint(endPoint: endpointId);
    return map;
  }

  void addEndPoint({required String endPoint}) {
    bool? isContains = endPointIDS?.contains(endPoint);
    if (isContains != null) {
      if (isContains) {
        return;
      }
    }
    endPointIDS?.add(endPoint);
  }

  Uint8List addOrUpdateReportBase({required List endPoints}) {
    String identifierUUID = DataBox.kUUID;
    final map = {
      "event": {
        "header": {
          "eventCorrelationToken": identifierUUID,
          "messageId": identifierUUID,
          "name": "AddOrUpdateReport",
          "namespace": "Alexa.Discovery",
          "payloadVersion": "3"
        },
        "payload": {
          "scope": {"type": "BearerToken", "token": _auth.accessToken!},
          "endpoints": endPoints
        }
      }
    };

    // final json = jsonEncode(map);
    // logger?.v("json=====:$json");

    return map.toData();
  }
}
