// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `function table test`
  String get funcTableTest {
    return Intl.message(
      'function table test',
      name: 'funcTableTest',
      desc: '',
      args: [],
    );
  }

  /// `alexa test`
  String get alexaVoiceTest {
    return Intl.message(
      'alexa test',
      name: 'alexaVoiceTest',
      desc: '',
      args: [],
    );
  }

  /// `Alexa`
  String get alexa {
    return Intl.message(
      'Alexa',
      name: 'alexa',
      desc: '',
      args: [],
    );
  }

  /// `start sync`
  String get startsync {
    return Intl.message(
      'start sync',
      name: 'startsync',
      desc: '',
      args: [],
    );
  }

  /// `stop sync`
  String get stopsync {
    return Intl.message(
      'stop sync',
      name: 'stopsync',
      desc: '',
      args: [],
    );
  }

  /// `device connect`
  String get deviceConnect {
    return Intl.message(
      'device connect',
      name: 'deviceConnect',
      desc: '',
      args: [],
    );
  }

  /// `device disconnect`
  String get deviceDisconnect {
    return Intl.message(
      'device disconnect',
      name: 'deviceDisconnect',
      desc: '',
      args: [],
    );
  }

  /// `device bind`
  String get deviceBind {
    return Intl.message(
      'device bind',
      name: 'deviceBind',
      desc: '',
      args: [],
    );
  }

  /// `home need sync`
  String get homeneedsync {
    return Intl.message(
      'home need sync',
      name: 'homeneedsync',
      desc: '',
      args: [],
    );
  }

  /// `setup`
  String get setup {
    return Intl.message(
      'setup',
      name: 'setup',
      desc: '',
      args: [],
    );
  }

  /// `connected`
  String get connected {
    return Intl.message(
      'connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `connected success`
  String get connectedsuccess {
    return Intl.message(
      'connected success',
      name: 'connectedsuccess',
      desc: '',
      args: [],
    );
  }

  /// `connected failed`
  String get connectedfailed {
    return Intl.message(
      'connected failed',
      name: 'connectedfailed',
      desc: '',
      args: [],
    );
  }

  /// `connecting`
  String get connecting {
    return Intl.message(
      'connecting',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `disconnected`
  String get disconnected {
    return Intl.message(
      'disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `device disconnected`
  String get devicedisconnected {
    return Intl.message(
      'device disconnected',
      name: 'devicedisconnected',
      desc: '',
      args: [],
    );
  }

  /// `scanning`
  String get scanning {
    return Intl.message(
      'scanning',
      name: 'scanning',
      desc: '',
      args: [],
    );
  }

  /// `suspend scan`
  String get suspendscan {
    return Intl.message(
      'suspend scan',
      name: 'suspendscan',
      desc: '',
      args: [],
    );
  }

  /// `device suspend scan`
  String get devicesuspendscan {
    return Intl.message(
      'device suspend scan',
      name: 'devicesuspendscan',
      desc: '',
      args: [],
    );
  }

  /// `manual connect time`
  String get manualconnecttime {
    return Intl.message(
      'manual connect time',
      name: 'manualconnecttime',
      desc: '',
      args: [],
    );
  }

  /// `auto connect time`
  String get autoconnecttime {
    return Intl.message(
      'auto connect time',
      name: 'autoconnecttime',
      desc: '',
      args: [],
    );
  }

  /// `file update`
  String get fileupdate {
    return Intl.message(
      'file update',
      name: 'fileupdate',
      desc: '',
      args: [],
    );
  }

  /// `file type`
  String get filetype {
    return Intl.message(
      'file type',
      name: 'filetype',
      desc: '',
      args: [],
    );
  }

  /// `compression type`
  String get compressiontype {
    return Intl.message(
      'compression type',
      name: 'compressiontype',
      desc: '',
      args: [],
    );
  }

  /// `transfer complete`
  String get transfercomplete {
    return Intl.message(
      'transfer complete',
      name: 'transfercomplete',
      desc: '',
      args: [],
    );
  }

  /// `write complete`
  String get writecomplete {
    return Intl.message(
      'write complete',
      name: 'writecomplete',
      desc: '',
      args: [],
    );
  }

  /// `sync data`
  String get syncdata {
    return Intl.message(
      'sync data',
      name: 'syncdata',
      desc: '',
      args: [],
    );
  }

  /// `scan device`
  String get scandevice {
    return Intl.message(
      'scan device',
      name: 'scandevice',
      desc: '',
      args: [],
    );
  }

  /// `very hard scan`
  String get veryhardscan {
    return Intl.message(
      'very hard scan',
      name: 'veryhardscan',
      desc: '',
      args: [],
    );
  }

  /// `parameter select`
  String get parameterselect {
    return Intl.message(
      'parameter select',
      name: 'parameterselect',
      desc: '',
      args: [],
    );
  }

  /// `unbind`
  String get unbind {
    return Intl.message(
      'unbind',
      name: 'unbind',
      desc: '',
      args: [],
    );
  }

  /// `bind`
  String get bind {
    return Intl.message(
      'bind',
      name: 'bind',
      desc: '',
      args: [],
    );
  }

  /// `update`
  String get update {
    return Intl.message(
      'update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `lang`
  String get lang {
    return Intl.message(
      'lang',
      name: 'lang',
      desc: '',
      args: [],
    );
  }

  /// `bind success`
  String get bindsuccess {
    return Intl.message(
      'bind success',
      name: 'bindsuccess',
      desc: '',
      args: [],
    );
  }

  /// `bind failed`
  String get bindfailed {
    return Intl.message(
      'bind failed',
      name: 'bindfailed',
      desc: '',
      args: [],
    );
  }

  /// `unbind success`
  String get unbindsuccess {
    return Intl.message(
      'unbind success',
      name: 'unbindsuccess',
      desc: '',
      args: [],
    );
  }

  /// `unbind failed`
  String get unbindfailed {
    return Intl.message(
      'unbind failed',
      name: 'unbindfailed',
      desc: '',
      args: [],
    );
  }

  /// `rejected bind`
  String get rejectedbind {
    return Intl.message(
      'rejected bind',
      name: 'rejectedbind',
      desc: '',
      args: [],
    );
  }

  /// `mandatory unbind`
  String get mandatoryunbind {
    return Intl.message(
      'mandatory unbind',
      name: 'mandatoryunbind',
      desc: '',
      args: [],
    );
  }

  /// `device unbind`
  String get deviceunbind {
    return Intl.message(
      'device unbind',
      name: 'deviceunbind',
      desc: '',
      args: [],
    );
  }

  /// `device switch`
  String get deviceswitch {
    return Intl.message(
      'device switch',
      name: 'deviceswitch',
      desc: '',
      args: [],
    );
  }

  /// `device unbinding`
  String get deviceunbinding {
    return Intl.message(
      'device unbinding',
      name: 'deviceunbinding',
      desc: '',
      args: [],
    );
  }

  /// `device update`
  String get deviceupdate {
    return Intl.message(
      'device update',
      name: 'deviceupdate',
      desc: '',
      args: [],
    );
  }

  /// `function list`
  String get functionlist {
    return Intl.message(
      'function list',
      name: 'functionlist',
      desc: '',
      args: [],
    );
  }

  /// `send bind or update`
  String get sendbindorupdate {
    return Intl.message(
      'send bind or update',
      name: 'sendbindorupdate',
      desc: '',
      args: [],
    );
  }

  /// `target step`
  String get targetstep {
    return Intl.message(
      'target step',
      name: 'targetstep',
      desc: '',
      args: [],
    );
  }

  /// `target calories`
  String get targetcalories {
    return Intl.message(
      'target calories',
      name: 'targetcalories',
      desc: '',
      args: [],
    );
  }

  /// `target distance`
  String get targetdistance {
    return Intl.message(
      'target distance',
      name: 'targetdistance',
      desc: '',
      args: [],
    );
  }

  /// `monday`
  String get monday {
    return Intl.message(
      'monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `tuesday`
  String get tuesday {
    return Intl.message(
      'tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `wednesday`
  String get wednesday {
    return Intl.message(
      'wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `thursday`
  String get thursday {
    return Intl.message(
      'thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `friday`
  String get friday {
    return Intl.message(
      'friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `saturday`
  String get saturday {
    return Intl.message(
      'saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `sunday`
  String get sunday {
    return Intl.message(
      'sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `get up`
  String get getup {
    return Intl.message(
      'get up',
      name: 'getup',
      desc: '',
      args: [],
    );
  }

  /// `sleep`
  String get sleep {
    return Intl.message(
      'sleep',
      name: 'sleep',
      desc: '',
      args: [],
    );
  }

  /// `exercise`
  String get exercise {
    return Intl.message(
      'exercise',
      name: 'exercise',
      desc: '',
      args: [],
    );
  }

  /// `take medicine`
  String get takemedicine {
    return Intl.message(
      'take medicine',
      name: 'takemedicine',
      desc: '',
      args: [],
    );
  }

  /// `date`
  String get date {
    return Intl.message(
      'date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `party`
  String get party {
    return Intl.message(
      'party',
      name: 'party',
      desc: '',
      args: [],
    );
  }

  /// `meeting`
  String get meeting {
    return Intl.message(
      'meeting',
      name: 'meeting',
      desc: '',
      args: [],
    );
  }

  /// `custom`
  String get custom {
    return Intl.message(
      'custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `sub-switch`
  String get subswitch {
    return Intl.message(
      'sub-switch',
      name: 'subswitch',
      desc: '',
      args: [],
    );
  }

  /// `delay time`
  String get delaytime {
    return Intl.message(
      'delay time',
      name: 'delaytime',
      desc: '',
      args: [],
    );
  }

  /// `call reminder`
  String get callreminder {
    return Intl.message(
      'call reminder',
      name: 'callreminder',
      desc: '',
      args: [],
    );
  }

  /// `sms`
  String get sms {
    return Intl.message(
      'sms',
      name: 'sms',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `wechat`
  String get wechat {
    return Intl.message(
      'wechat',
      name: 'wechat',
      desc: '',
      args: [],
    );
  }

  /// `sina weibo`
  String get sinaweibo {
    return Intl.message(
      'sina weibo',
      name: 'sinaweibo',
      desc: '',
      args: [],
    );
  }

  /// `calendar event`
  String get calendarevent {
    return Intl.message(
      'calendar event',
      name: 'calendarevent',
      desc: '',
      args: [],
    );
  }

  /// `alarm event`
  String get alarmevent {
    return Intl.message(
      'alarm event',
      name: 'alarmevent',
      desc: '',
      args: [],
    );
  }

  /// `qq`
  String get qq {
    return Intl.message(
      'qq',
      name: 'qq',
      desc: '',
      args: [],
    );
  }

  /// `facebook`
  String get facebook {
    return Intl.message(
      'facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `twitter`
  String get twitter {
    return Intl.message(
      'twitter',
      name: 'twitter',
      desc: '',
      args: [],
    );
  }

  /// `whatsapp`
  String get whatsapp {
    return Intl.message(
      'whatsapp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `messenger`
  String get messenger {
    return Intl.message(
      'messenger',
      name: 'messenger',
      desc: '',
      args: [],
    );
  }

  /// `instagram`
  String get instagram {
    return Intl.message(
      'instagram',
      name: 'instagram',
      desc: '',
      args: [],
    );
  }

  /// `linked in`
  String get linkedin {
    return Intl.message(
      'linked in',
      name: 'linkedin',
      desc: '',
      args: [],
    );
  }

  /// `skype`
  String get skype {
    return Intl.message(
      'skype',
      name: 'skype',
      desc: '',
      args: [],
    );
  }

  /// `pokeman`
  String get pokeman {
    return Intl.message(
      'pokeman',
      name: 'pokeman',
      desc: '',
      args: [],
    );
  }

  /// `vkontakte`
  String get vkontakte {
    return Intl.message(
      'vkontakte',
      name: 'vkontakte',
      desc: '',
      args: [],
    );
  }

  /// `line`
  String get line {
    return Intl.message(
      'line',
      name: 'line',
      desc: '',
      args: [],
    );
  }

  /// `viber`
  String get viber {
    return Intl.message(
      'viber',
      name: 'viber',
      desc: '',
      args: [],
    );
  }

  /// `kakaotalk`
  String get kakaotalk {
    return Intl.message(
      'kakaotalk',
      name: 'kakaotalk',
      desc: '',
      args: [],
    );
  }

  /// `gmail`
  String get gmail {
    return Intl.message(
      'gmail',
      name: 'gmail',
      desc: '',
      args: [],
    );
  }

  /// `outlook`
  String get outlook {
    return Intl.message(
      'outlook',
      name: 'outlook',
      desc: '',
      args: [],
    );
  }

  /// `snapchat`
  String get snapchat {
    return Intl.message(
      'snapchat',
      name: 'snapchat',
      desc: '',
      args: [],
    );
  }

  /// `telegram`
  String get telegram {
    return Intl.message(
      'telegram',
      name: 'telegram',
      desc: '',
      args: [],
    );
  }

  /// `other`
  String get other {
    return Intl.message(
      'other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `sunny days`
  String get sunnydays {
    return Intl.message(
      'sunny days',
      name: 'sunnydays',
      desc: '',
      args: [],
    );
  }

  /// `cloudy1`
  String get cloudy1 {
    return Intl.message(
      'cloudy1',
      name: 'cloudy1',
      desc: '',
      args: [],
    );
  }

  /// `cloudy2`
  String get cloudy2 {
    return Intl.message(
      'cloudy2',
      name: 'cloudy2',
      desc: '',
      args: [],
    );
  }

  /// `rain1`
  String get rain1 {
    return Intl.message(
      'rain1',
      name: 'rain1',
      desc: '',
      args: [],
    );
  }

  /// `rain2`
  String get rain2 {
    return Intl.message(
      'rain2',
      name: 'rain2',
      desc: '',
      args: [],
    );
  }

  /// `thunder storm`
  String get thunderstorm {
    return Intl.message(
      'thunder storm',
      name: 'thunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `snow`
  String get snow {
    return Intl.message(
      'snow',
      name: 'snow',
      desc: '',
      args: [],
    );
  }

  /// `snow rain`
  String get snowrain {
    return Intl.message(
      'snow rain',
      name: 'snowrain',
      desc: '',
      args: [],
    );
  }

  /// `typhoon`
  String get typhoon {
    return Intl.message(
      'typhoon',
      name: 'typhoon',
      desc: '',
      args: [],
    );
  }

  /// `sandstorm`
  String get sandstorm {
    return Intl.message(
      'sandstorm',
      name: 'sandstorm',
      desc: '',
      args: [],
    );
  }

  /// `shine at night`
  String get shineatnight {
    return Intl.message(
      'shine at night',
      name: 'shineatnight',
      desc: '',
      args: [],
    );
  }

  /// `cloudy at night`
  String get cloudyatnight {
    return Intl.message(
      'cloudy at night',
      name: 'cloudyatnight',
      desc: '',
      args: [],
    );
  }

  /// `hot`
  String get hot {
    return Intl.message(
      'hot',
      name: 'hot',
      desc: '',
      args: [],
    );
  }

  /// `cold`
  String get cold {
    return Intl.message(
      'cold',
      name: 'cold',
      desc: '',
      args: [],
    );
  }

  /// `breezy`
  String get breezy {
    return Intl.message(
      'breezy',
      name: 'breezy',
      desc: '',
      args: [],
    );
  }

  /// `windy`
  String get windy {
    return Intl.message(
      'windy',
      name: 'windy',
      desc: '',
      args: [],
    );
  }

  /// `misty`
  String get misty {
    return Intl.message(
      'misty',
      name: 'misty',
      desc: '',
      args: [],
    );
  }

  /// `showers`
  String get showers {
    return Intl.message(
      'showers',
      name: 'showers',
      desc: '',
      args: [],
    );
  }

  /// `cloudy to clear`
  String get cloudytoclear {
    return Intl.message(
      'cloudy to clear',
      name: 'cloudytoclear',
      desc: '',
      args: [],
    );
  }

  /// `N moon`
  String get Nmoon {
    return Intl.message(
      'N moon',
      name: 'Nmoon',
      desc: '',
      args: [],
    );
  }

  /// `WXC moon`
  String get WXCmoon {
    return Intl.message(
      'WXC moon',
      name: 'WXCmoon',
      desc: '',
      args: [],
    );
  }

  /// `FQ moon`
  String get FQmoon {
    return Intl.message(
      'FQ moon',
      name: 'FQmoon',
      desc: '',
      args: [],
    );
  }

  /// `WXG moon`
  String get WXGmoon {
    return Intl.message(
      'WXG moon',
      name: 'WXGmoon',
      desc: '',
      args: [],
    );
  }

  /// `F moon`
  String get Fmoon {
    return Intl.message(
      'F moon',
      name: 'Fmoon',
      desc: '',
      args: [],
    );
  }

  /// `WNG moon`
  String get WNGmoon {
    return Intl.message(
      'WNG moon',
      name: 'WNGmoon',
      desc: '',
      args: [],
    );
  }

  /// `LQ moon`
  String get LQmoon {
    return Intl.message(
      'LQ moon',
      name: 'LQmoon',
      desc: '',
      args: [],
    );
  }

  /// `WNC moon`
  String get WNCmoon {
    return Intl.message(
      'WNC moon',
      name: 'WNCmoon',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'currentweathertype:' key

  // skipped getter for the 'currenttemperature:' key

  // skipped getter for the 'currenttoptemperature:' key

  // skipped getter for the 'currentminimumtemperature:' key

  // skipped getter for the 'currenthumidity:' key

  // skipped getter for the 'currentuvintensity:' key

  // skipped getter for the 'currentairindex:' key

  /// `auto mode`
  String get automode {
    return Intl.message(
      'auto mode',
      name: 'automode',
      desc: '',
      args: [],
    );
  }

  /// `manual mode`
  String get manualmode {
    return Intl.message(
      'manual mode',
      name: 'manualmode',
      desc: '',
      args: [],
    );
  }

  /// `continuously monitor`
  String get continuouslymonitor {
    return Intl.message(
      'continuously monitor',
      name: 'continuouslymonitor',
      desc: '',
      args: [],
    );
  }

  /// `default mode`
  String get defaultmode {
    return Intl.message(
      'default mode',
      name: 'defaultmode',
      desc: '',
      args: [],
    );
  }

  /// `heart rate interval mode`
  String get heartrateintervalmode {
    return Intl.message(
      'heart rate interval mode',
      name: 'heartrateintervalmode',
      desc: '',
      args: [],
    );
  }

  /// `off`
  String get off {
    return Intl.message(
      'off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `invalid`
  String get invalid {
    return Intl.message(
      'invalid',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `km`
  String get km {
    return Intl.message(
      'km',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `mi`
  String get mi {
    return Intl.message(
      'mi',
      name: 'mi',
      desc: '',
      args: [],
    );
  }

  /// `kg`
  String get kg {
    return Intl.message(
      'kg',
      name: 'kg',
      desc: '',
      args: [],
    );
  }

  /// `lb`
  String get lb {
    return Intl.message(
      'lb',
      name: 'lb',
      desc: '',
      args: [],
    );
  }

  /// `st`
  String get st {
    return Intl.message(
      'st',
      name: 'st',
      desc: '',
      args: [],
    );
  }

  /// `°C`
  String get Celsius {
    return Intl.message(
      '°C',
      name: 'Celsius',
      desc: '',
      args: [],
    );
  }

  /// `°F`
  String get Fahrenheit {
    return Intl.message(
      '°F',
      name: 'Fahrenheit',
      desc: '',
      args: [],
    );
  }

  /// `chinese`
  String get chinese {
    return Intl.message(
      'chinese',
      name: 'chinese',
      desc: '',
      args: [],
    );
  }

  /// `english`
  String get english {
    return Intl.message(
      'english',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `french`
  String get french {
    return Intl.message(
      'french',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `german`
  String get german {
    return Intl.message(
      'german',
      name: 'german',
      desc: '',
      args: [],
    );
  }

  /// `italian`
  String get italian {
    return Intl.message(
      'italian',
      name: 'italian',
      desc: '',
      args: [],
    );
  }

  /// `spanish`
  String get spanish {
    return Intl.message(
      'spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `japanese`
  String get japanese {
    return Intl.message(
      'japanese',
      name: 'japanese',
      desc: '',
      args: [],
    );
  }

  /// `polish`
  String get polish {
    return Intl.message(
      'polish',
      name: 'polish',
      desc: '',
      args: [],
    );
  }

  /// `czech`
  String get czech {
    return Intl.message(
      'czech',
      name: 'czech',
      desc: '',
      args: [],
    );
  }

  /// `romania`
  String get romania {
    return Intl.message(
      'romania',
      name: 'romania',
      desc: '',
      args: [],
    );
  }

  /// `lithuanian`
  String get lithuanian {
    return Intl.message(
      'lithuanian',
      name: 'lithuanian',
      desc: '',
      args: [],
    );
  }

  /// `dutch`
  String get dutch {
    return Intl.message(
      'dutch',
      name: 'dutch',
      desc: '',
      args: [],
    );
  }

  /// `slovenia`
  String get slovenia {
    return Intl.message(
      'slovenia',
      name: 'slovenia',
      desc: '',
      args: [],
    );
  }

  /// `hungarian`
  String get hungarian {
    return Intl.message(
      'hungarian',
      name: 'hungarian',
      desc: '',
      args: [],
    );
  }

  /// `russian`
  String get russian {
    return Intl.message(
      'russian',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `ukrainian`
  String get ukrainian {
    return Intl.message(
      'ukrainian',
      name: 'ukrainian',
      desc: '',
      args: [],
    );
  }

  /// `slovak`
  String get slovak {
    return Intl.message(
      'slovak',
      name: 'slovak',
      desc: '',
      args: [],
    );
  }

  /// `danish`
  String get danish {
    return Intl.message(
      'danish',
      name: 'danish',
      desc: '',
      args: [],
    );
  }

  /// `croatia`
  String get croatia {
    return Intl.message(
      'croatia',
      name: 'croatia',
      desc: '',
      args: [],
    );
  }

  /// `indonesian`
  String get indonesian {
    return Intl.message(
      'indonesian',
      name: 'indonesian',
      desc: '',
      args: [],
    );
  }

  /// `korean`
  String get korean {
    return Intl.message(
      'korean',
      name: 'korean',
      desc: '',
      args: [],
    );
  }

  /// `hindi`
  String get hindi {
    return Intl.message(
      'hindi',
      name: 'hindi',
      desc: '',
      args: [],
    );
  }

  /// `portuguese`
  String get portuguese {
    return Intl.message(
      'portuguese',
      name: 'portuguese',
      desc: '',
      args: [],
    );
  }

  /// `turkey`
  String get turkey {
    return Intl.message(
      'turkey',
      name: 'turkey',
      desc: '',
      args: [],
    );
  }

  /// `thai`
  String get thai {
    return Intl.message(
      'thai',
      name: 'thai',
      desc: '',
      args: [],
    );
  }

  /// `vietnamese`
  String get vietnamese {
    return Intl.message(
      'vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `burmese`
  String get burmese {
    return Intl.message(
      'burmese',
      name: 'burmese',
      desc: '',
      args: [],
    );
  }

  /// `filipino`
  String get filipino {
    return Intl.message(
      'filipino',
      name: 'filipino',
      desc: '',
      args: [],
    );
  }

  /// `traditional chinese`
  String get traditionalchinese {
    return Intl.message(
      'traditional chinese',
      name: 'traditionalchinese',
      desc: '',
      args: [],
    );
  }

  /// `greek`
  String get greek {
    return Intl.message(
      'greek',
      name: 'greek',
      desc: '',
      args: [],
    );
  }

  /// `arabic`
  String get arabic {
    return Intl.message(
      'arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `sweden`
  String get sweden {
    return Intl.message(
      'sweden',
      name: 'sweden',
      desc: '',
      args: [],
    );
  }

  /// `finland`
  String get finland {
    return Intl.message(
      'finland',
      name: 'finland',
      desc: '',
      args: [],
    );
  }

  /// `persia`
  String get persia {
    return Intl.message(
      'persia',
      name: 'persia',
      desc: '',
      args: [],
    );
  }

  /// `norwegian`
  String get norwegian {
    return Intl.message(
      'norwegian',
      name: 'norwegian',
      desc: '',
      args: [],
    );
  }

  /// `24 hours`
  String get hours24 {
    return Intl.message(
      '24 hours',
      name: 'hours24',
      desc: '',
      args: [],
    );
  }

  /// `12 hours`
  String get hours12 {
    return Intl.message(
      '12 hours',
      name: 'hours12',
      desc: '',
      args: [],
    );
  }

  /// `open`
  String get open {
    return Intl.message(
      'open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `startup mode:`
  String get startupmode {
    return Intl.message(
      'startup mode:',
      name: 'startupmode',
      desc: '',
      args: [],
    );
  }

  /// `operation mode:`
  String get operationmode {
    return Intl.message(
      'operation mode:',
      name: 'operationmode',
      desc: '',
      args: [],
    );
  }

  /// `positioning cycle:`
  String get positioningcycle {
    return Intl.message(
      'positioning cycle:',
      name: 'positioningcycle',
      desc: '',
      args: [],
    );
  }

  /// `positioning mode:`
  String get positioningmode {
    return Intl.message(
      'positioning mode:',
      name: 'positioningmode',
      desc: '',
      args: [],
    );
  }

  /// `distance unit:`
  String get distanceunit {
    return Intl.message(
      'distance unit:',
      name: 'distanceunit',
      desc: '',
      args: [],
    );
  }

  /// `weight unit:`
  String get weightunit {
    return Intl.message(
      'weight unit:',
      name: 'weightunit',
      desc: '',
      args: [],
    );
  }

  /// `temperature unit:`
  String get temperatureunit {
    return Intl.message(
      'temperature unit:',
      name: 'temperatureunit',
      desc: '',
      args: [],
    );
  }

  /// `current language:`
  String get currentlanguage {
    return Intl.message(
      'current language:',
      name: 'currentlanguage',
      desc: '',
      args: [],
    );
  }

  /// `walking step length:`
  String get walkingsteplength {
    return Intl.message(
      'walking step length:',
      name: 'walkingsteplength',
      desc: '',
      args: [],
    );
  }

  /// `running step length:`
  String get runningsteplength {
    return Intl.message(
      'running step length:',
      name: 'runningsteplength',
      desc: '',
      args: [],
    );
  }

  /// `gps stride calibration:`
  String get gpsstridecalibration {
    return Intl.message(
      'gps stride calibration:',
      name: 'gpsstridecalibration',
      desc: '',
      args: [],
    );
  }

  /// `time format:`
  String get timeformat {
    return Intl.message(
      'time format:',
      name: 'timeformat',
      desc: '',
      args: [],
    );
  }

  /// `week start:`
  String get weekstart {
    return Intl.message(
      'week start:',
      name: 'weekstart',
      desc: '',
      args: [],
    );
  }

  /// `calorie unit:`
  String get calorieunit {
    return Intl.message(
      'calorie unit:',
      name: 'calorieunit',
      desc: '',
      args: [],
    );
  }

  /// `swim pool unit:`
  String get swimpoolunit {
    return Intl.message(
      'swim pool unit:',
      name: 'swimpoolunit',
      desc: '',
      args: [],
    );
  }

  /// `cycling unit:`
  String get cyclingunit {
    return Intl.message(
      'cycling unit:',
      name: 'cyclingunit',
      desc: '',
      args: [],
    );
  }

  /// `walk run unit:`
  String get walkrununit {
    return Intl.message(
      'walk run unit:',
      name: 'walkrununit',
      desc: '',
      args: [],
    );
  }

  /// `walk`
  String get walk {
    return Intl.message(
      'walk',
      name: 'walk',
      desc: '',
      args: [],
    );
  }

  /// `run`
  String get run {
    return Intl.message(
      'run',
      name: 'run',
      desc: '',
      args: [],
    );
  }

  /// `ride`
  String get ride {
    return Intl.message(
      'ride',
      name: 'ride',
      desc: '',
      args: [],
    );
  }

  /// `hike`
  String get hike {
    return Intl.message(
      'hike',
      name: 'hike',
      desc: '',
      args: [],
    );
  }

  /// `swim`
  String get swim {
    return Intl.message(
      'swim',
      name: 'swim',
      desc: '',
      args: [],
    );
  }

  /// `mountain climbing`
  String get mountainclimbing {
    return Intl.message(
      'mountain climbing',
      name: 'mountainclimbing',
      desc: '',
      args: [],
    );
  }

  /// `badminton`
  String get badminton {
    return Intl.message(
      'badminton',
      name: 'badminton',
      desc: '',
      args: [],
    );
  }

  /// `fitness`
  String get fitness {
    return Intl.message(
      'fitness',
      name: 'fitness',
      desc: '',
      args: [],
    );
  }

  /// `spinning`
  String get spinning {
    return Intl.message(
      'spinning',
      name: 'spinning',
      desc: '',
      args: [],
    );
  }

  /// `elliptical machine`
  String get ellipticalmachine {
    return Intl.message(
      'elliptical machine',
      name: 'ellipticalmachine',
      desc: '',
      args: [],
    );
  }

  /// `treadmill`
  String get treadmill {
    return Intl.message(
      'treadmill',
      name: 'treadmill',
      desc: '',
      args: [],
    );
  }

  /// `sit-ups`
  String get sitUps {
    return Intl.message(
      'sit-ups',
      name: 'sitUps',
      desc: '',
      args: [],
    );
  }

  /// `push-ups`
  String get pushUps {
    return Intl.message(
      'push-ups',
      name: 'pushUps',
      desc: '',
      args: [],
    );
  }

  /// `dumbbells`
  String get dumbbells {
    return Intl.message(
      'dumbbells',
      name: 'dumbbells',
      desc: '',
      args: [],
    );
  }

  /// `weight lifting`
  String get weightlifting {
    return Intl.message(
      'weight lifting',
      name: 'weightlifting',
      desc: '',
      args: [],
    );
  }

  /// `calisthenics`
  String get calisthenics {
    return Intl.message(
      'calisthenics',
      name: 'calisthenics',
      desc: '',
      args: [],
    );
  }

  /// `yoga`
  String get yoga1 {
    return Intl.message(
      'yoga',
      name: 'yoga1',
      desc: '',
      args: [],
    );
  }

  /// `rope skipping`
  String get ropeskipping {
    return Intl.message(
      'rope skipping',
      name: 'ropeskipping',
      desc: '',
      args: [],
    );
  }

  /// `table tennis`
  String get tabletennis {
    return Intl.message(
      'table tennis',
      name: 'tabletennis',
      desc: '',
      args: [],
    );
  }

  /// `basketball`
  String get basketball {
    return Intl.message(
      'basketball',
      name: 'basketball',
      desc: '',
      args: [],
    );
  }

  /// `football`
  String get football {
    return Intl.message(
      'football',
      name: 'football',
      desc: '',
      args: [],
    );
  }

  /// `volleyball`
  String get volleyball {
    return Intl.message(
      'volleyball',
      name: 'volleyball',
      desc: '',
      args: [],
    );
  }

  /// `tennis`
  String get tennis {
    return Intl.message(
      'tennis',
      name: 'tennis',
      desc: '',
      args: [],
    );
  }

  /// `golf`
  String get golf {
    return Intl.message(
      'golf',
      name: 'golf',
      desc: '',
      args: [],
    );
  }

  /// `baseball`
  String get baseball {
    return Intl.message(
      'baseball',
      name: 'baseball',
      desc: '',
      args: [],
    );
  }

  /// `skiing`
  String get skiing {
    return Intl.message(
      'skiing',
      name: 'skiing',
      desc: '',
      args: [],
    );
  }

  /// `roller skating`
  String get rollerskating {
    return Intl.message(
      'roller skating',
      name: 'rollerskating',
      desc: '',
      args: [],
    );
  }

  /// `dancing`
  String get dancing {
    return Intl.message(
      'dancing',
      name: 'dancing',
      desc: '',
      args: [],
    );
  }

  /// `indoor rowing`
  String get indoorrowing {
    return Intl.message(
      'indoor rowing',
      name: 'indoorrowing',
      desc: '',
      args: [],
    );
  }

  /// `pilates`
  String get pilates {
    return Intl.message(
      'pilates',
      name: 'pilates',
      desc: '',
      args: [],
    );
  }

  /// `cross training`
  String get crosstraining {
    return Intl.message(
      'cross training',
      name: 'crosstraining',
      desc: '',
      args: [],
    );
  }

  /// `aerobics`
  String get aerobics {
    return Intl.message(
      'aerobics',
      name: 'aerobics',
      desc: '',
      args: [],
    );
  }

  /// `zumba`
  String get zumba {
    return Intl.message(
      'zumba',
      name: 'zumba',
      desc: '',
      args: [],
    );
  }

  /// `square dance`
  String get squaredance {
    return Intl.message(
      'square dance',
      name: 'squaredance',
      desc: '',
      args: [],
    );
  }

  /// `plank`
  String get plank {
    return Intl.message(
      'plank',
      name: 'plank',
      desc: '',
      args: [],
    );
  }

  /// `gym`
  String get gym {
    return Intl.message(
      'gym',
      name: 'gym',
      desc: '',
      args: [],
    );
  }

  /// `outdoor running`
  String get outdoorrunning {
    return Intl.message(
      'outdoor running',
      name: 'outdoorrunning',
      desc: '',
      args: [],
    );
  }

  /// `indoor running`
  String get indoorrunning {
    return Intl.message(
      'indoor running',
      name: 'indoorrunning',
      desc: '',
      args: [],
    );
  }

  /// `outdoor cycling`
  String get outdoorcycling {
    return Intl.message(
      'outdoor cycling',
      name: 'outdoorcycling',
      desc: '',
      args: [],
    );
  }

  /// `indoor cycling`
  String get indoorcycling {
    return Intl.message(
      'indoor cycling',
      name: 'indoorcycling',
      desc: '',
      args: [],
    );
  }

  /// `outdoor walking`
  String get outdoorwalking {
    return Intl.message(
      'outdoor walking',
      name: 'outdoorwalking',
      desc: '',
      args: [],
    );
  }

  /// `indoor walking`
  String get indoorwalking {
    return Intl.message(
      'indoor walking',
      name: 'indoorwalking',
      desc: '',
      args: [],
    );
  }

  /// `pool swimming`
  String get poolswimming {
    return Intl.message(
      'pool swimming',
      name: 'poolswimming',
      desc: '',
      args: [],
    );
  }

  /// `open water swimming`
  String get openwaterswimming {
    return Intl.message(
      'open water swimming',
      name: 'openwaterswimming',
      desc: '',
      args: [],
    );
  }

  /// `rowing machine`
  String get rowingmachine {
    return Intl.message(
      'rowing machine',
      name: 'rowingmachine',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'high-intensityintervaltraining' key

  /// `cricket`
  String get cricket {
    return Intl.message(
      'cricket',
      name: 'cricket',
      desc: '',
      args: [],
    );
  }

  /// `free training`
  String get freetraining {
    return Intl.message(
      'free training',
      name: 'freetraining',
      desc: '',
      args: [],
    );
  }

  /// `functional strength training`
  String get functionalstrengthtraining {
    return Intl.message(
      'functional strength training',
      name: 'functionalstrengthtraining',
      desc: '',
      args: [],
    );
  }

  /// `core training`
  String get coretraining {
    return Intl.message(
      'core training',
      name: 'coretraining',
      desc: '',
      args: [],
    );
  }

  /// `treadmills`
  String get treadmills {
    return Intl.message(
      'treadmills',
      name: 'treadmills',
      desc: '',
      args: [],
    );
  }

  /// `organize and relax`
  String get organizeandrelax {
    return Intl.message(
      'organize and relax',
      name: 'organizeandrelax',
      desc: '',
      args: [],
    );
  }

  /// `traditional strength training`
  String get traditionalstrengthtraining {
    return Intl.message(
      'traditional strength training',
      name: 'traditionalstrengthtraining',
      desc: '',
      args: [],
    );
  }

  /// `pull ups`
  String get pullups {
    return Intl.message(
      'pull ups',
      name: 'pullups',
      desc: '',
      args: [],
    );
  }

  /// `jumping jacks`
  String get jumpingjacks {
    return Intl.message(
      'jumping jacks',
      name: 'jumpingjacks',
      desc: '',
      args: [],
    );
  }

  /// `squats`
  String get squats {
    return Intl.message(
      'squats',
      name: 'squats',
      desc: '',
      args: [],
    );
  }

  /// `high knees`
  String get highknees {
    return Intl.message(
      'high knees',
      name: 'highknees',
      desc: '',
      args: [],
    );
  }

  /// `boxing`
  String get boxing {
    return Intl.message(
      'boxing',
      name: 'boxing',
      desc: '',
      args: [],
    );
  }

  /// `barbell`
  String get barbell {
    return Intl.message(
      'barbell',
      name: 'barbell',
      desc: '',
      args: [],
    );
  }

  /// `martial arts`
  String get martialarts {
    return Intl.message(
      'martial arts',
      name: 'martialarts',
      desc: '',
      args: [],
    );
  }

  /// `tai chi`
  String get taichi {
    return Intl.message(
      'tai chi',
      name: 'taichi',
      desc: '',
      args: [],
    );
  }

  /// `taekwondo`
  String get taekwondo {
    return Intl.message(
      'taekwondo',
      name: 'taekwondo',
      desc: '',
      args: [],
    );
  }

  /// `karate`
  String get karate {
    return Intl.message(
      'karate',
      name: 'karate',
      desc: '',
      args: [],
    );
  }

  /// `kickboxing`
  String get kickboxing {
    return Intl.message(
      'kickboxing',
      name: 'kickboxing',
      desc: '',
      args: [],
    );
  }

  /// `fencing`
  String get fencing {
    return Intl.message(
      'fencing',
      name: 'fencing',
      desc: '',
      args: [],
    );
  }

  /// `archery`
  String get archery {
    return Intl.message(
      'archery',
      name: 'archery',
      desc: '',
      args: [],
    );
  }

  /// `gymnastics`
  String get gymnastics {
    return Intl.message(
      'gymnastics',
      name: 'gymnastics',
      desc: '',
      args: [],
    );
  }

  /// `horizontal bar`
  String get horizontalbar {
    return Intl.message(
      'horizontal bar',
      name: 'horizontalbar',
      desc: '',
      args: [],
    );
  }

  /// `parallel bar`
  String get parallelbar {
    return Intl.message(
      'parallel bar',
      name: 'parallelbar',
      desc: '',
      args: [],
    );
  }

  /// `walking machine`
  String get walkingmachine {
    return Intl.message(
      'walking machine',
      name: 'walkingmachine',
      desc: '',
      args: [],
    );
  }

  /// `climbing machine`
  String get climbingmachine {
    return Intl.message(
      'climbing machine',
      name: 'climbingmachine',
      desc: '',
      args: [],
    );
  }

  /// `bowling`
  String get bowling {
    return Intl.message(
      'bowling',
      name: 'bowling',
      desc: '',
      args: [],
    );
  }

  /// `billiards`
  String get billiards {
    return Intl.message(
      'billiards',
      name: 'billiards',
      desc: '',
      args: [],
    );
  }

  /// `hockey`
  String get hockey {
    return Intl.message(
      'hockey',
      name: 'hockey',
      desc: '',
      args: [],
    );
  }

  /// `rugby`
  String get rugby {
    return Intl.message(
      'rugby',
      name: 'rugby',
      desc: '',
      args: [],
    );
  }

  /// `squash`
  String get squash {
    return Intl.message(
      'squash',
      name: 'squash',
      desc: '',
      args: [],
    );
  }

  /// `softball`
  String get softball {
    return Intl.message(
      'softball',
      name: 'softball',
      desc: '',
      args: [],
    );
  }

  /// `handball`
  String get handball {
    return Intl.message(
      'handball',
      name: 'handball',
      desc: '',
      args: [],
    );
  }

  /// `shuttlecock`
  String get shuttlecock {
    return Intl.message(
      'shuttlecock',
      name: 'shuttlecock',
      desc: '',
      args: [],
    );
  }

  /// `beach soccer`
  String get beachsoccer {
    return Intl.message(
      'beach soccer',
      name: 'beachsoccer',
      desc: '',
      args: [],
    );
  }

  /// `sepak takraw`
  String get sepaktakraw {
    return Intl.message(
      'sepak takraw',
      name: 'sepaktakraw',
      desc: '',
      args: [],
    );
  }

  /// `dodgeball`
  String get dodgeball {
    return Intl.message(
      'dodgeball',
      name: 'dodgeball',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'hip-hop' key

  /// `ballet`
  String get ballet {
    return Intl.message(
      'ballet',
      name: 'ballet',
      desc: '',
      args: [],
    );
  }

  /// `social dance`
  String get socialdance {
    return Intl.message(
      'social dance',
      name: 'socialdance',
      desc: '',
      args: [],
    );
  }

  /// `frisbee`
  String get frisbee {
    return Intl.message(
      'frisbee',
      name: 'frisbee',
      desc: '',
      args: [],
    );
  }

  /// `darts`
  String get darts {
    return Intl.message(
      'darts',
      name: 'darts',
      desc: '',
      args: [],
    );
  }

  /// `horseback riding`
  String get horsebackriding {
    return Intl.message(
      'horseback riding',
      name: 'horsebackriding',
      desc: '',
      args: [],
    );
  }

  /// `stair climbing`
  String get stairclimbing {
    return Intl.message(
      'stair climbing',
      name: 'stairclimbing',
      desc: '',
      args: [],
    );
  }

  /// `kite flying`
  String get kiteflying {
    return Intl.message(
      'kite flying',
      name: 'kiteflying',
      desc: '',
      args: [],
    );
  }

  /// `fishing`
  String get fishing {
    return Intl.message(
      'fishing',
      name: 'fishing',
      desc: '',
      args: [],
    );
  }

  /// `sled`
  String get sled {
    return Intl.message(
      'sled',
      name: 'sled',
      desc: '',
      args: [],
    );
  }

  /// `snowmobile`
  String get snowmobile {
    return Intl.message(
      'snowmobile',
      name: 'snowmobile',
      desc: '',
      args: [],
    );
  }

  /// `snowboard`
  String get snowboard {
    return Intl.message(
      'snowboard',
      name: 'snowboard',
      desc: '',
      args: [],
    );
  }

  /// `snow sports`
  String get snowsports {
    return Intl.message(
      'snow sports',
      name: 'snowsports',
      desc: '',
      args: [],
    );
  }

  /// `alpine skiing`
  String get alpineskiing {
    return Intl.message(
      'alpine skiing',
      name: 'alpineskiing',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'cross-countryskiing' key

  /// `curling`
  String get curling {
    return Intl.message(
      'curling',
      name: 'curling',
      desc: '',
      args: [],
    );
  }

  /// `ice hockey`
  String get icehockey {
    return Intl.message(
      'ice hockey',
      name: 'icehockey',
      desc: '',
      args: [],
    );
  }

  /// `biathlon`
  String get biathlon {
    return Intl.message(
      'biathlon',
      name: 'biathlon',
      desc: '',
      args: [],
    );
  }

  /// `surfing`
  String get surfing {
    return Intl.message(
      'surfing',
      name: 'surfing',
      desc: '',
      args: [],
    );
  }

  /// `sailing`
  String get sailing {
    return Intl.message(
      'sailing',
      name: 'sailing',
      desc: '',
      args: [],
    );
  }

  /// `windsurfing`
  String get windsurfing {
    return Intl.message(
      'windsurfing',
      name: 'windsurfing',
      desc: '',
      args: [],
    );
  }

  /// `kayak`
  String get kayak {
    return Intl.message(
      'kayak',
      name: 'kayak',
      desc: '',
      args: [],
    );
  }

  /// `motorboat`
  String get motorboat {
    return Intl.message(
      'motorboat',
      name: 'motorboat',
      desc: '',
      args: [],
    );
  }

  /// `rowing`
  String get rowing {
    return Intl.message(
      'rowing',
      name: 'rowing',
      desc: '',
      args: [],
    );
  }

  /// `dragon boat`
  String get dragonboat {
    return Intl.message(
      'dragon boat',
      name: 'dragonboat',
      desc: '',
      args: [],
    );
  }

  /// `water polo`
  String get waterpolo {
    return Intl.message(
      'water polo',
      name: 'waterpolo',
      desc: '',
      args: [],
    );
  }

  /// `rafting`
  String get rafting {
    return Intl.message(
      'rafting',
      name: 'rafting',
      desc: '',
      args: [],
    );
  }

  /// `skateboarding`
  String get skateboarding {
    return Intl.message(
      'skateboarding',
      name: 'skateboarding',
      desc: '',
      args: [],
    );
  }

  /// `rock climbing`
  String get rockclimbing {
    return Intl.message(
      'rock climbing',
      name: 'rockclimbing',
      desc: '',
      args: [],
    );
  }

  /// `bungee jumping`
  String get bungeejumping {
    return Intl.message(
      'bungee jumping',
      name: 'bungeejumping',
      desc: '',
      args: [],
    );
  }

  /// `parkour`
  String get parkour {
    return Intl.message(
      'parkour',
      name: 'parkour',
      desc: '',
      args: [],
    );
  }

  /// `BMX`
  String get BMX {
    return Intl.message(
      'BMX',
      name: 'BMX',
      desc: '',
      args: [],
    );
  }

  /// `outdoor Fun`
  String get outdoorFun {
    return Intl.message(
      'outdoor Fun',
      name: 'outdoorFun',
      desc: '',
      args: [],
    );
  }

  /// `other activity`
  String get otheractivity {
    return Intl.message(
      'other activity',
      name: 'otheractivity',
      desc: '',
      args: [],
    );
  }

  /// `eight motion sequences have been set`
  String get eightmotionsequenceshavebeenset {
    return Intl.message(
      'eight motion sequences have been set',
      name: 'eightmotionsequenceshavebeenset',
      desc: '',
      args: [],
    );
  }

  /// `fourteen motion sequences have been set`
  String get fourteenmotionsequenceshavebeenset {
    return Intl.message(
      'fourteen motion sequences have been set',
      name: 'fourteenmotionsequenceshavebeenset',
      desc: '',
      args: [],
    );
  }

  /// `cold start`
  String get coldstart {
    return Intl.message(
      'cold start',
      name: 'coldstart',
      desc: '',
      args: [],
    );
  }

  /// `hot start`
  String get hotstart {
    return Intl.message(
      'hot start',
      name: 'hotstart',
      desc: '',
      args: [],
    );
  }

  /// `normal`
  String get normal {
    return Intl.message(
      'normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `low power`
  String get lowpower {
    return Intl.message(
      'low power',
      name: 'lowpower',
      desc: '',
      args: [],
    );
  }

  /// `balance`
  String get balance {
    return Intl.message(
      'balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `1pps`
  String get pps1 {
    return Intl.message(
      '1pps',
      name: 'pps1',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get GPS {
    return Intl.message(
      'GPS',
      name: 'GPS',
      desc: '',
      args: [],
    );
  }

  /// `GLONASS`
  String get GLONASS {
    return Intl.message(
      'GLONASS',
      name: 'GLONASS',
      desc: '',
      args: [],
    );
  }

  /// `GPS+GLONASS`
  String get GPSGLONASS {
    return Intl.message(
      'GPS+GLONASS',
      name: 'GPSGLONASS',
      desc: '',
      args: [],
    );
  }

  /// `crystal oscillation offset:`
  String get crystaloscillationoffset {
    return Intl.message(
      'crystal oscillation offset:',
      name: 'crystaloscillationoffset',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'longitude:' key

  // skipped getter for the 'latitude:' key

  /// `height:`
  String get height {
    return Intl.message(
      'height:',
      name: 'height',
      desc: '',
      args: [],
    );
  }

  /// `accurate to`
  String get accurateto {
    return Intl.message(
      'accurate to',
      name: 'accurateto',
      desc: '',
      args: [],
    );
  }

  /// `none`
  String get none {
    return Intl.message(
      'none',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `times`
  String get times {
    return Intl.message(
      'times',
      name: 'times',
      desc: '',
      args: [],
    );
  }

  /// `meter`
  String get meter {
    return Intl.message(
      'meter',
      name: 'meter',
      desc: '',
      args: [],
    );
  }

  /// `yard`
  String get yard {
    return Intl.message(
      'yard',
      name: 'yard',
      desc: '',
      args: [],
    );
  }

  /// `miles`
  String get miles {
    return Intl.message(
      'miles',
      name: 'miles',
      desc: '',
      args: [],
    );
  }

  /// `kilocalorie`
  String get kilocalorie {
    return Intl.message(
      'kilocalorie',
      name: 'kilocalorie',
      desc: '',
      args: [],
    );
  }

  /// `kilojoules`
  String get kilojoules {
    return Intl.message(
      'kilojoules',
      name: 'kilojoules',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `calories`
  String get calories {
    return Intl.message(
      'calories',
      name: 'calories',
      desc: '',
      args: [],
    );
  }

  /// `soft device`
  String get softdevice {
    return Intl.message(
      'soft device',
      name: 'softdevice',
      desc: '',
      args: [],
    );
  }

  /// `boot loader`
  String get bootloader {
    return Intl.message(
      'boot loader',
      name: 'bootloader',
      desc: '',
      args: [],
    );
  }

  /// `soft device boot loader`
  String get softdevicebootloader {
    return Intl.message(
      'soft device boot loader',
      name: 'softdevicebootloader',
      desc: '',
      args: [],
    );
  }

  /// `application`
  String get application {
    return Intl.message(
      'application',
      name: 'application',
      desc: '',
      args: [],
    );
  }

  /// `device switching`
  String get deviceswitching {
    return Intl.message(
      'device switching',
      name: 'deviceswitching',
      desc: '',
      args: [],
    );
  }

  /// `device switch failed`
  String get deviceswitchfailed {
    return Intl.message(
      'device switch failed',
      name: 'deviceswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `device switch success`
  String get deviceswitchsuccess {
    return Intl.message(
      'device switch success',
      name: 'deviceswitchsuccess',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'startdetectionencryptionauth...' key

  // skipped getter for the 'deviceencryptionauthcodedon\'tsame' key

  /// `mode`
  String get mode {
    return Intl.message(
      'mode',
      name: 'mode',
      desc: '',
      args: [],
    );
  }

  /// `update mode`
  String get updatemode {
    return Intl.message(
      'update mode',
      name: 'updatemode',
      desc: '',
      args: [],
    );
  }

  /// `normal mode`
  String get normalmode {
    return Intl.message(
      'normal mode',
      name: 'normalmode',
      desc: '',
      args: [],
    );
  }

  /// `set function`
  String get setfunction {
    return Intl.message(
      'set function',
      name: 'setfunction',
      desc: '',
      args: [],
    );
  }

  /// `get function`
  String get getfunction {
    return Intl.message(
      'get function',
      name: 'getfunction',
      desc: '',
      args: [],
    );
  }

  /// `control function`
  String get controlfunction {
    return Intl.message(
      'control function',
      name: 'controlfunction',
      desc: '',
      args: [],
    );
  }

  /// `sync function`
  String get syncfunction {
    return Intl.message(
      'sync function',
      name: 'syncfunction',
      desc: '',
      args: [],
    );
  }

  /// `data interchange`
  String get dataInterChange {
    return Intl.message(
      'data interchange',
      name: 'dataInterChange',
      desc: '',
      args: [],
    );
  }

  /// `data query`
  String get dataquery {
    return Intl.message(
      'data query',
      name: 'dataquery',
      desc: '',
      args: [],
    );
  }

  /// `log query`
  String get logquery {
    return Intl.message(
      'log query',
      name: 'logquery',
      desc: '',
      args: [],
    );
  }

  /// `data migration`
  String get datamigration {
    return Intl.message(
      'data migration',
      name: 'datamigration',
      desc: '',
      args: [],
    );
  }

  /// `set user info`
  String get setuserinfo {
    return Intl.message(
      'set user info',
      name: 'setuserinfo',
      desc: '',
      args: [],
    );
  }

  /// `set target info`
  String get settargetinfo {
    return Intl.message(
      'set target info',
      name: 'settargetinfo',
      desc: '',
      args: [],
    );
  }

  /// `set find phone`
  String get setfindphone {
    return Intl.message(
      'set find phone',
      name: 'setfindphone',
      desc: '',
      args: [],
    );
  }

  /// `set hand up identify`
  String get sethandupidentify {
    return Intl.message(
      'set hand up identify',
      name: 'sethandupidentify',
      desc: '',
      args: [],
    );
  }

  /// `set left right hand`
  String get setleftrighthand {
    return Intl.message(
      'set left right hand',
      name: 'setleftrighthand',
      desc: '',
      args: [],
    );
  }

  /// `set prevent lost`
  String get setpreventlost {
    return Intl.message(
      'set prevent lost',
      name: 'setpreventlost',
      desc: '',
      args: [],
    );
  }

  /// `set display mode`
  String get setdisplaymode {
    return Intl.message(
      'set display mode',
      name: 'setdisplaymode',
      desc: '',
      args: [],
    );
  }

  /// `set smart notfity`
  String get setsmartnotfity {
    return Intl.message(
      'set smart notfity',
      name: 'setsmartnotfity',
      desc: '',
      args: [],
    );
  }

  /// `set current time`
  String get setcurrenttime {
    return Intl.message(
      'set current time',
      name: 'setcurrenttime',
      desc: '',
      args: [],
    );
  }

  /// `set alarm remind`
  String get setalarmremind {
    return Intl.message(
      'set alarm remind',
      name: 'setalarmremind',
      desc: '',
      args: [],
    );
  }

  /// `set long sit remind`
  String get setlongsitremind {
    return Intl.message(
      'set long sit remind',
      name: 'setlongsitremind',
      desc: '',
      args: [],
    );
  }

  /// `set weather forecast`
  String get setweatherforecast {
    return Intl.message(
      'set weather forecast',
      name: 'setweatherforecast',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate mode`
  String get setheartratemode {
    return Intl.message(
      'set heart rate mode',
      name: 'setheartratemode',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate interval`
  String get setheartrateinterval {
    return Intl.message(
      'set heart rate interval',
      name: 'setheartrateinterval',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb mode`
  String get setnodisturbmode {
    return Intl.message(
      'set no disturb mode',
      name: 'setnodisturbmode',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setthedonotdisturbmodeswitch:' key

  /// `set device unit`
  String get setdeviceunit {
    return Intl.message(
      'set device unit',
      name: 'setdeviceunit',
      desc: '',
      args: [],
    );
  }

  /// `set one key sos`
  String get setonekeysos {
    return Intl.message(
      'set one key sos',
      name: 'setonekeysos',
      desc: '',
      args: [],
    );
  }

  /// `set shortcut mode`
  String get setshortcutmode {
    return Intl.message(
      'set shortcut mode',
      name: 'setshortcutmode',
      desc: '',
      args: [],
    );
  }

  /// `set blood pressure calibration`
  String get setbloodpressurecalibration {
    return Intl.message(
      'set blood pressure calibration',
      name: 'setbloodpressurecalibration',
      desc: '',
      args: [],
    );
  }

  /// `set sport shortcut`
  String get setsportshortcut {
    return Intl.message(
      'set sport shortcut',
      name: 'setsportshortcut',
      desc: '',
      args: [],
    );
  }

  /// `set sport mode sort`
  String get setsportmodesort {
    return Intl.message(
      'set sport mode sort',
      name: 'setsportmodesort',
      desc: '',
      args: [],
    );
  }

  /// `set screen brightness`
  String get setscreenbrightness {
    return Intl.message(
      'set screen brightness',
      name: 'setscreenbrightness',
      desc: '',
      args: [],
    );
  }

  /// `night brightness level:`
  String get nightbrightnesslevel {
    return Intl.message(
      'night brightness level:',
      name: 'nightbrightnesslevel',
      desc: '',
      args: [],
    );
  }

  /// `show interval:`
  String get showinterval {
    return Intl.message(
      'show interval:',
      name: 'showinterval',
      desc: '',
      args: [],
    );
  }

  /// `set music open off`
  String get setmusicopenoff {
    return Intl.message(
      'set music open off',
      name: 'setmusicopenoff',
      desc: '',
      args: [],
    );
  }

  /// `set gps info`
  String get setgpsinfo {
    return Intl.message(
      'set gps info',
      name: 'setgpsinfo',
      desc: '',
      args: [],
    );
  }

  /// `set hot start info`
  String get sethotstartinfo {
    return Intl.message(
      'set hot start info',
      name: 'sethotstartinfo',
      desc: '',
      args: [],
    );
  }

  /// `set dial parameters`
  String get setdialparameters {
    return Intl.message(
      'set dial parameters',
      name: 'setdialparameters',
      desc: '',
      args: [],
    );
  }

  /// `set sleep time`
  String get setsleeptime {
    return Intl.message(
      'set sleep time',
      name: 'setsleeptime',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation remind`
  String get setmenstruationremind {
    return Intl.message(
      'set menstruation remind',
      name: 'setmenstruationremind',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation parameter`
  String get setmenstruationparameter {
    return Intl.message(
      'set menstruation parameter',
      name: 'setmenstruationparameter',
      desc: '',
      args: [],
    );
  }

  /// `pregnancy day before remind:`
  String get pregnancydaybeforeremind {
    return Intl.message(
      'pregnancy day before remind:',
      name: 'pregnancydaybeforeremind',
      desc: '',
      args: [],
    );
  }

  /// `pregnancy day end remind:`
  String get pregnancydayendremind {
    return Intl.message(
      'pregnancy day end remind:',
      name: 'pregnancydayendremind',
      desc: '',
      args: [],
    );
  }

  /// `menstrual day end remind:`
  String get menstrualdayendremind {
    return Intl.message(
      'menstrual day end remind:',
      name: 'menstrualdayendremind',
      desc: '',
      args: [],
    );
  }

  /// `set message push`
  String get setmessagepush {
    return Intl.message(
      'set message push',
      name: 'setmessagepush',
      desc: '',
      args: [],
    );
  }

  /// `set user name`
  String get setusername {
    return Intl.message(
      'set user name',
      name: 'setusername',
      desc: '',
      args: [],
    );
  }

  /// `set user number`
  String get setusernumber {
    return Intl.message(
      'set user number',
      name: 'setusernumber',
      desc: '',
      args: [],
    );
  }

  /// `custom set func`
  String get customsetfunc {
    return Intl.message(
      'custom set func',
      name: 'customsetfunc',
      desc: '',
      args: [],
    );
  }

  /// `set user info annotation`
  String get setuserinfoannotation {
    return Intl.message(
      'set user info annotation',
      name: 'setuserinfoannotation',
      desc: '',
      args: [],
    );
  }

  /// `user id:`
  String get userid {
    return Intl.message(
      'user id:',
      name: 'userid',
      desc: '',
      args: [],
    );
  }

  /// `birthday:`
  String get birthday {
    return Intl.message(
      'birthday:',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `gender:`
  String get gender {
    return Intl.message(
      'gender:',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `man`
  String get man {
    return Intl.message(
      'man',
      name: 'man',
      desc: '',
      args: [],
    );
  }

  /// `woman`
  String get woman {
    return Intl.message(
      'woman',
      name: 'woman',
      desc: '',
      args: [],
    );
  }

  /// `weight:`
  String get weight {
    return Intl.message(
      'weight:',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `set user button`
  String get setuserbutton {
    return Intl.message(
      'set user button',
      name: 'setuserbutton',
      desc: '',
      args: [],
    );
  }

  /// `set target step(S):`
  String get setTargetStep {
    return Intl.message(
      'set target step(S):',
      name: 'setTargetStep',
      desc: '',
      args: [],
    );
  }

  /// `set target sleep(L):`
  String get setargetsleep {
    return Intl.message(
      'set target sleep(L):',
      name: 'setargetsleep',
      desc: '',
      args: [],
    );
  }

  /// `set target weight(W):`
  String get settargetweight {
    return Intl.message(
      'set target weight(W):',
      name: 'settargetweight',
      desc: '',
      args: [],
    );
  }

  /// `set target calorie(J):`
  String get settargetcalorie {
    return Intl.message(
      'set target calorie(J):',
      name: 'settargetcalorie',
      desc: '',
      args: [],
    );
  }

  /// `set target distance(M):`
  String get settargetdistance {
    return Intl.message(
      'set target distance(M):',
      name: 'settargetdistance',
      desc: '',
      args: [],
    );
  }

  /// `set target step|sleep|weight`
  String get settargetstep_sleep_weight {
    return Intl.message(
      'set target step|sleep|weight',
      name: 'settargetstep_sleep_weight',
      desc: '',
      args: [],
    );
  }

  /// `set target calorie|distance`
  String get settargetcalorie_distance {
    return Intl.message(
      'set target calorie|distance',
      name: 'settargetcalorie_distance',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'settargetinfo...' key

  /// `set target info success`
  String get settargetinfosuccess {
    return Intl.message(
      'set target info success',
      name: 'settargetinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `set target info failed`
  String get settargetinfofailed {
    return Intl.message(
      'set target info failed',
      name: 'settargetinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `set find phone switch`
  String get setfindphoneswitch {
    return Intl.message(
      'set find phone switch',
      name: 'setfindphoneswitch',
      desc: '',
      args: [],
    );
  }

  /// `set find phone button`
  String get setfindphonebutton {
    return Intl.message(
      'set find phone button',
      name: 'setfindphonebutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setfindphoneswitch...' key

  /// `set find phone success`
  String get setfindphonesuccess {
    return Intl.message(
      'set find phone success',
      name: 'setfindphonesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set find phone failed`
  String get setfindphonefailed {
    return Intl.message(
      'set find phone failed',
      name: 'setfindphonefailed',
      desc: '',
      args: [],
    );
  }

  /// `set hand up switch`
  String get sethandupswitch {
    return Intl.message(
      'set hand up switch',
      name: 'sethandupswitch',
      desc: '',
      args: [],
    );
  }

  /// `set show long time`
  String get setshowlongtime {
    return Intl.message(
      'set show long time',
      name: 'setshowlongtime',
      desc: '',
      args: [],
    );
  }

  /// `set time range`
  String get settimerange {
    return Intl.message(
      'set time range',
      name: 'settimerange',
      desc: '',
      args: [],
    );
  }

  /// `set start time`
  String get setstarttime {
    return Intl.message(
      'set start time',
      name: 'setstarttime',
      desc: '',
      args: [],
    );
  }

  /// `set end time`
  String get setendtime {
    return Intl.message(
      'set end time',
      name: 'setendtime',
      desc: '',
      args: [],
    );
  }

  /// `set hand up button`
  String get sethandupbutton {
    return Intl.message(
      'set hand up button',
      name: 'sethandupbutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'sethandupswitch...' key

  /// `set hand up success`
  String get sethandupsuccess {
    return Intl.message(
      'set hand up success',
      name: 'sethandupsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set hand up failed`
  String get sethandupfailed {
    return Intl.message(
      'set hand up failed',
      name: 'sethandupfailed',
      desc: '',
      args: [],
    );
  }

  /// `set left right hand switch`
  String get setleftrighthandswitch {
    return Intl.message(
      'set left right hand switch',
      name: 'setleftrighthandswitch',
      desc: '',
      args: [],
    );
  }

  /// `set left right hand button`
  String get setleftrighthandbutton {
    return Intl.message(
      'set left right hand button',
      name: 'setleftrighthandbutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setleftrightswitch...' key

  /// `set left right switch success`
  String get setleftrightswitchsuccess {
    return Intl.message(
      'set left right switch success',
      name: 'setleftrightswitchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set left right switch failed`
  String get setleftrightswitchfailed {
    return Intl.message(
      'set left right switch failed',
      name: 'setleftrightswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `no prevent lost`
  String get nopreventlost {
    return Intl.message(
      'no prevent lost',
      name: 'nopreventlost',
      desc: '',
      args: [],
    );
  }

  /// `near prevent lost`
  String get nearpreventlost {
    return Intl.message(
      'near prevent lost',
      name: 'nearpreventlost',
      desc: '',
      args: [],
    );
  }

  /// `mid distance prevent lost`
  String get middistancepreventlost {
    return Intl.message(
      'mid distance prevent lost',
      name: 'middistancepreventlost',
      desc: '',
      args: [],
    );
  }

  /// `far distance prevent lost`
  String get fardistancepreventlost {
    return Intl.message(
      'far distance prevent lost',
      name: 'fardistancepreventlost',
      desc: '',
      args: [],
    );
  }

  /// `set prevent lost button`
  String get setpreventlostbutton {
    return Intl.message(
      'set prevent lost button',
      name: 'setpreventlostbutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setpreventlostswitch...' key

  /// `set prevent lost success`
  String get setpreventlostsuccess {
    return Intl.message(
      'set prevent lost success',
      name: 'setpreventlostsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set prevent lost failed`
  String get setpreventlostfailed {
    return Intl.message(
      'set prevent lost failed',
      name: 'setpreventlostfailed',
      desc: '',
      args: [],
    );
  }

  /// `default`
  String get default1 {
    return Intl.message(
      'default',
      name: 'default1',
      desc: '',
      args: [],
    );
  }

  /// `cross screen`
  String get crossscreen {
    return Intl.message(
      'cross screen',
      name: 'crossscreen',
      desc: '',
      args: [],
    );
  }

  /// `vertical screen`
  String get verticalscreen {
    return Intl.message(
      'vertical screen',
      name: 'verticalscreen',
      desc: '',
      args: [],
    );
  }

  /// `rotate 180 degrees`
  String get rotate180degrees {
    return Intl.message(
      'rotate 180 degrees',
      name: 'rotate180degrees',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setdisplaymode...' key

  /// `set display mode success`
  String get setdisplaymodesuccess {
    return Intl.message(
      'set display mode success',
      name: 'setdisplaymodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set display mode failed`
  String get setdisplaymodefailed {
    return Intl.message(
      'set display mode failed',
      name: 'setdisplaymodefailed',
      desc: '',
      args: [],
    );
  }

  /// `feature is not supported on the current device`
  String get featureisnotsupportedonthecurrentdevice {
    return Intl.message(
      'feature is not supported on the current device',
      name: 'featureisnotsupportedonthecurrentdevice',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setpairing...' key

  /// `current device pairing success`
  String get currentdevicepairingsuccess {
    return Intl.message(
      'current device pairing success',
      name: 'currentdevicepairingsuccess',
      desc: '',
      args: [],
    );
  }

  /// `current device pairing failed`
  String get currentdevicepairingfailed {
    return Intl.message(
      'current device pairing failed',
      name: 'currentdevicepairingfailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setnoticeswitch...' key

  /// `set notice switch success`
  String get setnoticeswitchsuccess {
    return Intl.message(
      'set notice switch success',
      name: 'setnoticeswitchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set notice switch failed`
  String get setnoticeswitchfailed {
    return Intl.message(
      'set notice switch failed',
      name: 'setnoticeswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `first pairing bluetooth`
  String get firstpairingbluetooth {
    return Intl.message(
      'first pairing bluetooth',
      name: 'firstpairingbluetooth',
      desc: '',
      args: [],
    );
  }

  /// `set notice switch button`
  String get setnoticeswitchbutton {
    return Intl.message(
      'set notice switch button',
      name: 'setnoticeswitchbutton',
      desc: '',
      args: [],
    );
  }

  /// `current time`
  String get currenttime {
    return Intl.message(
      'current time',
      name: 'currenttime',
      desc: '',
      args: [],
    );
  }

  /// `system time zone`
  String get systemtimezone {
    return Intl.message(
      'system time zone',
      name: 'systemtimezone',
      desc: '',
      args: [],
    );
  }

  /// `set current time button`
  String get setcurrenttimebutton {
    return Intl.message(
      'set current time button',
      name: 'setcurrenttimebutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setcurrenttime...' key

  /// `set current time success`
  String get setcurrenttimesuccess {
    return Intl.message(
      'set current time success',
      name: 'setcurrenttimesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set current time failed`
  String get setcurrenttimefailed {
    return Intl.message(
      'set current time failed',
      name: 'setcurrenttimefailed',
      desc: '',
      args: [],
    );
  }

  /// `add alarm`
  String get addalarm {
    return Intl.message(
      'add alarm',
      name: 'addalarm',
      desc: '',
      args: [],
    );
  }

  /// `edit alarm`
  String get editalarm {
    return Intl.message(
      'edit alarm',
      name: 'editalarm',
      desc: '',
      args: [],
    );
  }

  /// `alarm`
  String get alarm {
    return Intl.message(
      'alarm',
      name: 'alarm',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time {
    return Intl.message(
      'time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `repeat`
  String get repeat {
    return Intl.message(
      'repeat',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setalarm...' key

  /// `set alarm success`
  String get setalarmsuccess {
    return Intl.message(
      'set alarm success',
      name: 'setalarmsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set alarm failed`
  String get setalarmfailed {
    return Intl.message(
      'set alarm failed',
      name: 'setalarmfailed',
      desc: '',
      args: [],
    );
  }

  /// `set alarm notice switch`
  String get setalarmnoticeswitch {
    return Intl.message(
      'set alarm notice switch',
      name: 'setalarmnoticeswitch',
      desc: '',
      args: [],
    );
  }

  /// `please synchronize the configuration first`
  String get pleasesynchronizetheconfigurationfirst {
    return Intl.message(
      'please synchronize the configuration first',
      name: 'pleasesynchronizetheconfigurationfirst',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'settime:' key

  /// `set long sit notice switch`
  String get setlongsitnoticeswitch {
    return Intl.message(
      'set long sit notice switch',
      name: 'setlongsitnoticeswitch',
      desc: '',
      args: [],
    );
  }

  /// `set how many minutes later notice`
  String get sethowmanyminuteslaternotice {
    return Intl.message(
      'set how many minutes later notice',
      name: 'sethowmanyminuteslaternotice',
      desc: '',
      args: [],
    );
  }

  /// `set long sit notice button`
  String get setlongsitnoticebutton {
    return Intl.message(
      'set long sit notice button',
      name: 'setlongsitnoticebutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setlongsitnotice...' key

  /// `set long sit notice success`
  String get setlongsitnoticesuccess {
    return Intl.message(
      'set long sit notice success',
      name: 'setlongsitnoticesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set long sit notice failed`
  String get setlongsitnoticefailed {
    return Intl.message(
      'set long sit notice failed',
      name: 'setlongsitnoticefailed',
      desc: '',
      args: [],
    );
  }

  /// `set weather forecast switch`
  String get setweatherforecastswitch {
    return Intl.message(
      'set weather forecast switch',
      name: 'setweatherforecastswitch',
      desc: '',
      args: [],
    );
  }

  /// `set weather forecast button`
  String get setweatherforecastbutton {
    return Intl.message(
      'set weather forecast button',
      name: 'setweatherforecastbutton',
      desc: '',
      args: [],
    );
  }

  /// `set weather data`
  String get setweatherdata {
    return Intl.message(
      'set weather data',
      name: 'setweatherdata',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setweatherforecastswitch...' key

  /// `set weather forecast failed`
  String get setweatherforecastfailed {
    return Intl.message(
      'set weather forecast failed',
      name: 'setweatherforecastfailed',
      desc: '',
      args: [],
    );
  }

  /// `set weather forecast success`
  String get setweatherforecastsuccess {
    return Intl.message(
      'set weather forecast success',
      name: 'setweatherforecastsuccess',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setweatherforecastdata...' key

  /// `set weather data success`
  String get setweatherdatasuccess {
    return Intl.message(
      'set weather data success',
      name: 'setweatherdatasuccess',
      desc: '',
      args: [],
    );
  }

  /// `set weather data failed`
  String get setweatherdatafailed {
    return Intl.message(
      'set weather data failed',
      name: 'setweatherdatafailed',
      desc: '',
      args: [],
    );
  }

  /// `heart rate mode:`
  String get heartratemode {
    return Intl.message(
      'heart rate mode:',
      name: 'heartratemode',
      desc: '',
      args: [],
    );
  }

  /// `heart rate time range`
  String get heartratetimerange {
    return Intl.message(
      'heart rate time range',
      name: 'heartratetimerange',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate mode button`
  String get setheartratemodebutton {
    return Intl.message(
      'set heart rate mode button',
      name: 'setheartratemodebutton',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setheartratemode...' key

  /// `set heart rate mode success`
  String get setheartratemodesuccess {
    return Intl.message(
      'set heart rate mode success',
      name: 'setheartratemodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate mode failed`
  String get setheartratemodefailed {
    return Intl.message(
      'set heart rate mode failed',
      name: 'setheartratemodefailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setheartrateinterval...' key

  /// `set heart rate interval success`
  String get setheartrateintervalsuccess {
    return Intl.message(
      'set heart rate interval success',
      name: 'setheartrateintervalsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate interval failed`
  String get setheartrateintervalfailed {
    return Intl.message(
      'set heart rate interval failed',
      name: 'setheartrateintervalfailed',
      desc: '',
      args: [],
    );
  }

  /// `min heart rate`
  String get minheartrate {
    return Intl.message(
      'min heart rate',
      name: 'minheartrate',
      desc: '',
      args: [],
    );
  }

  /// `set max hr remind switch`
  String get setmaxhrremindswitch {
    return Intl.message(
      'set max hr remind switch',
      name: 'setmaxhrremindswitch',
      desc: '',
      args: [],
    );
  }

  /// `set min hr remind switch`
  String get setminhrremindswitch {
    return Intl.message(
      'set min hr remind switch',
      name: 'setminhrremindswitch',
      desc: '',
      args: [],
    );
  }

  /// `burn fat:`
  String get burnFat {
    return Intl.message(
      'burn fat:',
      name: 'burnFat',
      desc: '',
      args: [],
    );
  }

  /// `aerobic exercise:`
  String get aerobicExercise {
    return Intl.message(
      'aerobic exercise:',
      name: 'aerobicExercise',
      desc: '',
      args: [],
    );
  }

  /// `warm up:`
  String get warmup {
    return Intl.message(
      'warm up:',
      name: 'warmup',
      desc: '',
      args: [],
    );
  }

  /// `anaerobic exercise:`
  String get anaerobicExercise {
    return Intl.message(
      'anaerobic exercise:',
      name: 'anaerobicExercise',
      desc: '',
      args: [],
    );
  }

  /// `extreme exercise:`
  String get extremeExercise {
    return Intl.message(
      'extreme exercise:',
      name: 'extremeExercise',
      desc: '',
      args: [],
    );
  }

  /// `max heart rate:`
  String get maxHeartRate {
    return Intl.message(
      'max heart rate:',
      name: 'maxHeartRate',
      desc: '',
      args: [],
    );
  }

  /// `set heart rate interval button`
  String get setHeartRateIntervalButton {
    return Intl.message(
      'set heart rate interval button',
      name: 'setHeartRateIntervalButton',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `tip`
  String get tip {
    return Intl.message(
      'tip',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `please enter the verification code`
  String get pleaseentertheverificationcode {
    return Intl.message(
      'please enter the verification code',
      name: 'pleaseentertheverificationcode',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `query data`
  String get querydata {
    return Intl.message(
      'query data',
      name: 'querydata',
      desc: '',
      args: [],
    );
  }

  /// `please enable bluetooth to continue using the current app`
  String get pleaseenablebluetoothtocontinueusingthecurrentapp {
    return Intl.message(
      'please enable bluetooth to continue using the current app',
      name: 'pleaseenablebluetoothtocontinueusingthecurrentapp',
      desc: '',
      args: [],
    );
  }

  /// `show log`
  String get showlog {
    return Intl.message(
      'show log',
      name: 'showlog',
      desc: '',
      args: [],
    );
  }

  /// `simulator data`
  String get simulatordata {
    return Intl.message(
      'simulator data',
      name: 'simulatordata',
      desc: '',
      args: [],
    );
  }

  /// `is response`
  String get isresponse {
    return Intl.message(
      'is response',
      name: 'isresponse',
      desc: '',
      args: [],
    );
  }

  /// `is set connection parameters`
  String get issetconnectionparameters {
    return Intl.message(
      'is set connection parameters',
      name: 'issetconnectionparameters',
      desc: '',
      args: [],
    );
  }

  /// `set drink water reminder`
  String get setdrinkwaterreminder {
    return Intl.message(
      'set drink water reminder',
      name: 'setdrinkwaterreminder',
      desc: '',
      args: [],
    );
  }

  /// `Take medicine reminder switch`
  String get takeMedicineReminderSwitch {
    return Intl.message(
      'Take medicine reminder switch',
      name: 'takeMedicineReminderSwitch',
      desc: '',
      args: [],
    );
  }

  /// `Editor Take Medicine Reminder`
  String get editorTakeMedicineReminder {
    return Intl.message(
      'Editor Take Medicine Reminder',
      name: 'editorTakeMedicineReminder',
      desc: '',
      args: [],
    );
  }

  /// `set interval length`
  String get setintervallength {
    return Intl.message(
      'set interval length',
      name: 'setintervallength',
      desc: '',
      args: [],
    );
  }

  /// `set interval second length`
  String get setintervalsecondlength {
    return Intl.message(
      'set interval second length',
      name: 'setintervalsecondlength',
      desc: '',
      args: [],
    );
  }

  /// `set drink water reminder success`
  String get setdrinkwaterremindersuccess {
    return Intl.message(
      'set drink water reminder success',
      name: 'setdrinkwaterremindersuccess',
      desc: '',
      args: [],
    );
  }

  /// `set drink water reminder failed`
  String get setdrinkwaterreminderfailed {
    return Intl.message(
      'set drink water reminder failed',
      name: 'setdrinkwaterreminderfailed',
      desc: '',
      args: [],
    );
  }

  /// `high heart rate reminder switch`
  String get highheartratereminderswitch {
    return Intl.message(
      'high heart rate reminder switch',
      name: 'highheartratereminderswitch',
      desc: '',
      args: [],
    );
  }

  /// `heart rate too high threshold`
  String get heartratetoohighthreshold {
    return Intl.message(
      'heart rate too high threshold',
      name: 'heartratetoohighthreshold',
      desc: '',
      args: [],
    );
  }

  /// `low heart rate reminder switch`
  String get lowheartratereminderswitch {
    return Intl.message(
      'low heart rate reminder switch',
      name: 'lowheartratereminderswitch',
      desc: '',
      args: [],
    );
  }

  /// `heart rate too low threshold`
  String get heartratetoolowthreshold {
    return Intl.message(
      'heart rate too low threshold',
      name: 'heartratetoolowthreshold',
      desc: '',
      args: [],
    );
  }

  /// `set v3 heart rate mode`
  String get setv3heartratemode {
    return Intl.message(
      'set v3 heart rate mode',
      name: 'setv3heartratemode',
      desc: '',
      args: [],
    );
  }

  /// `set v3 heart rate mode success`
  String get setv3heartratemodesuccess {
    return Intl.message(
      'set v3 heart rate mode success',
      name: 'setv3heartratemodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set v3 heart rate mode failed`
  String get setv3heartratemodefailed {
    return Intl.message(
      'set v3 heart rate mode failed',
      name: 'setv3heartratemodefailed',
      desc: '',
      args: [],
    );
  }

  /// `walk on off`
  String get walkonoff {
    return Intl.message(
      'walk on off',
      name: 'walkonoff',
      desc: '',
      args: [],
    );
  }

  /// `run on off`
  String get runonoff {
    return Intl.message(
      'run on off',
      name: 'runonoff',
      desc: '',
      args: [],
    );
  }

  /// `bicycle on off`
  String get bicycleonoff {
    return Intl.message(
      'bicycle on off',
      name: 'bicycleonoff',
      desc: '',
      args: [],
    );
  }

  /// `auto pause on off`
  String get autopauseonoff {
    return Intl.message(
      'auto pause on off',
      name: 'autopauseonoff',
      desc: '',
      args: [],
    );
  }

  /// `end remind on off`
  String get endremindonoff {
    return Intl.message(
      'end remind on off',
      name: 'endremindonoff',
      desc: '',
      args: [],
    );
  }

  /// `set sport identify switch`
  String get setsportidentifyswitch {
    return Intl.message(
      'set sport identify switch',
      name: 'setsportidentifyswitch',
      desc: '',
      args: [],
    );
  }

  /// `set sport identify switch success`
  String get setsportidentifyswitchsuccess {
    return Intl.message(
      'set sport identify switch success',
      name: 'setsportidentifyswitchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set sport identify switch failed`
  String get setsportidentifyswitchfailed {
    return Intl.message(
      'set sport identify switch failed',
      name: 'setsportidentifyswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `auto elliptical machine switch`
  String get autoellipticalmachineswitch {
    return Intl.message(
      'auto elliptical machine switch',
      name: 'autoellipticalmachineswitch',
      desc: '',
      args: [],
    );
  }

  /// `auto rowing machine switch`
  String get autorowingmachineswitch {
    return Intl.message(
      'auto rowing machine switch',
      name: 'autorowingmachineswitch',
      desc: '',
      args: [],
    );
  }

  /// `auto swimming switch`
  String get autoswimmingswitch {
    return Intl.message(
      'auto swimming switch',
      name: 'autoswimmingswitch',
      desc: '',
      args: [],
    );
  }

  /// `set spo2 switch`
  String get setspo2switch {
    return Intl.message(
      'set spo2 switch',
      name: 'setspo2switch',
      desc: '',
      args: [],
    );
  }

  /// `low blood oxygen switch`
  String get lowbloodoxygenswitch {
    return Intl.message(
      'low blood oxygen switch',
      name: 'lowbloodoxygenswitch',
      desc: '',
      args: [],
    );
  }

  /// `low blood oxygen threshold`
  String get lowbloodoxygenthreshold {
    return Intl.message(
      'low blood oxygen threshold',
      name: 'lowbloodoxygenthreshold',
      desc: '',
      args: [],
    );
  }

  /// `set spo2 switch success`
  String get setspo2switchsuccess {
    return Intl.message(
      'set spo2 switch success',
      name: 'setspo2switchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set spo2 switch failed`
  String get setspo2switchfailed {
    return Intl.message(
      'set spo2 switch failed',
      name: 'setspo2switchfailed',
      desc: '',
      args: [],
    );
  }

  /// `set breathe train`
  String get setbreathetrain {
    return Intl.message(
      'set breathe train',
      name: 'setbreathetrain',
      desc: '',
      args: [],
    );
  }

  /// `set breathe train success`
  String get setbreathetrainsuccess {
    return Intl.message(
      'set breathe train success',
      name: 'setbreathetrainsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set breathe train failed`
  String get setbreathetrainfailed {
    return Intl.message(
      'set breathe train failed',
      name: 'setbreathetrainfailed',
      desc: '',
      args: [],
    );
  }

  /// `set walk reminder`
  String get setwalkreminder {
    return Intl.message(
      'set walk reminder',
      name: 'setwalkreminder',
      desc: '',
      args: [],
    );
  }

  /// `set walk reminder target`
  String get setwalkremindertarget {
    return Intl.message(
      'set walk reminder target',
      name: 'setwalkremindertarget',
      desc: '',
      args: [],
    );
  }

  /// `set a target time`
  String get setatargettime {
    return Intl.message(
      'set a target time',
      name: 'setatargettime',
      desc: '',
      args: [],
    );
  }

  /// `set walk reminder success`
  String get setwalkremindersuccess {
    return Intl.message(
      'set walk reminder success',
      name: 'setwalkremindersuccess',
      desc: '',
      args: [],
    );
  }

  /// `set walk reminder failed`
  String get setwalkreminderfailed {
    return Intl.message(
      'set walk reminder failed',
      name: 'setwalkreminderfailed',
      desc: '',
      args: [],
    );
  }

  /// `set pressure switch`
  String get setpressureswitch {
    return Intl.message(
      'set pressure switch',
      name: 'setpressureswitch',
      desc: '',
      args: [],
    );
  }

  /// `high pressure threshold`
  String get highpressurethreshold {
    return Intl.message(
      'high pressure threshold',
      name: 'highpressurethreshold',
      desc: '',
      args: [],
    );
  }

  /// `set pressure switch success`
  String get setpressureswitchsuccess {
    return Intl.message(
      'set pressure switch success',
      name: 'setpressureswitchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set pressure switch failed`
  String get setpressureswitchfailed {
    return Intl.message(
      'set pressure switch failed',
      name: 'setpressureswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `set pressure reminder switch`
  String get setpressurereminderswitch {
    return Intl.message(
      'set pressure reminder switch',
      name: 'setpressurereminderswitch',
      desc: '',
      args: [],
    );
  }

  /// `set wash hand reminder switch`
  String get setwashhandreminderswitch {
    return Intl.message(
      'set wash hand reminder switch',
      name: 'setwashhandreminderswitch',
      desc: '',
      args: [],
    );
  }

  /// `set wash hand reminder`
  String get setwashhandreminder {
    return Intl.message(
      'set wash hand reminder',
      name: 'setwashhandreminder',
      desc: '',
      args: [],
    );
  }

  /// `set wash hand reminder success`
  String get setwashhandremindersuccess {
    return Intl.message(
      'set wash hand reminder success',
      name: 'setwashhandremindersuccess',
      desc: '',
      args: [],
    );
  }

  /// `set wash hand reminder failed`
  String get setwashhandreminderfailed {
    return Intl.message(
      'set wash hand reminder failed',
      name: 'setwashhandreminderfailed',
      desc: '',
      args: [],
    );
  }

  /// `auth code error`
  String get authcodeerror {
    return Intl.message(
      'auth code error',
      name: 'authcodeerror',
      desc: '',
      args: [],
    );
  }

  /// `add devices`
  String get adddevices {
    return Intl.message(
      'add devices',
      name: 'adddevices',
      desc: '',
      args: [],
    );
  }

  /// `scan add devices`
  String get scanadddevices {
    return Intl.message(
      'scan add devices',
      name: 'scanadddevices',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb mode switch：`
  String get setnodisturbmodeswitch {
    return Intl.message(
      'set no disturb mode switch：',
      name: 'setnodisturbmodeswitch',
      desc: '',
      args: [],
    );
  }

  /// `nodisturb Switch:`
  String get nodisturbSwitch {
    return Intl.message(
      'nodisturb Switch:',
      name: 'nodisturbSwitch',
      desc: '',
      args: [],
    );
  }

  /// `nodisturb Start Time:`
  String get nodisturbStartTime {
    return Intl.message(
      'nodisturb Start Time:',
      name: 'nodisturbStartTime',
      desc: '',
      args: [],
    );
  }

  /// `nodisturb Stop Time:`
  String get nodisturbStopTime {
    return Intl.message(
      'nodisturb Stop Time:',
      name: 'nodisturbStopTime',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb mode success`
  String get setnodisturbmodesuccess {
    return Intl.message(
      'set no disturb mode success',
      name: 'setnodisturbmodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb mode failed`
  String get setnodisturbmodefailed {
    return Intl.message(
      'set no disturb mode failed',
      name: 'setnodisturbmodefailed',
      desc: '',
      args: [],
    );
  }

  /// `set device unit success`
  String get setdeviceunitsuccess {
    return Intl.message(
      'set device unit success',
      name: 'setdeviceunitsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set device unit failed`
  String get setdeviceunitfailed {
    return Intl.message(
      'set device unit failed',
      name: 'setdeviceunitfailed',
      desc: '',
      args: [],
    );
  }

  /// `one key sos switch:`
  String get onekeysosswitch {
    return Intl.message(
      'one key sos switch:',
      name: 'onekeysosswitch',
      desc: '',
      args: [],
    );
  }

  /// `set one key sos switch`
  String get setonekeysosswitch {
    return Intl.message(
      'set one key sos switch',
      name: 'setonekeysosswitch',
      desc: '',
      args: [],
    );
  }

  /// `set one key sos switch success`
  String get setonekeysosswitchsuccess {
    return Intl.message(
      'set one key sos switch success',
      name: 'setonekeysosswitchsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set one key sos switch failed`
  String get setonekeysosswitchfailed {
    return Intl.message(
      'set one key sos switch failed',
      name: 'setonekeysosswitchfailed',
      desc: '',
      args: [],
    );
  }

  /// `fast into the photo control`
  String get fastintothephotocontrol {
    return Intl.message(
      'fast into the photo control',
      name: 'fastintothephotocontrol',
      desc: '',
      args: [],
    );
  }

  /// `fast into sport mode`
  String get fastintosportmode {
    return Intl.message(
      'fast into sport mode',
      name: 'fastintosportmode',
      desc: '',
      args: [],
    );
  }

  /// `fast into no disturb mode`
  String get fastintonodisturbmode {
    return Intl.message(
      'fast into no disturb mode',
      name: 'fastintonodisturbmode',
      desc: '',
      args: [],
    );
  }

  /// `set shortcut mode success`
  String get setshortcutmodesuccess {
    return Intl.message(
      'set shortcut mode success',
      name: 'setshortcutmodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set shortcut mode failed`
  String get setshortcutmodefailed {
    return Intl.message(
      'set shortcut mode failed',
      name: 'setshortcutmodefailed',
      desc: '',
      args: [],
    );
  }

  /// `diastolic`
  String get diastolic {
    return Intl.message(
      'diastolic',
      name: 'diastolic',
      desc: '',
      args: [],
    );
  }

  /// `shrinkage`
  String get shrinkage {
    return Intl.message(
      'shrinkage',
      name: 'shrinkage',
      desc: '',
      args: [],
    );
  }

  /// `set blood pressure data`
  String get setbloodpressuredata {
    return Intl.message(
      'set blood pressure data',
      name: 'setbloodpressuredata',
      desc: '',
      args: [],
    );
  }

  /// `set blood pressure data success`
  String get setbloodpressuredatasuccess {
    return Intl.message(
      'set blood pressure data success',
      name: 'setbloodpressuredatasuccess',
      desc: '',
      args: [],
    );
  }

  /// `set blood pressure data failed`
  String get setbloodpressuredatafailed {
    return Intl.message(
      'set blood pressure data failed',
      name: 'setbloodpressuredatafailed',
      desc: '',
      args: [],
    );
  }

  /// `most support`
  String get mostsupport {
    return Intl.message(
      'most support',
      name: 'mostsupport',
      desc: '',
      args: [],
    );
  }

  /// `type`
  String get type {
    return Intl.message(
      'type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `this feature is not supported on the current device`
  String get thisfeatureisnotsupportedonthecurrentdevice {
    return Intl.message(
      'this feature is not supported on the current device',
      name: 'thisfeatureisnotsupportedonthecurrentdevice',
      desc: '',
      args: [],
    );
  }

  /// `set sport shortcuts`
  String get setsportshortcuts {
    return Intl.message(
      'set sport shortcuts',
      name: 'setsportshortcuts',
      desc: '',
      args: [],
    );
  }

  /// `set sport shortcuts success`
  String get setsportshortcutssuccess {
    return Intl.message(
      'set sport shortcuts success',
      name: 'setsportshortcutssuccess',
      desc: '',
      args: [],
    );
  }

  /// `set sport shortcuts failed`
  String get setsportshortcutsfailed {
    return Intl.message(
      'set sport shortcuts failed',
      name: 'setsportshortcutsfailed',
      desc: '',
      args: [],
    );
  }

  /// `edit`
  String get edit {
    return Intl.message(
      'edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `complete`
  String get complete {
    return Intl.message(
      'complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `set sports mode sort`
  String get setsportsmodesort {
    return Intl.message(
      'set sports mode sort',
      name: 'setsportsmodesort',
      desc: '',
      args: [],
    );
  }

  /// `set sports mode sort success`
  String get setsportsmodesortsuccess {
    return Intl.message(
      'set sports mode sort success',
      name: 'setsportsmodesortsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set sports mode sort failed`
  String get setsportsmodesortfailed {
    return Intl.message(
      'set sports mode sort failed',
      name: 'setsportsmodesortfailed',
      desc: '',
      args: [],
    );
  }

  /// `set screen brightness success`
  String get setscreenbrightnesssuccess {
    return Intl.message(
      'set screen brightness success',
      name: 'setscreenbrightnesssuccess',
      desc: '',
      args: [],
    );
  }

  /// `set screen brightness failed`
  String get setscreenbrightnessfailed {
    return Intl.message(
      'set screen brightness failed',
      name: 'setscreenbrightnessfailed',
      desc: '',
      args: [],
    );
  }

  /// `screen brightness level:`
  String get screenbrightnesslevel {
    return Intl.message(
      'screen brightness level:',
      name: 'screenbrightnesslevel',
      desc: '',
      args: [],
    );
  }

  /// `set is manual switch:`
  String get setismanualswitch {
    return Intl.message(
      'set is manual switch:',
      name: 'setismanualswitch',
      desc: '',
      args: [],
    );
  }

  /// `set screen mode:`
  String get setscreenmode {
    return Intl.message(
      'set screen mode:',
      name: 'setscreenmode',
      desc: '',
      args: [],
    );
  }

  /// `turn off auto tune`
  String get turnoffautotune {
    return Intl.message(
      'turn off auto tune',
      name: 'turnoffautotune',
      desc: '',
      args: [],
    );
  }

  /// `use ambient light sensors`
  String get useambientlightsensors {
    return Intl.message(
      'use ambient light sensors',
      name: 'useambientlightsensors',
      desc: '',
      args: [],
    );
  }

  /// `auto brightness at night`
  String get autobrightnessatnight {
    return Intl.message(
      'auto brightness at night',
      name: 'autobrightnessatnight',
      desc: '',
      args: [],
    );
  }

  /// `set time for night dimming`
  String get settimefornightdimming {
    return Intl.message(
      'set time for night dimming',
      name: 'settimefornightdimming',
      desc: '',
      args: [],
    );
  }

  /// `set music open off success`
  String get setmusicopenoffsuccess {
    return Intl.message(
      'set music open off success',
      name: 'setmusicopenoffsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set music open off failed`
  String get setmusicopenofffailed {
    return Intl.message(
      'set music open off failed',
      name: 'setmusicopenofffailed',
      desc: '',
      args: [],
    );
  }

  /// `set GPS configuration information`
  String get setGPSconfigurationinformation {
    return Intl.message(
      'set GPS configuration information',
      name: 'setGPSconfigurationinformation',
      desc: '',
      args: [],
    );
  }

  /// `set GPS configuration information success`
  String get setGPSconfigurationinformationsuccess {
    return Intl.message(
      'set GPS configuration information success',
      name: 'setGPSconfigurationinformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set GPS configuration information failed`
  String get setGPSconfigurationinformationfailed {
    return Intl.message(
      'set GPS configuration information failed',
      name: 'setGPSconfigurationinformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `set hot start information`
  String get sethotstartinformation {
    return Intl.message(
      'set hot start information',
      name: 'sethotstartinformation',
      desc: '',
      args: [],
    );
  }

  /// `set hot start information success`
  String get sethotstartinformationsuccess {
    return Intl.message(
      'set hot start information success',
      name: 'sethotstartinformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set hot start information failed`
  String get sethotstartinformationfailed {
    return Intl.message(
      'set hot start information failed',
      name: 'sethotstartinformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `set dial parameters success`
  String get setdialparameterssuccess {
    return Intl.message(
      'set dial parameters success',
      name: 'setdialparameterssuccess',
      desc: '',
      args: [],
    );
  }

  /// `set dial parameters failed`
  String get setdialparametersfailed {
    return Intl.message(
      'set dial parameters failed',
      name: 'setdialparametersfailed',
      desc: '',
      args: [],
    );
  }

  /// `set sleep time success`
  String get setsleeptimesuccess {
    return Intl.message(
      'set sleep time success',
      name: 'setsleeptimesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set sleep time failed`
  String get setsleeptimefailed {
    return Intl.message(
      'set sleep time failed',
      name: 'setsleeptimefailed',
      desc: '',
      args: [],
    );
  }

  /// `set sleep time switch:`
  String get setsleeptimeswitch {
    return Intl.message(
      'set sleep time switch:',
      name: 'setsleeptimeswitch',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation parameter success`
  String get setmenstruationparametersuccess {
    return Intl.message(
      'set menstruation parameter success',
      name: 'setmenstruationparametersuccess',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation parameter failed`
  String get setmenstruationparameterfailed {
    return Intl.message(
      'set menstruation parameter failed',
      name: 'setmenstruationparameterfailed',
      desc: '',
      args: [],
    );
  }

  /// `menstrual switch：`
  String get menstrualswitch {
    return Intl.message(
      'menstrual switch：',
      name: 'menstrualswitch',
      desc: '',
      args: [],
    );
  }

  /// `menstrual length：`
  String get menstruallength {
    return Intl.message(
      'menstrual length：',
      name: 'menstruallength',
      desc: '',
      args: [],
    );
  }

  /// `menstrual cycle：`
  String get menstrualcycle {
    return Intl.message(
      'menstrual cycle：',
      name: 'menstrualcycle',
      desc: '',
      args: [],
    );
  }

  /// `recently menstrual：`
  String get recentlymenstrual {
    return Intl.message(
      'recently menstrual：',
      name: 'recentlymenstrual',
      desc: '',
      args: [],
    );
  }

  /// `interval between ovulation days:`
  String get intervalbetweenovulationdays {
    return Intl.message(
      'interval between ovulation days:',
      name: 'intervalbetweenovulationdays',
      desc: '',
      args: [],
    );
  }

  /// `day before menstrual:`
  String get daybeforemenstrual {
    return Intl.message(
      'day before menstrual:',
      name: 'daybeforemenstrual',
      desc: '',
      args: [],
    );
  }

  /// `day after menstrual:`
  String get dayaftermenstrual {
    return Intl.message(
      'day after menstrual:',
      name: 'dayaftermenstrual',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation remind success`
  String get setmenstruationremindsuccess {
    return Intl.message(
      'set menstruation remind success',
      name: 'setmenstruationremindsuccess',
      desc: '',
      args: [],
    );
  }

  /// `notify flag`
  String get notifyflag {
    return Intl.message(
      'notify flag',
      name: 'notifyflag',
      desc: '',
      args: [],
    );
  }

  /// `set menstruation remind failed`
  String get setmenstruationremindfailed {
    return Intl.message(
      'set menstruation remind failed',
      name: 'setmenstruationremindfailed',
      desc: '',
      args: [],
    );
  }

  /// `start date reminder days in advance:`
  String get startdatereminderdaysinadvance {
    return Intl.message(
      'start date reminder days in advance:',
      name: 'startdatereminderdaysinadvance',
      desc: '',
      args: [],
    );
  }

  /// `ovulation days are reminded days in advance:`
  String get ovulationdaysareremindeddaysinadvance {
    return Intl.message(
      'ovulation days are reminded days in advance:',
      name: 'ovulationdaysareremindeddaysinadvance',
      desc: '',
      args: [],
    );
  }

  /// `remind the time:`
  String get remindthetime {
    return Intl.message(
      'remind the time:',
      name: 'remindthetime',
      desc: '',
      args: [],
    );
  }

  /// `set the number of stars`
  String get setthenumberofstars {
    return Intl.message(
      'set the number of stars',
      name: 'setthenumberofstars',
      desc: '',
      args: [],
    );
  }

  /// `set the number of stars success`
  String get setthenumberofstarssuccess {
    return Intl.message(
      'set the number of stars success',
      name: 'setthenumberofstarssuccess',
      desc: '',
      args: [],
    );
  }

  /// `set the number of stars failed`
  String get setthenumberofstarsfailed {
    return Intl.message(
      'set the number of stars failed',
      name: 'setthenumberofstarsfailed',
      desc: '',
      args: [],
    );
  }

  /// `set message content`
  String get setmessagecontent {
    return Intl.message(
      'set message content',
      name: 'setmessagecontent',
      desc: '',
      args: [],
    );
  }

  /// `set message push success`
  String get setmessagepushsuccess {
    return Intl.message(
      'set message push success',
      name: 'setmessagepushsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set message push failed`
  String get setmessagepushfailed {
    return Intl.message(
      'set message push failed',
      name: 'setmessagepushfailed',
      desc: '',
      args: [],
    );
  }

  /// `set user name success`
  String get setusernamesuccess {
    return Intl.message(
      'set user name success',
      name: 'setusernamesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set user name failed`
  String get setusernamefailed {
    return Intl.message(
      'set user name failed',
      name: 'setusernamefailed',
      desc: '',
      args: [],
    );
  }

  /// `set user number success`
  String get setusernumbersuccess {
    return Intl.message(
      'set user number success',
      name: 'setusernumbersuccess',
      desc: '',
      args: [],
    );
  }

  /// `set user number failed`
  String get setusernumberfailed {
    return Intl.message(
      'set user number failed',
      name: 'setusernumberfailed',
      desc: '',
      args: [],
    );
  }

  /// `send prompt message`
  String get sendpromptmessage {
    return Intl.message(
      'send prompt message',
      name: 'sendpromptmessage',
      desc: '',
      args: [],
    );
  }

  /// `get watch screen info`
  String get getwatchscreeninfo {
    return Intl.message(
      'get watch screen info',
      name: 'getwatchscreeninfo',
      desc: '',
      args: [],
    );
  }

  /// `get watch screen info success`
  String get getwatchscreeninfosuccess {
    return Intl.message(
      'get watch screen info success',
      name: 'getwatchscreeninfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get watch screen info failed`
  String get getwatchscreeninfofailed {
    return Intl.message(
      'get watch screen info failed',
      name: 'getwatchscreeninfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial list info`
  String get getwatchdiallistinfo {
    return Intl.message(
      'get watch dial list info',
      name: 'getwatchdiallistinfo',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial list info success`
  String get getwatchdiallistinfosuccess {
    return Intl.message(
      'get watch dial list info success',
      name: 'getwatchdiallistinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial list info failed`
  String get getwatchdiallistinfofailed {
    return Intl.message(
      'get watch dial list info failed',
      name: 'getwatchdiallistinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial name`
  String get getwatchdialname {
    return Intl.message(
      'get watch dial name',
      name: 'getwatchdialname',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial name success`
  String get getwatchdialnamesuccess {
    return Intl.message(
      'get watch dial name success',
      name: 'getwatchdialnamesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get watch dial name failed`
  String get getwatchdialnamefailed {
    return Intl.message(
      'get watch dial name failed',
      name: 'getwatchdialnamefailed',
      desc: '',
      args: [],
    );
  }

  /// `set current dial info`
  String get setcurrentdialinfo {
    return Intl.message(
      'set current dial info',
      name: 'setcurrentdialinfo',
      desc: '',
      args: [],
    );
  }

  /// `current dial has been deleted`
  String get currentdialhasbeendeleted {
    return Intl.message(
      'current dial has been deleted',
      name: 'currentdialhasbeendeleted',
      desc: '',
      args: [],
    );
  }

  /// `set current dial info success`
  String get setcurrentdialinfosuccess {
    return Intl.message(
      'set current dial info success',
      name: 'setcurrentdialinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `set current dial info failed`
  String get setcurrentdialinfofailed {
    return Intl.message(
      'set current dial info failed',
      name: 'setcurrentdialinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `transfer dial file`
  String get transferdialfile {
    return Intl.message(
      'transfer dial file',
      name: 'transferdialfile',
      desc: '',
      args: [],
    );
  }

  /// `transfer dial file success`
  String get transferdialfilesuccess {
    return Intl.message(
      'transfer dial file success',
      name: 'transferdialfilesuccess',
      desc: '',
      args: [],
    );
  }

  /// `transfer dial file failed`
  String get transferdialfilefailed {
    return Intl.message(
      'transfer dial file failed',
      name: 'transferdialfilefailed',
      desc: '',
      args: [],
    );
  }

  /// `watch dial function`
  String get watchdialfunction {
    return Intl.message(
      'watch dial function',
      name: 'watchdialfunction',
      desc: '',
      args: [],
    );
  }

  /// `delete current dial`
  String get deletecurrentdial {
    return Intl.message(
      'delete current dial',
      name: 'deletecurrentdial',
      desc: '',
      args: [],
    );
  }

  /// `delete current dial success`
  String get deletecurrentdialsuccess {
    return Intl.message(
      'delete current dial success',
      name: 'deletecurrentdialsuccess',
      desc: '',
      args: [],
    );
  }

  /// `delete current dial failed`
  String get deletecurrentdialfailed {
    return Intl.message(
      'delete current dial failed',
      name: 'deletecurrentdialfailed',
      desc: '',
      args: [],
    );
  }

  /// `custom wallpaper dial`
  String get customwallpaperdial {
    return Intl.message(
      'custom wallpaper dial',
      name: 'customwallpaperdial',
      desc: '',
      args: [],
    );
  }

  /// `set wallpaper parameters`
  String get setwallpaperparameters {
    return Intl.message(
      'set wallpaper parameters',
      name: 'setwallpaperparameters',
      desc: '',
      args: [],
    );
  }

  /// `set wallpaper parameters success`
  String get setwallpaperparameterssuccess {
    return Intl.message(
      'set wallpaper parameters success',
      name: 'setwallpaperparameterssuccess',
      desc: '',
      args: [],
    );
  }

  /// `set wallpaper parameters failed`
  String get setwallpaperparametersfailed {
    return Intl.message(
      'set wallpaper parameters failed',
      name: 'setwallpaperparametersfailed',
      desc: '',
      args: [],
    );
  }

  /// `delete the wallpaper dial`
  String get deletethewallpaperdial {
    return Intl.message(
      'delete the wallpaper dial',
      name: 'deletethewallpaperdial',
      desc: '',
      args: [],
    );
  }

  /// `delete the wallpaper dial success`
  String get deletethewallpaperdialsuccess {
    return Intl.message(
      'delete the wallpaper dial success',
      name: 'deletethewallpaperdialsuccess',
      desc: '',
      args: [],
    );
  }

  /// `delete the wallpaper dial failed`
  String get deletethewallpaperdialfailed {
    return Intl.message(
      'delete the wallpaper dial failed',
      name: 'deletethewallpaperdialfailed',
      desc: '',
      args: [],
    );
  }

  /// `transfer the wallpaper dial`
  String get transferthewallpaperdial {
    return Intl.message(
      'transfer the wallpaper dial',
      name: 'transferthewallpaperdial',
      desc: '',
      args: [],
    );
  }

  /// `get wallpaper dial info`
  String get getwallpaperdialinfo {
    return Intl.message(
      'get wallpaper dial info',
      name: 'getwallpaperdialinfo',
      desc: '',
      args: [],
    );
  }

  /// `get wallpaper dial info success`
  String get getwallpaperdialinfosuccess {
    return Intl.message(
      'get wallpaper dial info success',
      name: 'getwallpaperdialinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get wallpaper dial info failed`
  String get getwallpaperdialinfofailed {
    return Intl.message(
      'get wallpaper dial info failed',
      name: 'getwallpaperdialinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `display position`
  String get displayposition {
    return Intl.message(
      'display position',
      name: 'displayposition',
      desc: '',
      args: [],
    );
  }

  /// `hidden display`
  String get hiddendisplay {
    return Intl.message(
      'hidden display',
      name: 'hiddendisplay',
      desc: '',
      args: [],
    );
  }

  /// `icon type`
  String get icontype {
    return Intl.message(
      'icon type',
      name: 'icontype',
      desc: '',
      args: [],
    );
  }

  /// `time color`
  String get timecolor {
    return Intl.message(
      'time color',
      name: 'timecolor',
      desc: '',
      args: [],
    );
  }

  /// `widget icon type`
  String get widgeticontype {
    return Intl.message(
      'widget icon type',
      name: 'widgeticontype',
      desc: '',
      args: [],
    );
  }

  /// `widget number type`
  String get widgetnumbertype {
    return Intl.message(
      'widget number type',
      name: 'widgetnumbertype',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'dial(upperleft)' key

  // skipped getter for the 'dial(uppermiddle)' key

  // skipped getter for the 'dial(upperright)' key

  // skipped getter for the 'dial(middleleft)' key

  // skipped getter for the 'dial(middle)' key

  // skipped getter for the 'dial(middleright)' key

  // skipped getter for the 'dial(bottomleft)' key

  // skipped getter for the 'dial(bottommiddle)' key

  // skipped getter for the 'dial(bottomright)' key

  /// `show all`
  String get showall {
    return Intl.message(
      'show all',
      name: 'showall',
      desc: '',
      args: [],
    );
  }

  /// `hide child controls`
  String get hidechildcontrols {
    return Intl.message(
      'hide child controls',
      name: 'hidechildcontrols',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'week/date' key

  /// `number of steps`
  String get numberofsteps {
    return Intl.message(
      'number of steps',
      name: 'numberofsteps',
      desc: '',
      args: [],
    );
  }

  /// `distance`
  String get distance {
    return Intl.message(
      'distance',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `calorie`
  String get calorie {
    return Intl.message(
      'calorie',
      name: 'calorie',
      desc: '',
      args: [],
    );
  }

  /// `heart rate`
  String get heartrate {
    return Intl.message(
      'heart rate',
      name: 'heartrate',
      desc: '',
      args: [],
    );
  }

  /// `battery`
  String get battery {
    return Intl.message(
      'battery',
      name: 'battery',
      desc: '',
      args: [],
    );
  }

  /// `get function list`
  String get getfunctionlist {
    return Intl.message(
      'get function list',
      name: 'getfunctionlist',
      desc: '',
      args: [],
    );
  }

  /// `get function list success`
  String get getfunctionlistsuccess {
    return Intl.message(
      'get function list success',
      name: 'getfunctionlistsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get function list failed`
  String get getfunctionlistfailed {
    return Intl.message(
      'get function list failed',
      name: 'getfunctionlistfailed',
      desc: '',
      args: [],
    );
  }

  /// `get Mac address`
  String get getMacaddress {
    return Intl.message(
      'get Mac address',
      name: 'getMacaddress',
      desc: '',
      args: [],
    );
  }

  /// `Mac address`
  String get Macaddress {
    return Intl.message(
      'Mac address',
      name: 'Macaddress',
      desc: '',
      args: [],
    );
  }

  /// `get Mac address success`
  String get getMacaddresssuccess {
    return Intl.message(
      'get Mac address success',
      name: 'getMacaddresssuccess',
      desc: '',
      args: [],
    );
  }

  /// `get Mac address failed`
  String get getMacaddressfailed {
    return Intl.message(
      'get Mac address failed',
      name: 'getMacaddressfailed',
      desc: '',
      args: [],
    );
  }

  /// `get device information`
  String get getdeviceinformation {
    return Intl.message(
      'get device information',
      name: 'getdeviceinformation',
      desc: '',
      args: [],
    );
  }

  /// `get device information success`
  String get getdeviceinformationsuccess {
    return Intl.message(
      'get device information success',
      name: 'getdeviceinformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get device information failed`
  String get getdeviceinformationfailed {
    return Intl.message(
      'get device information failed',
      name: 'getdeviceinformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `get real-time data`
  String get getRealTimeData {
    return Intl.message(
      'get real-time data',
      name: 'getRealTimeData',
      desc: '',
      args: [],
    );
  }

  /// `get real-time data success`
  String get getRealTimeDataSuccess {
    return Intl.message(
      'get real-time data success',
      name: 'getRealTimeDataSuccess',
      desc: '',
      args: [],
    );
  }

  /// `get real-time data failed`
  String get getRealTimeDataFailed {
    return Intl.message(
      'get real-time data failed',
      name: 'getRealTimeDataFailed',
      desc: '',
      args: [],
    );
  }

  /// `get the number of activities`
  String get getthenumberofactivities {
    return Intl.message(
      'get the number of activities',
      name: 'getthenumberofactivities',
      desc: '',
      args: [],
    );
  }

  /// `get the number of activities success`
  String get getthenumberofactivitiessuccess {
    return Intl.message(
      'get the number of activities success',
      name: 'getthenumberofactivitiessuccess',
      desc: '',
      args: [],
    );
  }

  /// `get the number of activities failed`
  String get getthenumberofactivitiesfailed {
    return Intl.message(
      'get the number of activities failed',
      name: 'getthenumberofactivitiesfailed',
      desc: '',
      args: [],
    );
  }

  /// `get GPS information`
  String get getGPSinformation {
    return Intl.message(
      'get GPS information',
      name: 'getGPSinformation',
      desc: '',
      args: [],
    );
  }

  /// `get GPS information success`
  String get getGPSinformationsuccess {
    return Intl.message(
      'get GPS information success',
      name: 'getGPSinformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get GPS information failed`
  String get getGPSinformationfailed {
    return Intl.message(
      'get GPS information failed',
      name: 'getGPSinformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `get PressureThreshold information`
  String get getPressureThresholdinformation {
    return Intl.message(
      'get PressureThreshold information',
      name: 'getPressureThresholdinformation',
      desc: '',
      args: [],
    );
  }

  /// `get PressureThreshold information success`
  String get getPressureThresholdinformationsuccess {
    return Intl.message(
      'get PressureThreshold information success',
      name: 'getPressureThresholdinformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get PressureThreshold information failed`
  String get getPressureThresholdinformationfailed {
    return Intl.message(
      'get PressureThreshold information failed',
      name: 'getPressureThresholdinformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `get notification status`
  String get getnotificationstatus {
    return Intl.message(
      'get notification status',
      name: 'getnotificationstatus',
      desc: '',
      args: [],
    );
  }

  /// `get notification status success`
  String get getnotificationstatussuccess {
    return Intl.message(
      'get notification status success',
      name: 'getnotificationstatussuccess',
      desc: '',
      args: [],
    );
  }

  /// `get notification status failed`
  String get getnotificationstatusfailed {
    return Intl.message(
      'get notification status failed',
      name: 'getnotificationstatusfailed',
      desc: '',
      args: [],
    );
  }

  /// `get version information`
  String get getversioninformation {
    return Intl.message(
      'get version information',
      name: 'getversioninformation',
      desc: '',
      args: [],
    );
  }

  /// `get version information success`
  String get getversioninformationsuccess {
    return Intl.message(
      'get version information success',
      name: 'getversioninformationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get version information failed`
  String get getversioninformationfailed {
    return Intl.message(
      'get version information failed',
      name: 'getversioninformationfailed',
      desc: '',
      args: [],
    );
  }

  /// `get ota auth information`
  String get getotaauthinformation {
    return Intl.message(
      'get ota auth information',
      name: 'getotaauthinformation',
      desc: '',
      args: [],
    );
  }

  /// `get ota auth info success`
  String get getotaauthinfosuccess {
    return Intl.message(
      'get ota auth info success',
      name: 'getotaauthinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get ota auth info failed`
  String get getotaauthinfofailed {
    return Intl.message(
      'get ota auth info failed',
      name: 'getotaauthinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `verification success`
  String get verificationsuccess {
    return Intl.message(
      'verification success',
      name: 'verificationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `id number verification failure`
  String get idnumberverificationfailure {
    return Intl.message(
      'id number verification failure',
      name: 'idnumberverificationfailure',
      desc: '',
      args: [],
    );
  }

  /// `version number verification failure`
  String get versionnumberverificationfailure {
    return Intl.message(
      'version number verification failure',
      name: 'versionnumberverificationfailure',
      desc: '',
      args: [],
    );
  }

  /// `insufficient power`
  String get insufficientpower {
    return Intl.message(
      'insufficient power',
      name: 'insufficientpower',
      desc: '',
      args: [],
    );
  }

  /// `other errors`
  String get othererrors {
    return Intl.message(
      'other errors',
      name: 'othererrors',
      desc: '',
      args: [],
    );
  }

  /// `get the number of stars`
  String get getthenumberofstars {
    return Intl.message(
      'get the number of stars',
      name: 'getthenumberofstars',
      desc: '',
      args: [],
    );
  }

  /// `the number of stars`
  String get thenumberofstars {
    return Intl.message(
      'the number of stars',
      name: 'thenumberofstars',
      desc: '',
      args: [],
    );
  }

  /// `get the number of stars success`
  String get getthenumberofstarssuccess {
    return Intl.message(
      'get the number of stars success',
      name: 'getthenumberofstarssuccess',
      desc: '',
      args: [],
    );
  }

  /// `get the number of stars failed`
  String get getthenumberofstarsfailed {
    return Intl.message(
      'get the number of stars failed',
      name: 'getthenumberofstarsfailed',
      desc: '',
      args: [],
    );
  }

  /// `get flash info`
  String get getflashinfo {
    return Intl.message(
      'get flash info',
      name: 'getflashinfo',
      desc: '',
      args: [],
    );
  }

  /// `get battery info`
  String get getbatteryinfo {
    return Intl.message(
      'get battery info',
      name: 'getbatteryinfo',
      desc: '',
      args: [],
    );
  }

  /// `get flash info success`
  String get getflashinfosuccess {
    return Intl.message(
      'get flash info success',
      name: 'getflashinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get flash info failed`
  String get getflashinfofailed {
    return Intl.message(
      'get flash info failed',
      name: 'getflashinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get battery info success`
  String get getbatteryinfosuccess {
    return Intl.message(
      'get battery info success',
      name: 'getbatteryinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get battery info failed`
  String get getbatteryinfofailed {
    return Intl.message(
      'get battery info failed',
      name: 'getbatteryinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get default language`
  String get getdefaultlanguage {
    return Intl.message(
      'get default language',
      name: 'getdefaultlanguage',
      desc: '',
      args: [],
    );
  }

  /// `get default language success`
  String get getdefaultlanguagesuccess {
    return Intl.message(
      'get default language success',
      name: 'getdefaultlanguagesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get default language failed`
  String get getdefaultlanguagefailed {
    return Intl.message(
      'get default language failed',
      name: 'getdefaultlanguagefailed',
      desc: '',
      args: [],
    );
  }

  /// `get five heart rate`
  String get getfiveheartrate {
    return Intl.message(
      'get five heart rate',
      name: 'getfiveheartrate',
      desc: '',
      args: [],
    );
  }

  /// `get five heart rate success`
  String get getfiveheartratesuccess {
    return Intl.message(
      'get five heart rate success',
      name: 'getfiveheartratesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get five heart rate failed`
  String get getfiveheartratefailed {
    return Intl.message(
      'get five heart rate failed',
      name: 'getfiveheartratefailed',
      desc: '',
      args: [],
    );
  }

  /// `get default sport type`
  String get getdefaultsporttype {
    return Intl.message(
      'get default sport type',
      name: 'getdefaultsporttype',
      desc: '',
      args: [],
    );
  }

  /// `get default sport type success`
  String get getdefaultsporttypesuccess {
    return Intl.message(
      'get default sport type success',
      name: 'getdefaultsporttypesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get default sport type failed`
  String get getdefaultsporttypefailed {
    return Intl.message(
      'get default sport type failed',
      name: 'getdefaultsporttypefailed',
      desc: '',
      args: [],
    );
  }

  /// `get error log state`
  String get geterrorlogstate {
    return Intl.message(
      'get error log state',
      name: 'geterrorlogstate',
      desc: '',
      args: [],
    );
  }

  /// `get error log state success`
  String get geterrorlogstatesuccess {
    return Intl.message(
      'get error log state success',
      name: 'geterrorlogstatesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get error log state falied`
  String get geterrorlogstatefalied {
    return Intl.message(
      'get error log state falied',
      name: 'geterrorlogstatefalied',
      desc: '',
      args: [],
    );
  }

  /// `get v3 alarms info`
  String get getv3alarmsinfo {
    return Intl.message(
      'get v3 alarms info',
      name: 'getv3alarmsinfo',
      desc: '',
      args: [],
    );
  }

  /// `get v3 alarms info success`
  String get getv3alarmsinfosuccess {
    return Intl.message(
      'get v3 alarms info success',
      name: 'getv3alarmsinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get v3 alarms info failed`
  String get getv3alarmsinfofailed {
    return Intl.message(
      'get v3 alarms info failed',
      name: 'getv3alarmsinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get v3 heart rate mode`
  String get getv3heartratemode {
    return Intl.message(
      'get v3 heart rate mode',
      name: 'getv3heartratemode',
      desc: '',
      args: [],
    );
  }

  /// `get v3 heart rate mode success`
  String get getv3heartratemodesuccess {
    return Intl.message(
      'get v3 heart rate mode success',
      name: 'getv3heartratemodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get v3 heart rate mode failed`
  String get getv3heartratemodefailed {
    return Intl.message(
      'get v3 heart rate mode failed',
      name: 'getv3heartratemodefailed',
      desc: '',
      args: [],
    );
  }

  /// `get blue mtu info`
  String get getbluemtuinfo {
    return Intl.message(
      'get blue mtu info',
      name: 'getbluemtuinfo',
      desc: '',
      args: [],
    );
  }

  /// `get blue mtu info success`
  String get getbluemtuinfosuccess {
    return Intl.message(
      'get blue mtu info success',
      name: 'getbluemtuinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get blue mtu info failed`
  String get getbluemtuinfofailed {
    return Intl.message(
      'get blue mtu info failed',
      name: 'getbluemtuinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get over heat log`
  String get getoverheatlog {
    return Intl.message(
      'get over heat log',
      name: 'getoverheatlog',
      desc: '',
      args: [],
    );
  }

  /// `get over heat log success`
  String get getoverheatlogsuccess {
    return Intl.message(
      'get over heat log success',
      name: 'getoverheatlogsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get over heat log failed`
  String get getoverheatlogfailed {
    return Intl.message(
      'get over heat log failed',
      name: 'getoverheatlogfailed',
      desc: '',
      args: [],
    );
  }

  /// `get device battery log`
  String get getdevicebatterylog {
    return Intl.message(
      'get device battery log',
      name: 'getdevicebatterylog',
      desc: '',
      args: [],
    );
  }

  /// `get device battery log success`
  String get getdevicebatterylogsuccess {
    return Intl.message(
      'get device battery log success',
      name: 'getdevicebatterylogsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get device battery log failed`
  String get getdevicebatterylogfailed {
    return Intl.message(
      'get device battery log failed',
      name: 'getdevicebatterylogfailed',
      desc: '',
      args: [],
    );
  }

  /// `get not disturb mode`
  String get getnotdisturbmode {
    return Intl.message(
      'get not disturb mode',
      name: 'getnotdisturbmode',
      desc: '',
      args: [],
    );
  }

  /// `get not disturb mode success`
  String get getnotdisturbmodesuccess {
    return Intl.message(
      'get not disturb mode success',
      name: 'getnotdisturbmodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get not disturb mode failed`
  String get getnotdisturbmodefailed {
    return Intl.message(
      'get not disturb mode failed',
      name: 'getnotdisturbmodefailed',
      desc: '',
      args: [],
    );
  }

  /// `get encrypted code`
  String get getencryptedcode {
    return Intl.message(
      'get encrypted code',
      name: 'getencryptedcode',
      desc: '',
      args: [],
    );
  }

  /// `get encrypted code success`
  String get getencryptedcodesuccess {
    return Intl.message(
      'get encrypted code success',
      name: 'getencryptedcodesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get encrypted code failed`
  String get getencryptedcodefailed {
    return Intl.message(
      'get encrypted code failed',
      name: 'getencryptedcodefailed',
      desc: '',
      args: [],
    );
  }

  /// `please speak`
  String get pleasespeak {
    return Intl.message(
      'please speak',
      name: 'pleasespeak',
      desc: '',
      args: [],
    );
  }

  /// `listen voice data`
  String get listenvoicedata {
    return Intl.message(
      'listen voice data',
      name: 'listenvoicedata',
      desc: '',
      args: [],
    );
  }

  /// `voice control`
  String get voicecontrol {
    return Intl.message(
      'voice control',
      name: 'voicecontrol',
      desc: '',
      args: [],
    );
  }

  /// `get menu list`
  String get getmenulist {
    return Intl.message(
      'get menu list',
      name: 'getmenulist',
      desc: '',
      args: [],
    );
  }

  /// `get menu list success`
  String get getmenulistsuccess {
    return Intl.message(
      'get menu list success',
      name: 'getmenulistsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get menu list failed`
  String get getmenulistfailed {
    return Intl.message(
      'get menu list failed',
      name: 'getmenulistfailed',
      desc: '',
      args: [],
    );
  }

  /// `set menu list`
  String get setmenulist {
    return Intl.message(
      'set menu list',
      name: 'setmenulist',
      desc: '',
      args: [],
    );
  }

  /// `set menu list success`
  String get setmenulistsuccess {
    return Intl.message(
      'set menu list success',
      name: 'setmenulistsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set menu list failed`
  String get setmenulistfailed {
    return Intl.message(
      'set menu list failed',
      name: 'setmenulistfailed',
      desc: '',
      args: [],
    );
  }

  /// `picture`
  String get picture {
    return Intl.message(
      'picture',
      name: 'picture',
      desc: '',
      args: [],
    );
  }

  /// `alarm clock`
  String get alarmclock {
    return Intl.message(
      'alarm clock',
      name: 'alarmclock',
      desc: '',
      args: [],
    );
  }

  /// `music`
  String get music {
    return Intl.message(
      'music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `stopwatch`
  String get stopwatch {
    return Intl.message(
      'stopwatch',
      name: 'stopwatch',
      desc: '',
      args: [],
    );
  }

  /// `timer`
  String get timer {
    return Intl.message(
      'timer',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `exercise mode`
  String get exercisemode {
    return Intl.message(
      'exercise mode',
      name: 'exercisemode',
      desc: '',
      args: [],
    );
  }

  /// `weather`
  String get weather {
    return Intl.message(
      'weather',
      name: 'weather',
      desc: '',
      args: [],
    );
  }

  /// `breathing exercise`
  String get breathingexercise {
    return Intl.message(
      'breathing exercise',
      name: 'breathingexercise',
      desc: '',
      args: [],
    );
  }

  /// `find mobile phone`
  String get findmobilephone {
    return Intl.message(
      'find mobile phone',
      name: 'findmobilephone',
      desc: '',
      args: [],
    );
  }

  /// `pressure`
  String get pressure {
    return Intl.message(
      'pressure',
      name: 'pressure',
      desc: '',
      args: [],
    );
  }

  /// `data tricycle`
  String get datatricycle {
    return Intl.message(
      'data tricycle',
      name: 'datatricycle',
      desc: '',
      args: [],
    );
  }

  /// `time interface`
  String get timeinterface {
    return Intl.message(
      'time interface',
      name: 'timeinterface',
      desc: '',
      args: [],
    );
  }

  /// `last activity`
  String get lastactivity {
    return Intl.message(
      'last activity',
      name: 'lastactivity',
      desc: '',
      args: [],
    );
  }

  /// `health data`
  String get healthdata {
    return Intl.message(
      'health data',
      name: 'healthdata',
      desc: '',
      args: [],
    );
  }

  /// `blood oxygen`
  String get bloodoxygen {
    return Intl.message(
      'blood oxygen',
      name: 'bloodoxygen',
      desc: '',
      args: [],
    );
  }

  /// `menu settings`
  String get menusettings {
    return Intl.message(
      'menu settings',
      name: 'menusettings',
      desc: '',
      args: [],
    );
  }

  /// `Alexa Test`
  String get alexatest {
    return Intl.message(
      'Alexa Test',
      name: 'alexatest',
      desc: '',
      args: [],
    );
  }

  /// `alexa voice prompt`
  String get alexavoiceprompt {
    return Intl.message(
      'alexa voice prompt',
      name: 'alexavoiceprompt',
      desc: '',
      args: [],
    );
  }

  /// `data to json`
  String get datatojson {
    return Intl.message(
      'data to json',
      name: 'datatojson',
      desc: '',
      args: [],
    );
  }

  /// `data migration complete`
  String get datamigrationcomplete {
    return Intl.message(
      'data migration complete',
      name: 'datamigrationcomplete',
      desc: '',
      args: [],
    );
  }

  /// `no need migration`
  String get noneedmigration {
    return Intl.message(
      'no need migration',
      name: 'noneedmigration',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'datamigration...' key

  /// `data to json commplete`
  String get datatojsoncommplete {
    return Intl.message(
      'data to json commplete',
      name: 'datatojsoncommplete',
      desc: '',
      args: [],
    );
  }

  /// `step data query`
  String get stepdataquery {
    return Intl.message(
      'step data query',
      name: 'stepdataquery',
      desc: '',
      args: [],
    );
  }

  /// `sleep data query`
  String get sleepdataquery {
    return Intl.message(
      'sleep data query',
      name: 'sleepdataquery',
      desc: '',
      args: [],
    );
  }

  /// `heart rate data query`
  String get heartratedataquery {
    return Intl.message(
      'heart rate data query',
      name: 'heartratedataquery',
      desc: '',
      args: [],
    );
  }

  /// `blood pressure data query`
  String get bloodpressuredataquery {
    return Intl.message(
      'blood pressure data query',
      name: 'bloodpressuredataquery',
      desc: '',
      args: [],
    );
  }

  /// `blood oxygen data query`
  String get bloodoxygendataquery {
    return Intl.message(
      'blood oxygen data query',
      name: 'bloodoxygendataquery',
      desc: '',
      args: [],
    );
  }

  /// `pressure data query`
  String get pressuredataquery {
    return Intl.message(
      'pressure data query',
      name: 'pressuredataquery',
      desc: '',
      args: [],
    );
  }

  /// `noise data query`
  String get noisedataquery {
    return Intl.message(
      'noise data query',
      name: 'noisedataquery',
      desc: '',
      args: [],
    );
  }

  /// `temperature data query`
  String get temperaturedataquery {
    return Intl.message(
      'temperature data query',
      name: 'temperaturedataquery',
      desc: '',
      args: [],
    );
  }

  /// `breath rate data query`
  String get breathratedataquery {
    return Intl.message(
      'breath rate data query',
      name: 'breathratedataquery',
      desc: '',
      args: [],
    );
  }

  /// `body power data query`
  String get bodypowerdataquery {
    return Intl.message(
      'body power data query',
      name: 'bodypowerdataquery',
      desc: '',
      args: [],
    );
  }

  /// `activity data query`
  String get activitydataquery {
    return Intl.message(
      'activity data query',
      name: 'activitydataquery',
      desc: '',
      args: [],
    );
  }

  /// `swim data query`
  String get swimdataquery {
    return Intl.message(
      'swim data query',
      name: 'swimdataquery',
      desc: '',
      args: [],
    );
  }

  /// `one timestamp query`
  String get onetimestampquery {
    return Intl.message(
      'one timestamp query',
      name: 'onetimestampquery',
      desc: '',
      args: [],
    );
  }

  /// `one date query`
  String get onedatequery {
    return Intl.message(
      'one date query',
      name: 'onedatequery',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'date:' key

  // skipped getter for the 'time:' key

  /// `GPS data query`
  String get GPSdataquery {
    return Intl.message(
      'GPS data query',
      name: 'GPSdataquery',
      desc: '',
      args: [],
    );
  }

  /// `one year query`
  String get oneyearquery {
    return Intl.message(
      'one year query',
      name: 'oneyearquery',
      desc: '',
      args: [],
    );
  }

  /// `one month query`
  String get onemonthquery {
    return Intl.message(
      'one month query',
      name: 'onemonthquery',
      desc: '',
      args: [],
    );
  }

  /// `one week query`
  String get oneweekquery {
    return Intl.message(
      'one week query',
      name: 'oneweekquery',
      desc: '',
      args: [],
    );
  }

  /// `one day query`
  String get onedayquery {
    return Intl.message(
      'one day query',
      name: 'onedayquery',
      desc: '',
      args: [],
    );
  }

  /// `all data query`
  String get alldataquery {
    return Intl.message(
      'all data query',
      name: 'alldataquery',
      desc: '',
      args: [],
    );
  }

  /// `activty type`
  String get activtytype {
    return Intl.message(
      'activty type',
      name: 'activtytype',
      desc: '',
      args: [],
    );
  }

  /// `trajectory`
  String get trajectory {
    return Intl.message(
      'trajectory',
      name: 'trajectory',
      desc: '',
      args: [],
    );
  }

  /// `no trajectory`
  String get notrajectory {
    return Intl.message(
      'no trajectory',
      name: 'notrajectory',
      desc: '',
      args: [],
    );
  }

  /// `step`
  String get step {
    return Intl.message(
      'step',
      name: 'step',
      desc: '',
      args: [],
    );
  }

  /// `avg heart rate`
  String get avgheartrate {
    return Intl.message(
      'avg heart rate',
      name: 'avgheartrate',
      desc: '',
      args: [],
    );
  }

  /// `GPS detail`
  String get GPSdetail {
    return Intl.message(
      'GPS detail',
      name: 'GPSdetail',
      desc: '',
      args: [],
    );
  }

  /// `activity detail`
  String get activitydetail {
    return Intl.message(
      'activity detail',
      name: 'activitydetail',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'loadingdata...' key

  /// `loading complete`
  String get loadingcomplete {
    return Intl.message(
      'loading complete',
      name: 'loadingcomplete',
      desc: '',
      args: [],
    );
  }

  /// `previous year`
  String get previousyear {
    return Intl.message(
      'previous year',
      name: 'previousyear',
      desc: '',
      args: [],
    );
  }

  /// `next year`
  String get nextyear {
    return Intl.message(
      'next year',
      name: 'nextyear',
      desc: '',
      args: [],
    );
  }

  /// `previous month`
  String get previousmonth {
    return Intl.message(
      'previous month',
      name: 'previousmonth',
      desc: '',
      args: [],
    );
  }

  /// `next month`
  String get nextmonth {
    return Intl.message(
      'next month',
      name: 'nextmonth',
      desc: '',
      args: [],
    );
  }

  /// `previous week`
  String get previousweek {
    return Intl.message(
      'previous week',
      name: 'previousweek',
      desc: '',
      args: [],
    );
  }

  /// `next week`
  String get nextweek {
    return Intl.message(
      'next week',
      name: 'nextweek',
      desc: '',
      args: [],
    );
  }

  /// `previous day`
  String get previousday {
    return Intl.message(
      'previous day',
      name: 'previousday',
      desc: '',
      args: [],
    );
  }

  /// `next day`
  String get nextday {
    return Intl.message(
      'next day',
      name: 'nextday',
      desc: '',
      args: [],
    );
  }

  /// `query all data`
  String get queryalldata {
    return Intl.message(
      'query all data',
      name: 'queryalldata',
      desc: '',
      args: [],
    );
  }

  /// `current year no data`
  String get currentyearnodata {
    return Intl.message(
      'current year no data',
      name: 'currentyearnodata',
      desc: '',
      args: [],
    );
  }

  /// `current month no data`
  String get currentmonthnodata {
    return Intl.message(
      'current month no data',
      name: 'currentmonthnodata',
      desc: '',
      args: [],
    );
  }

  /// `current week no data`
  String get currentweeknodata {
    return Intl.message(
      'current week no data',
      name: 'currentweeknodata',
      desc: '',
      args: [],
    );
  }

  /// `current day no data`
  String get currentdaynodata {
    return Intl.message(
      'current day no data',
      name: 'currentdaynodata',
      desc: '',
      args: [],
    );
  }

  /// `no data`
  String get nodata {
    return Intl.message(
      'no data',
      name: 'nodata',
      desc: '',
      args: [],
    );
  }

  /// `data count`
  String get datacount {
    return Intl.message(
      'data count',
      name: 'datacount',
      desc: '',
      args: [],
    );
  }

  /// `command log`
  String get commandlog {
    return Intl.message(
      'command log',
      name: 'commandlog',
      desc: '',
      args: [],
    );
  }

  /// `restart log`
  String get restartlog {
    return Intl.message(
      'restart log',
      name: 'restartlog',
      desc: '',
      args: [],
    );
  }

  /// `Latest 7 days database log`
  String get Latest7daysdatabaselog {
    return Intl.message(
      'Latest 7 days database log',
      name: 'Latest7daysdatabaselog',
      desc: '',
      args: [],
    );
  }

  /// `flash log`
  String get flashlog {
    return Intl.message(
      'flash log',
      name: 'flashlog',
      desc: '',
      args: [],
    );
  }

  /// `get log`
  String get getlog {
    return Intl.message(
      'get log',
      name: 'getlog',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'getthedevicelogs...' key

  /// `get device log completion`
  String get getdevicelogcompletion {
    return Intl.message(
      'get device log completion',
      name: 'getdevicelogcompletion',
      desc: '',
      args: [],
    );
  }

  /// `get all flash log`
  String get getallflashlog {
    return Intl.message(
      'get all flash log',
      name: 'getallflashlog',
      desc: '',
      args: [],
    );
  }

  /// `get general log`
  String get getgenerallog {
    return Intl.message(
      'get general log',
      name: 'getgenerallog',
      desc: '',
      args: [],
    );
  }

  /// `get reset log`
  String get getresetlog {
    return Intl.message(
      'get reset log',
      name: 'getresetlog',
      desc: '',
      args: [],
    );
  }

  /// `get algorithm log`
  String get getalgorithmlog {
    return Intl.message(
      'get algorithm log',
      name: 'getalgorithmlog',
      desc: '',
      args: [],
    );
  }

  /// `get hardware log`
  String get gethardwarelog {
    return Intl.message(
      'get hardware log',
      name: 'gethardwarelog',
      desc: '',
      args: [],
    );
  }

  /// `get flash log complete`
  String get getflashlogcomplete {
    return Intl.message(
      'get flash log complete',
      name: 'getflashlogcomplete',
      desc: '',
      args: [],
    );
  }

  /// `get flash log failed`
  String get getflashlogfailed {
    return Intl.message(
      'get flash log failed',
      name: 'getflashlogfailed',
      desc: '',
      args: [],
    );
  }

  /// `photo control`
  String get photocontrol {
    return Intl.message(
      'photo control',
      name: 'photocontrol',
      desc: '',
      args: [],
    );
  }

  /// `music control`
  String get musiccontrol {
    return Intl.message(
      'music control',
      name: 'musiccontrol',
      desc: '',
      args: [],
    );
  }

  /// `notification control`
  String get notificationcontrol {
    return Intl.message(
      'notification control',
      name: 'notificationcontrol',
      desc: '',
      args: [],
    );
  }

  /// `recovery control`
  String get recoverycontrol {
    return Intl.message(
      'recovery control',
      name: 'recoverycontrol',
      desc: '',
      args: [],
    );
  }

  /// `reboot control`
  String get rebootcontrol {
    return Intl.message(
      'reboot control',
      name: 'rebootcontrol',
      desc: '',
      args: [],
    );
  }

  /// `turn on the camera`
  String get turnonthecamera {
    return Intl.message(
      'turn on the camera',
      name: 'turnonthecamera',
      desc: '',
      args: [],
    );
  }

  /// `turn off camera`
  String get turnoffcamera {
    return Intl.message(
      'turn off camera',
      name: 'turnoffcamera',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'setthecameraswitch...' key

  /// `failed to set up camera`
  String get failedtosetupcamera {
    return Intl.message(
      'failed to set up camera',
      name: 'failedtosetupcamera',
      desc: '',
      args: [],
    );
  }

  /// `setting music open`
  String get settingmusicopen {
    return Intl.message(
      'setting music open',
      name: 'settingmusicopen',
      desc: '',
      args: [],
    );
  }

  /// `set music end`
  String get setmusicend {
    return Intl.message(
      'set music end',
      name: 'setmusicend',
      desc: '',
      args: [],
    );
  }

  /// `failed to set music on`
  String get failedtosetmusicon {
    return Intl.message(
      'failed to set music on',
      name: 'failedtosetmusicon',
      desc: '',
      args: [],
    );
  }

  /// `open ANCS notification`
  String get openANCSnotification {
    return Intl.message(
      'open ANCS notification',
      name: 'openANCSnotification',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'openANCSnotification...' key

  /// `open ANCS notification success`
  String get openANCSnotificationsuccess {
    return Intl.message(
      'open ANCS notification success',
      name: 'openANCSnotificationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `oepn ANCS notification failed`
  String get oepnANCSnotificationfailed {
    return Intl.message(
      'oepn ANCS notification failed',
      name: 'oepnANCSnotificationfailed',
      desc: '',
      args: [],
    );
  }

  /// `close ANCS notification`
  String get closeANCSnotification {
    return Intl.message(
      'close ANCS notification',
      name: 'closeANCSnotification',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'closeANCSnotification...' key

  /// `close ANCS notification success`
  String get closeANCSnotificationsuccess {
    return Intl.message(
      'close ANCS notification success',
      name: 'closeANCSnotificationsuccess',
      desc: '',
      args: [],
    );
  }

  /// `close ANCS notification failed`
  String get closeANCSnotificationfailed {
    return Intl.message(
      'close ANCS notification failed',
      name: 'closeANCSnotificationfailed',
      desc: '',
      args: [],
    );
  }

  /// `setting default configuration`
  String get settingdefaultconfiguration {
    return Intl.message(
      'setting default configuration',
      name: 'settingdefaultconfiguration',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'settingdefaultconfiguration...' key

  /// `setting the default configuration successfully`
  String get settingthedefaultconfigurationsuccessfully {
    return Intl.message(
      'setting the default configuration successfully',
      name: 'settingthedefaultconfigurationsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `failed to set default configuration`
  String get failedtosetdefaultconfiguration {
    return Intl.message(
      'failed to set default configuration',
      name: 'failedtosetdefaultconfiguration',
      desc: '',
      args: [],
    );
  }

  /// `reboot device`
  String get rebootdevice {
    return Intl.message(
      'reboot device',
      name: 'rebootdevice',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'rebootdevice...' key

  /// `successful restart of equipment`
  String get successfulrestartofequipment {
    return Intl.message(
      'successful restart of equipment',
      name: 'successfulrestartofequipment',
      desc: '',
      args: [],
    );
  }

  /// `failure to restart equipment`
  String get failuretorestartequipment {
    return Intl.message(
      'failure to restart equipment',
      name: 'failuretorestartequipment',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get Camera {
    return Intl.message(
      'Camera',
      name: 'Camera',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get Album {
    return Intl.message(
      'Album',
      name: 'Album',
      desc: '',
      args: [],
    );
  }

  /// `set sport type`
  String get setsporttype {
    return Intl.message(
      'set sport type',
      name: 'setsporttype',
      desc: '',
      args: [],
    );
  }

  /// `set sport type success`
  String get setsporttypesuccess {
    return Intl.message(
      'set sport type success',
      name: 'setsporttypesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set sport type failed`
  String get setsporttypefailed {
    return Intl.message(
      'set sport type failed',
      name: 'setsporttypefailed',
      desc: '',
      args: [],
    );
  }

  /// `set real time hr`
  String get setrealtimehr {
    return Intl.message(
      'set real time hr',
      name: 'setrealtimehr',
      desc: '',
      args: [],
    );
  }

  /// `set real time hr success`
  String get setrealtimehrsuccess {
    return Intl.message(
      'set real time hr success',
      name: 'setrealtimehrsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set real time hr failed`
  String get setrealtimehrfailed {
    return Intl.message(
      'set real time hr failed',
      name: 'setrealtimehrfailed',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb`
  String get setnodisturb {
    return Intl.message(
      'set no disturb',
      name: 'setnodisturb',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb success`
  String get setnodisturbsuccess {
    return Intl.message(
      'set no disturb success',
      name: 'setnodisturbsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set no disturb failed`
  String get setnodisturbfailed {
    return Intl.message(
      'set no disturb failed',
      name: 'setnodisturbfailed',
      desc: '',
      args: [],
    );
  }

  /// `set wrist bright screen`
  String get setwristbrightscreen {
    return Intl.message(
      'set wrist bright screen',
      name: 'setwristbrightscreen',
      desc: '',
      args: [],
    );
  }

  /// `set wrist bright screen success`
  String get setwristbrightscreensuccess {
    return Intl.message(
      'set wrist bright screen success',
      name: 'setwristbrightscreensuccess',
      desc: '',
      args: [],
    );
  }

  /// `set wrist bright screen failed`
  String get setwristbrightscreenfailed {
    return Intl.message(
      'set wrist bright screen failed',
      name: 'setwristbrightscreenfailed',
      desc: '',
      args: [],
    );
  }

  /// `set music control`
  String get setmusiccontrol {
    return Intl.message(
      'set music control',
      name: 'setmusiccontrol',
      desc: '',
      args: [],
    );
  }

  /// `set music control success`
  String get setmusiccontrolsuccess {
    return Intl.message(
      'set music control success',
      name: 'setmusiccontrolsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set music control failed`
  String get setmusiccontrolfailed {
    return Intl.message(
      'set music control failed',
      name: 'setmusiccontrolfailed',
      desc: '',
      args: [],
    );
  }

  /// `screen brightness`
  String get screenbrightness {
    return Intl.message(
      'screen brightness',
      name: 'screenbrightness',
      desc: '',
      args: [],
    );
  }

  /// `set stopwatch`
  String get setstopwatch {
    return Intl.message(
      'set stopwatch',
      name: 'setstopwatch',
      desc: '',
      args: [],
    );
  }

  /// `set countdown`
  String get setcountdown {
    return Intl.message(
      'set countdown',
      name: 'setcountdown',
      desc: '',
      args: [],
    );
  }

  /// `heart rate detection`
  String get heartratedetection {
    return Intl.message(
      'heart rate detection',
      name: 'heartratedetection',
      desc: '',
      args: [],
    );
  }

  /// `pressure detection`
  String get pressuredetection {
    return Intl.message(
      'pressure detection',
      name: 'pressuredetection',
      desc: '',
      args: [],
    );
  }

  /// `breathing training`
  String get breathingtraining {
    return Intl.message(
      'breathing training',
      name: 'breathingtraining',
      desc: '',
      args: [],
    );
  }

  /// `sleep record`
  String get sleeprecord {
    return Intl.message(
      'sleep record',
      name: 'sleeprecord',
      desc: '',
      args: [],
    );
  }

  /// `sport record`
  String get sportrecord {
    return Intl.message(
      'sport record',
      name: 'sportrecord',
      desc: '',
      args: [],
    );
  }

  /// `weather interface`
  String get weatherinterface {
    return Intl.message(
      'weather interface',
      name: 'weatherinterface',
      desc: '',
      args: [],
    );
  }

  /// `find phone`
  String get findphone {
    return Intl.message(
      'find phone',
      name: 'findphone',
      desc: '',
      args: [],
    );
  }

  /// `black screen`
  String get blackscreen {
    return Intl.message(
      'black screen',
      name: 'blackscreen',
      desc: '',
      args: [],
    );
  }

  /// `message interface`
  String get messageinterface {
    return Intl.message(
      'message interface',
      name: 'messageinterface',
      desc: '',
      args: [],
    );
  }

  /// `alarm interface`
  String get alarminterface {
    return Intl.message(
      'alarm interface',
      name: 'alarminterface',
      desc: '',
      args: [],
    );
  }

  /// `set page jump success`
  String get setpagejumpsuccess {
    return Intl.message(
      'set page jump success',
      name: 'setpagejumpsuccess',
      desc: '',
      args: [],
    );
  }

  /// `set page jump failed`
  String get setpagejumpfailed {
    return Intl.message(
      'set page jump failed',
      name: 'setpagejumpfailed',
      desc: '',
      args: [],
    );
  }

  /// `voice start`
  String get voicestart {
    return Intl.message(
      'voice start',
      name: 'voicestart',
      desc: '',
      args: [],
    );
  }

  /// `voice end`
  String get voiceend {
    return Intl.message(
      'voice end',
      name: 'voiceend',
      desc: '',
      args: [],
    );
  }

  /// `voice failed`
  String get voicefailed {
    return Intl.message(
      'voice failed',
      name: 'voicefailed',
      desc: '',
      args: [],
    );
  }

  /// `voice play`
  String get voiceplay {
    return Intl.message(
      'voice play',
      name: 'voiceplay',
      desc: '',
      args: [],
    );
  }

  /// `set page jump`
  String get setpagejump {
    return Intl.message(
      'set page jump',
      name: 'setpagejump',
      desc: '',
      args: [],
    );
  }

  /// `message`
  String get message {
    return Intl.message(
      'message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `set voice message`
  String get setvoicemessage {
    return Intl.message(
      'set voice message',
      name: 'setvoicemessage',
      desc: '',
      args: [],
    );
  }

  /// `voice recognition failed`
  String get voicerecognitionfailed {
    return Intl.message(
      'voice recognition failed',
      name: 'voicerecognitionfailed',
      desc: '',
      args: [],
    );
  }

  /// `factory reset`
  String get factoryreset {
    return Intl.message(
      'factory reset',
      name: 'factoryreset',
      desc: '',
      args: [],
    );
  }

  /// `factory reset successfully`
  String get factoryresetsuccessfully {
    return Intl.message(
      'factory reset successfully',
      name: 'factoryresetsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `factory reset failed`
  String get factoryresetfailed {
    return Intl.message(
      'factory reset failed',
      name: 'factoryresetfailed',
      desc: '',
      args: [],
    );
  }

  /// `app initiates data exchange`
  String get appinitiatesdataexchange {
    return Intl.message(
      'app initiates data exchange',
      name: 'appinitiatesdataexchange',
      desc: '',
      args: [],
    );
  }

  /// `new app initiates data exchange`
  String get newappinitiatesdataexchange {
    return Intl.message(
      'new app initiates data exchange',
      name: 'newappinitiatesdataexchange',
      desc: '',
      args: [],
    );
  }

  /// `app start activity`
  String get appstartactivity {
    return Intl.message(
      'app start activity',
      name: 'appstartactivity',
      desc: '',
      args: [],
    );
  }

  /// `app suspended activity`
  String get appsuspendedactivity {
    return Intl.message(
      'app suspended activity',
      name: 'appsuspendedactivity',
      desc: '',
      args: [],
    );
  }

  /// `app restore activity`
  String get apprestoreactivity {
    return Intl.message(
      'app restore activity',
      name: 'apprestoreactivity',
      desc: '',
      args: [],
    );
  }

  /// `app stop activity`
  String get appstopactivity {
    return Intl.message(
      'app stop activity',
      name: 'appstopactivity',
      desc: '',
      args: [],
    );
  }

  /// `app activity send data`
  String get appactivitysenddata {
    return Intl.message(
      'app activity send data',
      name: 'appactivitysenddata',
      desc: '',
      args: [],
    );
  }

  /// `bracelet suspended activity`
  String get braceletsuspendedactivity {
    return Intl.message(
      'bracelet suspended activity',
      name: 'braceletsuspendedactivity',
      desc: '',
      args: [],
    );
  }

  /// `bracelet restore activity`
  String get braceletrestoreactivity {
    return Intl.message(
      'bracelet restore activity',
      name: 'braceletrestoreactivity',
      desc: '',
      args: [],
    );
  }

  /// `bracelet stop activity`
  String get braceletstopactivity {
    return Intl.message(
      'bracelet stop activity',
      name: 'braceletstopactivity',
      desc: '',
      args: [],
    );
  }

  /// `bracelet start activity`
  String get braceletstartactivity {
    return Intl.message(
      'bracelet start activity',
      name: 'braceletstartactivity',
      desc: '',
      args: [],
    );
  }

  /// `bracelet send data`
  String get braceletsenddata {
    return Intl.message(
      'bracelet send data',
      name: 'braceletsenddata',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'activitytype:' key

  // skipped getter for the 'targetunit:' key

  // skipped getter for the 'targetvalue:' key

  // skipped getter for the 'appstartactivity...' key

  /// `app start activity success`
  String get appstartactivitysuccess {
    return Intl.message(
      'app start activity success',
      name: 'appstartactivitysuccess',
      desc: '',
      args: [],
    );
  }

  /// `device low power`
  String get devicelowpower {
    return Intl.message(
      'device low power',
      name: 'devicelowpower',
      desc: '',
      args: [],
    );
  }

  /// `app start activity failed`
  String get appstartactivityfailed {
    return Intl.message(
      'app start activity failed',
      name: 'appstartactivityfailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'appsuspendedactivity...' key

  /// `app suspended activity success`
  String get appsuspendedactivitysuccess {
    return Intl.message(
      'app suspended activity success',
      name: 'appsuspendedactivitysuccess',
      desc: '',
      args: [],
    );
  }

  /// `app suspended activity failed`
  String get appsuspendedactivityfailed {
    return Intl.message(
      'app suspended activity failed',
      name: 'appsuspendedactivityfailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'apprestoreactivity...' key

  /// `app restore activity success`
  String get apprestoreactivitysuccess {
    return Intl.message(
      'app restore activity success',
      name: 'apprestoreactivitysuccess',
      desc: '',
      args: [],
    );
  }

  /// `app restore activity failed`
  String get apprestoreactivityfailed {
    return Intl.message(
      'app restore activity failed',
      name: 'apprestoreactivityfailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'appstopactivity...' key

  /// `app stop activity success`
  String get appstopactivitysuccess {
    return Intl.message(
      'app stop activity success',
      name: 'appstopactivitysuccess',
      desc: '',
      args: [],
    );
  }

  /// `app stop activity failed`
  String get appstopactivityfailed {
    return Intl.message(
      'app stop activity failed',
      name: 'appstopactivityfailed',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'senddata...' key

  /// `send data success`
  String get senddatasuccess {
    return Intl.message(
      'send data success',
      name: 'senddatasuccess',
      desc: '',
      args: [],
    );
  }

  /// `send data failed`
  String get senddatafailed {
    return Intl.message(
      'send data failed',
      name: 'senddatafailed',
      desc: '',
      args: [],
    );
  }

  /// `prepare sync data`
  String get preparesyncdata {
    return Intl.message(
      'prepare sync data',
      name: 'preparesyncdata',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'syncdata...' key

  /// `config data sync`
  String get configdatasync {
    return Intl.message(
      'config data sync',
      name: 'configdatasync',
      desc: '',
      args: [],
    );
  }

  /// `activity data sync`
  String get activitydatasync {
    return Intl.message(
      'activity data sync',
      name: 'activitydatasync',
      desc: '',
      args: [],
    );
  }

  /// `health data sync`
  String get healthdatasync {
    return Intl.message(
      'health data sync',
      name: 'healthdatasync',
      desc: '',
      args: [],
    );
  }

  /// `blood oxygen pressure sync`
  String get bloodoxygenpressuresync {
    return Intl.message(
      'blood oxygen pressure sync',
      name: 'bloodoxygenpressuresync',
      desc: '',
      args: [],
    );
  }

  /// `GPS data sync`
  String get GPSdatasync {
    return Intl.message(
      'GPS data sync',
      name: 'GPSdatasync',
      desc: '',
      args: [],
    );
  }

  /// `all data sync`
  String get alldatasync {
    return Intl.message(
      'all data sync',
      name: 'alldatasync',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'syncconfigdata...' key

  /// `sync config data complete`
  String get syncconfigdatacomplete {
    return Intl.message(
      'sync config data complete',
      name: 'syncconfigdatacomplete',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'syncactivitydata...' key

  /// `no activity data sync`
  String get noactivitydatasync {
    return Intl.message(
      'no activity data sync',
      name: 'noactivitydatasync',
      desc: '',
      args: [],
    );
  }

  /// `get activity count failed`
  String get getactivitycountfailed {
    return Intl.message(
      'get activity count failed',
      name: 'getactivitycountfailed',
      desc: '',
      args: [],
    );
  }

  /// `sync activity data complete`
  String get syncactivitydatacomplete {
    return Intl.message(
      'sync activity data complete',
      name: 'syncactivitydatacomplete',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'synchealthdata...' key

  /// `sync health data complete`
  String get synchealthdatacomplete {
    return Intl.message(
      'sync health data complete',
      name: 'synchealthdatacomplete',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'syncbloodoxygenpressuredata...' key

  /// `sync blood oxygen pressure data complete`
  String get syncbloodoxygenpressuredatacomplete {
    return Intl.message(
      'sync blood oxygen pressure data complete',
      name: 'syncbloodoxygenpressuredatacomplete',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'syncGPSdata...' key

  /// `sync GPS data complete`
  String get syncGPSdatacomplete {
    return Intl.message(
      'sync GPS data complete',
      name: 'syncGPSdatacomplete',
      desc: '',
      args: [],
    );
  }

  /// `no GPS data sync`
  String get noGPSdatasync {
    return Intl.message(
      'no GPS data sync',
      name: 'noGPSdatasync',
      desc: '',
      args: [],
    );
  }

  /// `get GPS data count failed`
  String get getGPSdatacountfailed {
    return Intl.message(
      'get GPS data count failed',
      name: 'getGPSdatacountfailed',
      desc: '',
      args: [],
    );
  }

  /// `sync data complete`
  String get syncdatacomplete {
    return Intl.message(
      'sync data complete',
      name: 'syncdatacomplete',
      desc: '',
      args: [],
    );
  }

  /// `sync data failed`
  String get syncdatafailed {
    return Intl.message(
      'sync data failed',
      name: 'syncdatafailed',
      desc: '',
      args: [],
    );
  }

  /// `nordic update`
  String get nordicupdate {
    return Intl.message(
      'nordic update',
      name: 'nordicupdate',
      desc: '',
      args: [],
    );
  }

  /// `realtk update`
  String get realtkupdate {
    return Intl.message(
      'realtk update',
      name: 'realtkupdate',
      desc: '',
      args: [],
    );
  }

  /// `apollo update`
  String get apolloupdate {
    return Intl.message(
      'apollo update',
      name: 'apolloupdate',
      desc: '',
      args: [],
    );
  }

  /// `word update`
  String get wordupdate {
    return Intl.message(
      'word update',
      name: 'wordupdate',
      desc: '',
      args: [],
    );
  }

  /// `agps update`
  String get agpsupdate {
    return Intl.message(
      'agps update',
      name: 'agpsupdate',
      desc: '',
      args: [],
    );
  }

  /// `agps update type`
  String get agpsupdatetype {
    return Intl.message(
      'agps update type',
      name: 'agpsupdatetype',
      desc: '',
      args: [],
    );
  }

  /// `contact update`
  String get contactupdate {
    return Intl.message(
      'contact update',
      name: 'contactupdate',
      desc: '',
      args: [],
    );
  }

  /// `contact file transfer`
  String get contactfiletransfer {
    return Intl.message(
      'contact file transfer',
      name: 'contactfiletransfer',
      desc: '',
      args: [],
    );
  }

  /// `photo update`
  String get photoupdate {
    return Intl.message(
      'photo update',
      name: 'photoupdate',
      desc: '',
      args: [],
    );
  }

  /// `please select a png image`
  String get pleaseselectapngimage {
    return Intl.message(
      'please select a png image',
      name: 'pleaseselectapngimage',
      desc: '',
      args: [],
    );
  }

  /// `selected firmware`
  String get selectedfirmware {
    return Intl.message(
      'selected firmware',
      name: 'selectedfirmware',
      desc: '',
      args: [],
    );
  }

  /// `exit update`
  String get exitupdate {
    return Intl.message(
      'exit update',
      name: 'exitupdate',
      desc: '',
      args: [],
    );
  }

  /// `reconnect`
  String get reconnect {
    return Intl.message(
      'reconnect',
      name: 'reconnect',
      desc: '',
      args: [],
    );
  }

  /// `firmware update`
  String get firmwareupdate {
    return Intl.message(
      'firmware update',
      name: 'firmwareupdate',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'exitupdate...' key

  /// `exit success`
  String get exitsuccess {
    return Intl.message(
      'exit success',
      name: 'exitsuccess',
      desc: '',
      args: [],
    );
  }

  /// `exit failed`
  String get exitfailed {
    return Intl.message(
      'exit failed',
      name: 'exitfailed',
      desc: '',
      args: [],
    );
  }

  /// `device connected not need reconnected`
  String get deviceconnectednotneedreconnected {
    return Intl.message(
      'device connected not need reconnected',
      name: 'deviceconnectednotneedreconnected',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'enterupdate...' key

  /// `firmware type`
  String get firmwaretype {
    return Intl.message(
      'firmware type',
      name: 'firmwaretype',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'update...' key

  /// `update success`
  String get updatesuccess {
    return Intl.message(
      'update success',
      name: 'updatesuccess',
      desc: '',
      args: [],
    );
  }

  /// `update failed`
  String get updatefailed {
    return Intl.message(
      'update failed',
      name: 'updatefailed',
      desc: '',
      args: [],
    );
  }

  /// `selected agps file`
  String get selectedagpsfile {
    return Intl.message(
      'selected agps file',
      name: 'selectedagpsfile',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'filereadyfortransfer...' key

  /// `file does not exist`
  String get filedoesnotexist {
    return Intl.message(
      'file does not exist',
      name: 'filedoesnotexist',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'filewrite...' key

  /// `file transfer failed`
  String get filetransferfailed {
    return Intl.message(
      'file transfer failed',
      name: 'filetransferfailed',
      desc: '',
      args: [],
    );
  }

  /// `file write success`
  String get filewritesuccess {
    return Intl.message(
      'file write success',
      name: 'filewritesuccess',
      desc: '',
      args: [],
    );
  }

  /// `file write failed`
  String get filewritefailed {
    return Intl.message(
      'file write failed',
      name: 'filewritefailed',
      desc: '',
      args: [],
    );
  }

  /// `selected files`
  String get selectedfiles {
    return Intl.message(
      'selected files',
      name: 'selectedfiles',
      desc: '',
      args: [],
    );
  }

  /// `log complete clearing`
  String get logcompleteclearing {
    return Intl.message(
      'log complete clearing',
      name: 'logcompleteclearing',
      desc: '',
      args: [],
    );
  }

  /// `clear log display`
  String get clearlogdisplay {
    return Intl.message(
      'clear log display',
      name: 'clearlogdisplay',
      desc: '',
      args: [],
    );
  }

  /// `get firmware package name`
  String get getfirmwarepackagename {
    return Intl.message(
      'get firmware package name',
      name: 'getfirmwarepackagename',
      desc: '',
      args: [],
    );
  }

  /// `measure data`
  String get measureData {
    return Intl.message(
      'measure data',
      name: 'measureData',
      desc: '',
      args: [],
    );
  }

  /// `measure blood pressure`
  String get measurebloodpressure {
    return Intl.message(
      'measure blood pressure',
      name: 'measurebloodpressure',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'measurebloodpressure...' key

  /// `not support blood pressure measure`
  String get notsupportbloodpressuremeasure {
    return Intl.message(
      'not support blood pressure measure',
      name: 'notsupportbloodpressuremeasure',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '%ldsecondsinbloodpressuremeasure' key

  /// `successful blood pressure measure`
  String get successfulbloodpressuremeasure {
    return Intl.message(
      'successful blood pressure measure',
      name: 'successfulbloodpressuremeasure',
      desc: '',
      args: [],
    );
  }

  /// `failure blood pressure measure`
  String get failurebloodpressuremeasure {
    return Intl.message(
      'failure blood pressure measure',
      name: 'failurebloodpressuremeasure',
      desc: '',
      args: [],
    );
  }

  /// `device in sport mode`
  String get deviceinsportmode {
    return Intl.message(
      'device in sport mode',
      name: 'deviceinsportmode',
      desc: '',
      args: [],
    );
  }

  /// `abnormal device measure`
  String get abnormaldevicemeasure {
    return Intl.message(
      'abnormal device measure',
      name: 'abnormaldevicemeasure',
      desc: '',
      args: [],
    );
  }

  /// `set weather city name`
  String get setweathercityname {
    return Intl.message(
      'set weather city name',
      name: 'setweathercityname',
      desc: '',
      args: [],
    );
  }

  /// `set weather city name success`
  String get setweathercitynamesuccess {
    return Intl.message(
      'set weather city name success',
      name: 'setweathercitynamesuccess',
      desc: '',
      args: [],
    );
  }

  /// `set weather city name failed`
  String get setweathercitynamefailed {
    return Intl.message(
      'set weather city name failed',
      name: 'setweathercitynamefailed',
      desc: '',
      args: [],
    );
  }

  /// `set weather real time data`
  String get setweatherrealtimedata {
    return Intl.message(
      'set weather real time data',
      name: 'setweatherrealtimedata',
      desc: '',
      args: [],
    );
  }

  /// `weather type`
  String get weathertype {
    return Intl.message(
      'weather type',
      name: 'weathertype',
      desc: '',
      args: [],
    );
  }

  /// `weather temp`
  String get weathertemp {
    return Intl.message(
      'weather temp',
      name: 'weathertemp',
      desc: '',
      args: [],
    );
  }

  /// `data type`
  String get datatype {
    return Intl.message(
      'data type',
      name: 'datatype',
      desc: '',
      args: [],
    );
  }

  /// `set weather real time data success`
  String get setweatherrealtimedatasuccess {
    return Intl.message(
      'set weather real time data success',
      name: 'setweatherrealtimedatasuccess',
      desc: '',
      args: [],
    );
  }

  /// `set weather real time data failed`
  String get setweatherrealtimedatafailed {
    return Intl.message(
      'set weather real time data failed',
      name: 'setweatherrealtimedatafailed',
      desc: '',
      args: [],
    );
  }

  /// `sync iot button`
  String get synciotbutton {
    return Intl.message(
      'sync iot button',
      name: 'synciotbutton',
      desc: '',
      args: [],
    );
  }

  /// `add iot button`
  String get addiotbutton {
    return Intl.message(
      'add iot button',
      name: 'addiotbutton',
      desc: '',
      args: [],
    );
  }

  /// `button name`
  String get buttonname {
    return Intl.message(
      'button name',
      name: 'buttonname',
      desc: '',
      args: [],
    );
  }

  /// `sync iot button success`
  String get synciotbuttonsuccess {
    return Intl.message(
      'sync iot button success',
      name: 'synciotbuttonsuccess',
      desc: '',
      args: [],
    );
  }

  /// `sync iot button failed`
  String get synciotbuttonfailed {
    return Intl.message(
      'sync iot button failed',
      name: 'synciotbuttonfailed',
      desc: '',
      args: [],
    );
  }

  /// `please write button name`
  String get pleasewritebuttonname {
    return Intl.message(
      'please write button name',
      name: 'pleasewritebuttonname',
      desc: '',
      args: [],
    );
  }

  /// `set smart heart rate`
  String get setsmartheartrate {
    return Intl.message(
      'set smart heart rate',
      name: 'setsmartheartrate',
      desc: '',
      args: [],
    );
  }

  /// `smart heart rate model`
  String get smartheartratemodel {
    return Intl.message(
      'smart heart rate model',
      name: 'smartheartratemodel',
      desc: '',
      args: [],
    );
  }

  /// `high heart rate alert threshold`
  String get highheartratealertthreshold {
    return Intl.message(
      'high heart rate alert threshold',
      name: 'highheartratealertthreshold',
      desc: '',
      args: [],
    );
  }

  /// `low heart rate alert threshold`
  String get lowheartratealertthreshold {
    return Intl.message(
      'low heart rate alert threshold',
      name: 'lowheartratealertthreshold',
      desc: '',
      args: [],
    );
  }

  /// `notify flag unknow`
  String get notifyflagunknow {
    return Intl.message(
      'notify flag unknow',
      name: 'notifyflagunknow',
      desc: '',
      args: [],
    );
  }

  /// `allow notify flag`
  String get allownotifyflag {
    return Intl.message(
      'allow notify flag',
      name: 'allownotifyflag',
      desc: '',
      args: [],
    );
  }

  /// `silence notify flag`
  String get silencenotifyflag {
    return Intl.message(
      'silence notify flag',
      name: 'silencenotifyflag',
      desc: '',
      args: [],
    );
  }

  /// `close notify flag`
  String get closenotifyflag {
    return Intl.message(
      'close notify flag',
      name: 'closenotifyflag',
      desc: '',
      args: [],
    );
  }

  /// `setup success`
  String get setupsuccess {
    return Intl.message(
      'setup success',
      name: 'setupsuccess',
      desc: '',
      args: [],
    );
  }

  /// `setup failed`
  String get setupfailed {
    return Intl.message(
      'setup failed',
      name: 'setupfailed',
      desc: '',
      args: [],
    );
  }

  /// `set sleep switch`
  String get setsleepswitch {
    return Intl.message(
      'set sleep switch',
      name: 'setsleepswitch',
      desc: '',
      args: [],
    );
  }

  /// `set sleep switch model`
  String get setsleepswitchmodel {
    return Intl.message(
      'set sleep switch model',
      name: 'setsleepswitchmodel',
      desc: '',
      args: [],
    );
  }

  /// `set nocturnal temperature switch`
  String get setnocturnaltemperatureswitch {
    return Intl.message(
      'set nocturnal temperature switch',
      name: 'setnocturnaltemperatureswitch',
      desc: '',
      args: [],
    );
  }

  /// `set noise switch`
  String get setnoiseswitch {
    return Intl.message(
      'set noise switch',
      name: 'setnoiseswitch',
      desc: '',
      args: [],
    );
  }

  /// `all day noise model switch`
  String get alldaynoisemodelswitch {
    return Intl.message(
      'all day noise model switch',
      name: 'alldaynoisemodelswitch',
      desc: '',
      args: [],
    );
  }

  /// `threshold switch`
  String get thresholdswitch {
    return Intl.message(
      'threshold switch',
      name: 'thresholdswitch',
      desc: '',
      args: [],
    );
  }

  /// `threshold`
  String get threshold {
    return Intl.message(
      'threshold',
      name: 'threshold',
      desc: '',
      args: [],
    );
  }

  /// `fitness guidance switch`
  String get fitnessguidanceswitch {
    return Intl.message(
      'fitness guidance switch',
      name: 'fitnessguidanceswitch',
      desc: '',
      args: [],
    );
  }

  /// `set world time`
  String get setworldtime {
    return Intl.message(
      'set world time',
      name: 'setworldtime',
      desc: '',
      args: [],
    );
  }

  /// `please add world time`
  String get pleaseaddworldtime {
    return Intl.message(
      'please add world time',
      name: 'pleaseaddworldtime',
      desc: '',
      args: [],
    );
  }

  /// `add world time`
  String get addworldtime {
    return Intl.message(
      'add world time',
      name: 'addworldtime',
      desc: '',
      args: [],
    );
  }

  /// `can not more than 10 time`
  String get cannotmorethan10time {
    return Intl.message(
      'can not more than 10 time',
      name: 'cannotmorethan10time',
      desc: '',
      args: [],
    );
  }

  /// `version num`
  String get versionnum {
    return Intl.message(
      'version num',
      name: 'versionnum',
      desc: '',
      args: [],
    );
  }

  /// `city id`
  String get cityid {
    return Intl.message(
      'city id',
      name: 'cityid',
      desc: '',
      args: [],
    );
  }

  /// `city name`
  String get cityname {
    return Intl.message(
      'city name',
      name: 'cityname',
      desc: '',
      args: [],
    );
  }

  /// `sunrise time`
  String get sunrisetime {
    return Intl.message(
      'sunrise time',
      name: 'sunrisetime',
      desc: '',
      args: [],
    );
  }

  /// `sunset time`
  String get sunsettime {
    return Intl.message(
      'sunset time',
      name: 'sunsettime',
      desc: '',
      args: [],
    );
  }

  /// `is it the east longitude`
  String get isittheeastlongitude {
    return Intl.message(
      'is it the east longitude',
      name: 'isittheeastlongitude',
      desc: '',
      args: [],
    );
  }

  /// `longitude`
  String get longitude {
    return Intl.message(
      'longitude',
      name: 'longitude',
      desc: '',
      args: [],
    );
  }

  /// `latitude`
  String get latitude {
    return Intl.message(
      'latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `is it north latitude`
  String get isitnorthlatitude {
    return Intl.message(
      'is it north latitude',
      name: 'isitnorthlatitude',
      desc: '',
      args: [],
    );
  }

  /// `the offset minute between the current time and the 0 time zone`
  String get theoffsetminutebetweenthecurrenttimeandthe0timezone {
    return Intl.message(
      'the offset minute between the current time and the 0 time zone',
      name: 'theoffsetminutebetweenthecurrenttimeandthe0timezone',
      desc: '',
      args: [],
    );
  }

  /// `sunrise sunset time`
  String get sunrisesunsettime {
    return Intl.message(
      'sunrise sunset time',
      name: 'sunrisesunsettime',
      desc: '',
      args: [],
    );
  }

  /// `set V3 weather data`
  String get setV3weatherdata {
    return Intl.message(
      'set V3 weather data',
      name: 'setV3weatherdata',
      desc: '',
      args: [],
    );
  }

  /// `current weather`
  String get currentweather {
    return Intl.message(
      'current weather',
      name: 'currentweather',
      desc: '',
      args: [],
    );
  }

  /// `max weather`
  String get maxweather {
    return Intl.message(
      'max weather',
      name: 'maxweather',
      desc: '',
      args: [],
    );
  }

  /// `min weather`
  String get minweather {
    return Intl.message(
      'min weather',
      name: 'minweather',
      desc: '',
      args: [],
    );
  }

  /// `air quality`
  String get airquality {
    return Intl.message(
      'air quality',
      name: 'airquality',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation probability`
  String get Precipitationprobability {
    return Intl.message(
      'Precipitation probability',
      name: 'Precipitationprobability',
      desc: '',
      args: [],
    );
  }

  /// `humidity`
  String get humidity {
    return Intl.message(
      'humidity',
      name: 'humidity',
      desc: '',
      args: [],
    );
  }

  /// `uv intensity`
  String get uvintensity {
    return Intl.message(
      'uv intensity',
      name: 'uvintensity',
      desc: '',
      args: [],
    );
  }

  /// `wind Speed`
  String get windSpeed {
    return Intl.message(
      'wind Speed',
      name: 'windSpeed',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get week {
    return Intl.message(
      'week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `month day`
  String get monthday {
    return Intl.message(
      'month day',
      name: 'monthday',
      desc: '',
      args: [],
    );
  }

  /// `set sport param sort`
  String get setsportparamsort {
    return Intl.message(
      'set sport param sort',
      name: 'setsportparamsort',
      desc: '',
      args: [],
    );
  }

  /// `sport type`
  String get sporttype {
    return Intl.message(
      'sport type',
      name: 'sporttype',
      desc: '',
      args: [],
    );
  }

  /// `current sport index`
  String get currentsportindex {
    return Intl.message(
      'current sport index',
      name: 'currentsportindex',
      desc: '',
      args: [],
    );
  }

  /// `set schedule reminder`
  String get setschedulereminder {
    return Intl.message(
      'set schedule reminder',
      name: 'setschedulereminder',
      desc: '',
      args: [],
    );
  }

  /// `add schedule`
  String get addschedule {
    return Intl.message(
      'add schedule',
      name: 'addschedule',
      desc: '',
      args: [],
    );
  }

  /// `schedule id`
  String get scheduleid {
    return Intl.message(
      'schedule id',
      name: 'scheduleid',
      desc: '',
      args: [],
    );
  }

  /// `schedule title`
  String get scheduletitle {
    return Intl.message(
      'schedule title',
      name: 'scheduletitle',
      desc: '',
      args: [],
    );
  }

  /// `schedule note`
  String get schedulenote {
    return Intl.message(
      'schedule note',
      name: 'schedulenote',
      desc: '',
      args: [],
    );
  }

  /// `date input`
  String get dateinput {
    return Intl.message(
      'date input',
      name: 'dateinput',
      desc: '',
      args: [],
    );
  }

  /// `time input`
  String get timeinput {
    return Intl.message(
      'time input',
      name: 'timeinput',
      desc: '',
      args: [],
    );
  }

  /// `status code`
  String get statuscode {
    return Intl.message(
      'status code',
      name: 'statuscode',
      desc: '',
      args: [],
    );
  }

  /// `reminder type`
  String get remindertype {
    return Intl.message(
      'reminder type',
      name: 'remindertype',
      desc: '',
      args: [],
    );
  }

  /// `future remind type`
  String get futureremindtype {
    return Intl.message(
      'future remind type',
      name: 'futureremindtype',
      desc: '',
      args: [],
    );
  }

  /// `no remind`
  String get noremind {
    return Intl.message(
      'no remind',
      name: 'noremind',
      desc: '',
      args: [],
    );
  }

  /// `on time`
  String get ontime {
    return Intl.message(
      'on time',
      name: 'ontime',
      desc: '',
      args: [],
    );
  }

  /// `5 minutes in advance`
  String get minutesinadvance5 {
    return Intl.message(
      '5 minutes in advance',
      name: 'minutesinadvance5',
      desc: '',
      args: [],
    );
  }

  /// `10 minutes in advance`
  String get minutesinadvance10 {
    return Intl.message(
      '10 minutes in advance',
      name: 'minutesinadvance10',
      desc: '',
      args: [],
    );
  }

  /// `30 minutes in advance`
  String get minutesinadvance30 {
    return Intl.message(
      '30 minutes in advance',
      name: 'minutesinadvance30',
      desc: '',
      args: [],
    );
  }

  /// `1 hour in advance`
  String get hourinadvance1 {
    return Intl.message(
      '1 hour in advance',
      name: 'hourinadvance1',
      desc: '',
      args: [],
    );
  }

  /// `1 day in advance`
  String get dayinadvance1 {
    return Intl.message(
      '1 day in advance',
      name: 'dayinadvance1',
      desc: '',
      args: [],
    );
  }

  /// `2 day in advance`
  String get dayinadvance2 {
    return Intl.message(
      '2 day in advance',
      name: 'dayinadvance2',
      desc: '',
      args: [],
    );
  }

  /// `3 day in advance`
  String get dayinadvance3 {
    return Intl.message(
      '3 day in advance',
      name: 'dayinadvance3',
      desc: '',
      args: [],
    );
  }

  /// `1 week in advance`
  String get weekinadvance1 {
    return Intl.message(
      '1 week in advance',
      name: 'weekinadvance1',
      desc: '',
      args: [],
    );
  }

  /// `same day`
  String get sameday {
    return Intl.message(
      'same day',
      name: 'sameday',
      desc: '',
      args: [],
    );
  }

  /// `invalid state`
  String get invalidstate {
    return Intl.message(
      'invalid state',
      name: 'invalidstate',
      desc: '',
      args: [],
    );
  }

  /// `delete state`
  String get deletestate {
    return Intl.message(
      'delete state',
      name: 'deletestate',
      desc: '',
      args: [],
    );
  }

  /// `enable state`
  String get enablestate {
    return Intl.message(
      'enable state',
      name: 'enablestate',
      desc: '',
      args: [],
    );
  }

  /// `add`
  String get add {
    return Intl.message(
      'add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `select`
  String get select {
    return Intl.message(
      'select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `operation`
  String get operation {
    return Intl.message(
      'operation',
      name: 'operation',
      desc: '',
      args: [],
    );
  }

  /// `please add contact`
  String get pleaseaddcontact {
    return Intl.message(
      'please add contact',
      name: 'pleaseaddcontact',
      desc: '',
      args: [],
    );
  }

  /// `add contact`
  String get addcontact {
    return Intl.message(
      'add contact',
      name: 'addcontact',
      desc: '',
      args: [],
    );
  }

  /// `phone`
  String get phone {
    return Intl.message(
      'phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `set app notify status`
  String get setappnotifystatus {
    return Intl.message(
      'set app notify status',
      name: 'setappnotifystatus',
      desc: '',
      args: [],
    );
  }

  /// `add app notify`
  String get addappnotify {
    return Intl.message(
      'add app notify',
      name: 'addappnotify',
      desc: '',
      args: [],
    );
  }

  /// `event type`
  String get eventtype {
    return Intl.message(
      'event type',
      name: 'eventtype',
      desc: '',
      args: [],
    );
  }

  /// `notification status`
  String get notificationstatus {
    return Intl.message(
      'notification status',
      name: 'notificationstatus',
      desc: '',
      args: [],
    );
  }

  /// `set bule contact`
  String get setbulecontact {
    return Intl.message(
      'set bule contact',
      name: 'setbulecontact',
      desc: '',
      args: [],
    );
  }

  /// `outdoor play`
  String get outdoorplay {
    return Intl.message(
      'outdoor play',
      name: 'outdoorplay',
      desc: '',
      args: [],
    );
  }

  /// `get target info`
  String get gettargetinfo {
    return Intl.message(
      'get target info',
      name: 'gettargetinfo',
      desc: '',
      args: [],
    );
  }

  /// `get target info success`
  String get gettargetinfosuccess {
    return Intl.message(
      'get target info success',
      name: 'gettargetinfosuccess',
      desc: '',
      args: [],
    );
  }

  /// `get target info failed`
  String get gettargetinfofailed {
    return Intl.message(
      'get target info failed',
      name: 'gettargetinfofailed',
      desc: '',
      args: [],
    );
  }

  /// `get walk reminder`
  String get getwalkreminder {
    return Intl.message(
      'get walk reminder',
      name: 'getwalkreminder',
      desc: '',
      args: [],
    );
  }

  /// `get walk reminder success`
  String get getwalkremindersuccess {
    return Intl.message(
      'get walk reminder success',
      name: 'getwalkremindersuccess',
      desc: '',
      args: [],
    );
  }

  /// `get walk reminder failed`
  String get getwalkreminderfailed {
    return Intl.message(
      'get walk reminder failed',
      name: 'getwalkreminderfailed',
      desc: '',
      args: [],
    );
  }

  /// `get health switch state`
  String get gethealthswitchstate {
    return Intl.message(
      'get health switch state',
      name: 'gethealthswitchstate',
      desc: '',
      args: [],
    );
  }

  /// `get health switch state success`
  String get gethealthswitchstatesuccess {
    return Intl.message(
      'get health switch state success',
      name: 'gethealthswitchstatesuccess',
      desc: '',
      args: [],
    );
  }

  /// `get health switch state failed`
  String get gethealthswitchstatefailed {
    return Intl.message(
      'get health switch state failed',
      name: 'gethealthswitchstatefailed',
      desc: '',
      args: [],
    );
  }

  /// `get main ui sort`
  String get getmainuisort {
    return Intl.message(
      'get main ui sort',
      name: 'getmainuisort',
      desc: '',
      args: [],
    );
  }

  /// `get main ui sort success`
  String get getmainuisortsuccess {
    return Intl.message(
      'get main ui sort success',
      name: 'getmainuisortsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get main ui sort failed`
  String get getmainuisortfailed {
    return Intl.message(
      'get main ui sort failed',
      name: 'getmainuisortfailed',
      desc: '',
      args: [],
    );
  }

  /// `get schedule reminder`
  String get getschedulereminder {
    return Intl.message(
      'get schedule reminder',
      name: 'getschedulereminder',
      desc: '',
      args: [],
    );
  }

  /// `get schedule reminder success`
  String get getscheduleremindersuccess {
    return Intl.message(
      'get schedule reminder success',
      name: 'getscheduleremindersuccess',
      desc: '',
      args: [],
    );
  }

  /// `get schedule reminder failed`
  String get getschedulereminderfailed {
    return Intl.message(
      'get schedule reminder failed',
      name: 'getschedulereminderfailed',
      desc: '',
      args: [],
    );
  }

  /// `get V3 notification status`
  String get getV3notificationstatus {
    return Intl.message(
      'get V3 notification status',
      name: 'getV3notificationstatus',
      desc: '',
      args: [],
    );
  }

  /// `get V3 notification status success`
  String get getV3notificationstatussuccess {
    return Intl.message(
      'get V3 notification status success',
      name: 'getV3notificationstatussuccess',
      desc: '',
      args: [],
    );
  }

  /// `get V3 notification status failed`
  String get getV3notificationstatusfailed {
    return Intl.message(
      'get V3 notification status failed',
      name: 'getV3notificationstatusfailed',
      desc: '',
      args: [],
    );
  }

  /// `get sport sort`
  String get getsportsort {
    return Intl.message(
      'get sport sort',
      name: 'getsportsort',
      desc: '',
      args: [],
    );
  }

  /// `get sport sort success`
  String get getsportsortsuccess {
    return Intl.message(
      'get sport sort success',
      name: 'getsportsortsuccess',
      desc: '',
      args: [],
    );
  }

  /// `get sport sort failed`
  String get getsportsortfailed {
    return Intl.message(
      'get sport sort failed',
      name: 'getsportsortfailed',
      desc: '',
      args: [],
    );
  }

  /// `audio record control`
  String get audiorecordcontrol {
    return Intl.message(
      'audio record control',
      name: 'audiorecordcontrol',
      desc: '',
      args: [],
    );
  }

  /// `music fucntion`
  String get musicfucntion {
    return Intl.message(
      'music fucntion',
      name: 'musicfucntion',
      desc: '',
      args: [],
    );
  }

  /// `get music info`
  String get getmusicinfo {
    return Intl.message(
      'get music info',
      name: 'getmusicinfo',
      desc: '',
      args: [],
    );
  }

  /// `set music info`
  String get setmusicinfo {
    return Intl.message(
      'set music info',
      name: 'setmusicinfo',
      desc: '',
      args: [],
    );
  }

  /// `set folder info`
  String get setfolderinfo {
    return Intl.message(
      'set folder info',
      name: 'setfolderinfo',
      desc: '',
      args: [],
    );
  }

  /// `add music info`
  String get addmusicinfo {
    return Intl.message(
      'add music info',
      name: 'addmusicinfo',
      desc: '',
      args: [],
    );
  }

  /// `add folder info`
  String get addfolderinfo {
    return Intl.message(
      'add folder info',
      name: 'addfolderinfo',
      desc: '',
      args: [],
    );
  }

  /// `folder name`
  String get foldername {
    return Intl.message(
      'folder name',
      name: 'foldername',
      desc: '',
      args: [],
    );
  }

  /// `folder id`
  String get folderid {
    return Intl.message(
      'folder id',
      name: 'folderid',
      desc: '',
      args: [],
    );
  }

  /// `tran music info`
  String get tranmusicinfo {
    return Intl.message(
      'tran music info',
      name: 'tranmusicinfo',
      desc: '',
      args: [],
    );
  }

  /// `selected music file`
  String get selectedmusicfile {
    return Intl.message(
      'selected music file',
      name: 'selectedmusicfile',
      desc: '',
      args: [],
    );
  }

  /// `music name`
  String get musicname {
    return Intl.message(
      'music name',
      name: 'musicname',
      desc: '',
      args: [],
    );
  }

  /// `singer name`
  String get singername {
    return Intl.message(
      'singer name',
      name: 'singername',
      desc: '',
      args: [],
    );
  }

  /// `please enter folder name`
  String get pleaseenterfoldername {
    return Intl.message(
      'please enter folder name',
      name: 'pleaseenterfoldername',
      desc: '',
      args: [],
    );
  }

  /// `please add floder info`
  String get pleaseaddfloderinfo {
    return Intl.message(
      'please add floder info',
      name: 'pleaseaddfloderinfo',
      desc: '',
      args: [],
    );
  }

  /// `music id`
  String get musicid {
    return Intl.message(
      'music id',
      name: 'musicid',
      desc: '',
      args: [],
    );
  }

  /// `transfer music file`
  String get transfermusicfile {
    return Intl.message(
      'transfer music file',
      name: 'transfermusicfile',
      desc: '',
      args: [],
    );
  }

  /// `start transfer music file`
  String get starttransfermusicfile {
    return Intl.message(
      'start transfer music file',
      name: 'starttransfermusicfile',
      desc: '',
      args: [],
    );
  }

  /// `stop transfer music file`
  String get stoptransfermusicfile {
    return Intl.message(
      'stop transfer music file',
      name: 'stoptransfermusicfile',
      desc: '',
      args: [],
    );
  }

  /// `transfer music file failed`
  String get transfermusicfilefailed {
    return Intl.message(
      'transfer music file failed',
      name: 'transfermusicfilefailed',
      desc: '',
      args: [],
    );
  }

  /// `transfer music file success`
  String get transfermusicfilesuccess {
    return Intl.message(
      'transfer music file success',
      name: 'transfermusicfilesuccess',
      desc: '',
      args: [],
    );
  }

  /// `start modifying the MP3 sample rate`
  String get startmodifyingtheMP3samplerate {
    return Intl.message(
      'start modifying the MP3 sample rate',
      name: 'startmodifyingtheMP3samplerate',
      desc: '',
      args: [],
    );
  }

  /// `finish modifying the mp3 sample rate`
  String get finishmodifyingthemp3samplerate {
    return Intl.message(
      'finish modifying the mp3 sample rate',
      name: 'finishmodifyingthemp3samplerate',
      desc: '',
      args: [],
    );
  }

  /// `update sport icon`
  String get updatesporticon {
    return Intl.message(
      'update sport icon',
      name: 'updatesporticon',
      desc: '',
      args: [],
    );
  }

  /// `transfer icon file`
  String get transfericonfile {
    return Intl.message(
      'transfer icon file',
      name: 'transfericonfile',
      desc: '',
      args: [],
    );
  }

  /// `start transfer icon file`
  String get starttransfericonfile {
    return Intl.message(
      'start transfer icon file',
      name: 'starttransfericonfile',
      desc: '',
      args: [],
    );
  }

  /// `transfer icon file success`
  String get transfericonfilesuccess {
    return Intl.message(
      'transfer icon file success',
      name: 'transfericonfilesuccess',
      desc: '',
      args: [],
    );
  }

  /// `transfer icon file failed`
  String get transfericonfilefailed {
    return Intl.message(
      'transfer icon file failed',
      name: 'transfericonfilefailed',
      desc: '',
      args: [],
    );
  }

  /// `peripheral function`
  String get peripheralFunction {
    return Intl.message(
      'peripheral function',
      name: 'peripheralFunction',
      desc: '',
      args: [],
    );
  }

  /// `Device connected`
  String get deviceConnected {
    return Intl.message(
      'Device connected',
      name: 'deviceConnected',
      desc: '',
      args: [],
    );
  }

  /// `unbind device data`
  String get unbindDeviceData {
    return Intl.message(
      'unbind device data',
      name: 'unbindDeviceData',
      desc: '',
      args: [],
    );
  }

  /// `main UI Sort`
  String get mainUISort {
    return Intl.message(
      'main UI Sort',
      name: 'mainUISort',
      desc: '',
      args: [],
    );
  }

  /// `Set up medication record`
  String get setUpMedicationRecord {
    return Intl.message(
      'Set up medication record',
      name: 'setUpMedicationRecord',
      desc: '',
      args: [],
    );
  }

  /// `Add medication reminder`
  String get AddMedicationReminder {
    return Intl.message(
      'Add medication reminder',
      name: 'AddMedicationReminder',
      desc: '',
      args: [],
    );
  }

  /// `Set up medication reminder`
  String get setUpMedicationReminder {
    return Intl.message(
      'Set up medication reminder',
      name: 'setUpMedicationReminder',
      desc: '',
      args: [],
    );
  }

  /// `Medication Reminder`
  String get medicationReminder {
    return Intl.message(
      'Medication Reminder',
      name: 'medicationReminder',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTA mode（0101）`
  String get enterOTAMode {
    return Intl.message(
      'Enter OTA mode（0101）',
      name: 'enterOTAMode',
      desc: '',
      args: [],
    );
  }

  /// `obtain The Level 3 Version Number`
  String get obtainTheLevel3VersionNumber {
    return Intl.message(
      'obtain The Level 3 Version Number',
      name: 'obtainTheLevel3VersionNumber',
      desc: '',
      args: [],
    );
  }

  /// `update Message Icon`
  String get updateMessageIcon {
    return Intl.message(
      'update Message Icon',
      name: 'updateMessageIcon',
      desc: '',
      args: [],
    );
  }

  /// `Obtain firmware peripheral information`
  String get obtainFirmwarePeripheralInformation {
    return Intl.message(
      'Obtain firmware peripheral information',
      name: 'obtainFirmwarePeripheralInformation',
      desc: '',
      args: [],
    );
  }

  /// `Send the saved peripheral information to the firmware`
  String get sendTheSavedPeripheralInformationToTheFirmware {
    return Intl.message(
      'Send the saved peripheral information to the firmware',
      name: 'sendTheSavedPeripheralInformationToTheFirmware',
      desc: '',
      args: [],
    );
  }

  /// `The device list to be bound is delivered`
  String get theDeviceListToBeBoundIsDelivered {
    return Intl.message(
      'The device list to be bound is delivered',
      name: 'theDeviceListToBeBoundIsDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Deliver the body fat scale model mapping table`
  String get deliverTheBodyFatScaleModelMappingTable {
    return Intl.message(
      'Deliver the body fat scale model mapping table',
      name: 'deliverTheBodyFatScaleModelMappingTable',
      desc: '',
      args: [],
    );
  }

  /// `Setting the user information: The height and gender parameters in the user information are important parameters for calculating the step length, calories and kilometers of the bracelet. Please set the gender height and weight parameters in the first time to avoid the wrong display of the step number on the bracelet`
  String get settingTheUserInformationheight {
    return Intl.message(
      'Setting the user information: The height and gender parameters in the user information are important parameters for calculating the step length, calories and kilometers of the bracelet. Please set the gender height and weight parameters in the first time to avoid the wrong display of the step number on the bracelet',
      name: 'settingTheUserInformationheight',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
