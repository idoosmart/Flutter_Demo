part of '../server_utils.dart';

class _AlexaServerManager implements AlexaServerManager {
  AlexaServerRegion _region = AlexaServerRegion.na;
  final Map<String, AlexaServerBase> _serverMap = {
    AlexaServerRegion.na.name: _NorthAmericaServer(),
    AlexaServerRegion.eu.name: _EuropeServer(),
    AlexaServerRegion.fe.name: _AsiaServer(),
  };
  AlexaServerBase? _customerServerBase;

  _AlexaServerManager._internal();
  static final _instance = _AlexaServerManager._internal();
  factory _AlexaServerManager() => _instance;

  @override
  AlexaServerManager setCustomServerBase(
      {required AlexaServerBase serverBase}) {
    _customerServerBase = serverBase;
    return this;
  }

  @override
  AlexaServerBase getServer(
      {AlexaServerRegion? region, bool onlyCustomer = false}) {
    if (onlyCustomer) {
      if (_customerServerBase != null) {
        return _customerServerBase!;
      }
      throw AssertionError(
          'CustomerServer is null, has call setCustomServerBase(..) set it.');
    }
    final key = region ?? _region;
    return _serverMap[key.name]!;
  }

  @override
  AlexaServerManager setRegion({required AlexaServerRegion region}) {
    _region = region;
    return this;
  }
}

/// 北美 (加拿大, 墨西哥, 美国)
class _NorthAmericaServer extends AlexaServerBase {
  @override
  String getBaseUrl(AlexaAppUrlType urlType) {
    switch (urlType) {
      case AlexaAppUrlType.alexaRESTAPI:
        return 'https://api.amazonalexa.com';
      case AlexaAppUrlType.alexaGateway:
        return 'https://alexa.na.gateway.devices.a2z.com';
      case AlexaAppUrlType.alexaApiAmazon:
        return 'https://api.amazon.com';
      case AlexaAppUrlType.idoCloudAlexa:
        return 'https://alexa.idoocloud.com';
    }
  }
}

/// 欧洲 (奥地利, 法国, 德国, 印度, 意大利, 西班牙, 英国)
class _EuropeServer extends AlexaServerBase {
  @override
  String getBaseUrl(AlexaAppUrlType urlType) {
    switch (urlType) {
      case AlexaAppUrlType.alexaRESTAPI:
        return 'https://api.eu.amazonalexa.com';
      case AlexaAppUrlType.alexaGateway:
        return 'https://alexa.na.gateway.devices.a2z.com';
      case AlexaAppUrlType.alexaApiAmazon:
        return 'https://api.amazon.com';
      case AlexaAppUrlType.idoCloudAlexa:
        return 'https://alexa.idoocloud.com';
    }
  }
}

/// 亚洲 (澳大利亚, 日本, 新西兰)
class _AsiaServer extends AlexaServerBase {
  @override
  String getBaseUrl(AlexaAppUrlType urlType) {
    switch (urlType) {
      case AlexaAppUrlType.alexaRESTAPI:
        return 'https://api.fe.amazonalexa.com';
      case AlexaAppUrlType.alexaGateway:
        return 'https://alexa.na.gateway.devices.a2z.com';
      case AlexaAppUrlType.alexaApiAmazon:
        return 'https://api.amazon.com';
      case AlexaAppUrlType.idoCloudAlexa:
        return 'https://alexa.idoocloud.com';
    }
  }
}
