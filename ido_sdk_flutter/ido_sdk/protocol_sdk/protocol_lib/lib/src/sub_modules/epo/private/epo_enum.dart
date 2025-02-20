part of '../epo_manager.dart';

enum _EPOType {
  gr('EPO_GR_3_1.DAT', false),

  gal('EPO_GAL_3.DAT', false),

  bds('EPO_BDS_3.DAT', false),

  // 芯与物平台
  c3('f1e1C3.pgl', true),

  g3('f1e1G3.pgl', true),

  e3('f1e1E3.pgl', true),

  j3('f1e1J3.pgl', true);

  const _EPOType(this.fileName, this.isIcoePlatform);
  final String fileName;

  /// 芯与物平台
  final bool isIcoePlatform;

  String getEPOUrl(int num) =>
      "https://elpo.airoha.com/$fileName?vendor=IDOO&project=2tp2-CDR0kD1mya1fjmIcdfda5q0QpjCZdNETJW-Oxw&device_id=$num";

  /// 芯与物的下载地址
  String getIcoeEPOUrl() => "http://starcourse.location.io/IC2MItGo7K/$fileName";
}