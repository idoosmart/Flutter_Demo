// 语言类型
import 'package:alexa_net/alexa_net.dart';

import '../../../protocol_alexa.dart';

extension AlexaLanguageTypeExt on AlexaLanguageType {
  /// 区域
  AlexaServerRegion get region {
    // 北美 (加拿大, 墨西哥, 美国)
    var region = AlexaServerRegion.na;
    switch (this) {
      case AlexaLanguageType.frenchCanada:
      case AlexaLanguageType.unitedKingdom:
      case AlexaLanguageType.spainEs:
      case AlexaLanguageType.india:
      case AlexaLanguageType.italianItaly:
      // 欧洲 (奥地利, 法国, 德国, 印度, 意大利, 西班牙, 英国)
        region = AlexaServerRegion.eu;
        break;
      case AlexaLanguageType.japan:
      case AlexaLanguageType.australia:
      // 亚洲  (澳大利亚, 日本, 新西兰)
        region = AlexaServerRegion.fe;
        break;
      default:
        break;
    }
    return region;
  }

  /// 转换成蓝牙SDK对应语言
  int get bleLanUtil {
    var type = 1;
    /**
     * 语言单位 无效:0,中文:1,英文:2,法语:3,德语:4,意大利语:5,西班牙语:6,日语:7,
     * 波兰语:8,捷克语:9,罗马尼亚:10,立陶宛语:11,荷兰语:12,斯洛文尼亚:13,
     * 匈牙利语:14,俄罗斯语:15,乌克兰语:16,斯洛伐克语:17,丹麦语:18,克罗地亚:19,印尼语:20,
     * 韩语:21,印地语:22,葡萄牙语:23,土耳其:24,泰国语:25,越南语:26,缅甸语:27,
     * 菲律宾语:28,繁体中文:29,希腊语:30,阿拉伯语:31
     * Language unit Invalid: 0, Chinese: 1, English: 2, French: 3, German: 4, Italian: 5, Spanish: 6, Japanese: 7,
     * Polish: 8, Czech: 9, Romania: 10, Lithuanian: 11, Dutch: 12, Slovenia: 13,
     * Hungarian: 14, Russian: 15, Ukrainian: 16, Slovak: 17, Danish: 18, Croatia: 19,Indonesian: 20,korean:21,hindi:22
     * portuguese:23,turkish:24,thai:25,vietnamese:26,burmese:27,filipino:28,traditional Chinese:29,greek:30,arabic:31
     */
    switch (lan) {
      case 'de-DE':
        type = 4;
        break;
      case 'en-AU':
      case 'en-CA':
      case 'en-GB':
      case 'en-IN':
      case 'en-US':
        type = 2;
        break;
      case 'es-ES':
      case 'es-MX':
      case 'es-US':
        type = 6;
        break;
      case 'fr-CA':
      case 'fr-FR':
        type = 3;
        break;
      case 'hi-IN':
        type = 22;
        break;
      case 'it-IT':
        type = 5;
        break;
      case 'ja-JP':
        type = 7;
        break;
      case 'pt-BR':
        type = 23;
        break;
    }
    return type;
  }
}
