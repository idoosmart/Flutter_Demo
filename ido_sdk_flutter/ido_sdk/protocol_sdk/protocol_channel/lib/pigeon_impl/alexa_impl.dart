import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_alexa/protocol_alexa.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/alexa.g.dart';

class AlexaImpl extends Alexa implements IDOAlexaDelegate {
  late final _alexa = IDOProtocolAlexa();
  late final _dataSource = AlexaDataSource();
  late final _delegateAuth = AlexaAuthDelegate();

  AlexaImpl() {
    _init();
  }

  _init() {
    _alexa.delegate = this;
    _alexa.listenLoginStateChanged((state) {
      _delegateAuth.loginStateChanged(ApiLoginState.values[state.index]);
    });
    _alexa.listenVoiceStateChanged((state) {
      _delegateAuth.voiceStateChanged(ApiVoiceState.values[state.index]);
    });
  }

  @override
  Future<int> authorizeRequest(String productId) async {
    final rs = await _alexa.authorizeRequest(
        productId: productId,
        func: (String userCode, String verificationUri) {
          _delegateAuth.callbackPairCode(userCode, verificationUri);
        });
    return rs.index;
  }

  @override
  Future<bool> changeLanguage(ApiLanguageType type) async {
    final lanType = AlexaLanguageType.values[type.index];
    return IDOProtocolAlexa.changeLanguage(lanType);
  }

  @override
  ApiLanguageType currentLanguage() {
    final lanType = ApiLanguageType.values[_alexa.currentLanguage.index];
    return lanType;
  }

  @override
  void debugTest() {
    _alexa.debugTest();
  }

  @override
  Future<bool> isSupportAudioTesting() async {
    return _alexa.isSupportAudioTesting;
  }

  @override
  void logout() {
    return _alexa.logout();
  }

  @override
  void refreshToken() {
    _alexa.refreshToken();
  }

  @override
  Future<void> registerAlexa(String clientId) {
    return IDOProtocolAlexa.register(clientId: clientId);
  }

  @override
  void stopLogin() {
    _alexa.stopLogin();
  }

  @override
  Future<bool> testUploadPCM(String pcmPath) {
    return _alexa.testUploadPCM(pcmPath);
  }

  @override
  void foundationControl(AlexaFoundationType foundationType) {
    _dataSource.functionControl(foundationType.index);
  }

  @override
  Future<int> getHealthValue(AlexaGetValueType valueType) async {
    return _dataSource.getHealthValue(ApiGetValueType.values[valueType.index]);
  }

  @override
  Future<int> getHrValue(AlexaHRDataType dataType, AlexaHRTimeType timeType) async {
    return _dataSource.getHrValue(dataType.index, timeType.index);
  }

  @override
  bool isLogin() {
    return _alexa.isLogin;
  }

  @override
  void onNetworkChanged(bool hasNetwork) {
    IDOProtocolAlexa.onNetworkChanged(hasNetwork: hasNetwork);
  }
}
