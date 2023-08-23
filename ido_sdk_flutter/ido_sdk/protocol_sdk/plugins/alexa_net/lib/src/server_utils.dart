import 'package:alexa_net/alexa_net.dart';

part 'private/server_utils_impl.dart';

/// 服务区域
enum AlexaServerRegion {
  /// 北美 (加拿大, 墨西哥, 美国)
  na('NA'),

  /// 欧洲 (奥地利, 法国, 德国, 印度, 意大利, 西班牙, 英国)
  eu('EU'),

  /// 亚洲  (澳大利亚, 日本, 新西兰)
  fe('FE');

  const AlexaServerRegion(this.value);
  final String value;
}

/// 服务模块
enum AlexaAppUrlType {
  ///
  /// ```dart
  /// https://api.amazonalexa.com
  /// https://api.eu.amazonalexa.com
  /// https://api.fe.amazonalexa.com
  /// ```
  alexaRESTAPI('alexaRESTAPI'),

  ///
  /// ```dart
  /// https://alexa.na.gateway.devices.a2z.com
  /// https://alexa.eu.gateway.devices.a2z.com
  /// https://alexa.fe.gateway.devices.a2z.com
  /// ```
  alexaGateway('alexaGateway'),

  ///
  /// ```dart
  /// https://api.amazon.com
  /// ```
  alexaApiAmazon('alexaApiAmazon'),

  ///
  /// ```dart
  /// https://alexa.idoocloud.com
  /// ```
  idoCloudAlexa('idoCloudAlexa');

  const AlexaAppUrlType(this.value);
  final String value;

  /// 根据字符串转换成相应枚举
  static AlexaAppUrlType? convertForName(String name) {
    AlexaAppUrlType? urlType;
    for (var e in AlexaAppUrlType.values) {
      if (e.name == name) {
        urlType = e;
        break;
      }
    }
    return urlType;
  }
}

/// 服务器管理
/// 默认使用: 北美区域 AlexaServerRegion.na
/// 可使用 setRegion 进行切换
abstract class AlexaServerManager {
  factory AlexaServerManager() => _AlexaServerManager();

  /// 设置区域，可用于动态切换
  /// 默认为 AlexaServerRegion.na
  AlexaServerManager setRegion({required AlexaServerRegion region});

  /// 获取服务器对象
  /// ```dart
  /// region 获取指定区域服务对象，不指定该值时，使用setRegion(...)设置的区域
  ///        若未使用setRegion(...)则使用默认的 北美区域 AlexaServerRegion.na
  /// onlyCustomer  使用自定义服务器（可选）
  /// ```
  AlexaServerBase getServer(
      {AlexaServerRegion? region, bool onlyCustomer = false});

  /// 自定义服务器地址（可选）
  AlexaServerManager setCustomServerBase({required AlexaServerBase serverBase});
}

abstract class AlexaServerBase {
  String getBaseUrl(AlexaAppUrlType urlType);
}
