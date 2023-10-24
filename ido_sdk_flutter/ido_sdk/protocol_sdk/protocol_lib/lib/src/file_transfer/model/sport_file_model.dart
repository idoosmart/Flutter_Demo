import 'package:protocol_lib/src/private/logger/logger.dart';

import 'base_file_model.dart';

import '../type_define/type_define.dart';

/// 运动图标
class SportFileModel extends BaseFileModel {
  /// 运动模式
  /// ```dart
  ///  以前运动类型:
  ///  0:无，1:走路，2:跑步，3:骑行，4:徒步，5:游泳，6:爬山，7:羽毛球，8:其他，
  ///  9:健身，10:动感单车，11:椭圆机，12:跑步机，13:仰卧起坐，14:俯卧撑，15:哑铃，16:举重，
  ///  17:健身操，18:瑜伽，19:跳绳，20:乒乓球，21:篮球，22:足球 ，23:排球，24:网球，
  ///  25:高尔夫球，26:棒球，27:滑雪，28:轮滑，29:跳舞，31：室内划船/roller machine， 32：普拉提/pilates， 33:交叉训练/cross train,
  ///  34:有氧运动/cardio，35：尊巴舞/Zumba, 36:广场舞/square dance, 37:平板支撑/Plank, 38:健身房/gym 48:户外跑步，49:室内跑步，
  ///  50:户外骑行，51:室内骑行，52:户外走路，53:室内走路，54:泳池游泳，55:开放水域游泳，56:椭圆机，57:划船机，58:高强度间歇训练法，75:板球运动
  ///  基础运动：
  ///  101：功能性力量训练，102：核心训练，103：踏步机，104：整理放松
  ///  健身（25种）
  ///  110：传统力量训练，112：引体向上，114：开合跳，115：深蹲，116：高抬腿，117：拳击，118：杠铃，119：武术，
  ///  120：太极，121：跆拳道，122：空手道，123：自由搏击，124：击剑，125：射箭，126：体操，127:单杠，128:双杠,129:漫步机,
  ///  130:登山机
  ///  球类:
  ///  131:保龄球,132:台球,133:曲棍球,134:橄榄球,135:壁球,136:垒球,137:手球,138:毽球,139:沙滩足球,
  ///  140:藤球,141:躲避球
  ///  休闲运动
  ///  152:街舞,153:芭蕾,154:社交舞,155:飞盘,156:飞镖,157:骑马,158:爬楼,159:放风筝,
  ///  160:钓鱼
  ///  冰雪运动
  ///  161:雪橇,162:雪车,163:单板滑雪,164:雪上运动,165:高山滑雪,166:越野滑雪,167:冰壶,168:冰球,169:冬季两项
  ///  水上运动（10种）
  ///  170:冲浪,171:帆船,172:帆板,173:皮艇,174:摩托艇,175:划艇,176:赛艇,177:龙舟,178:水球,179:漂流,
  ///  极限运动（5种）
  ///  180:滑板,181:攀岩,182:蹦极,183:跑酷,184:BMX,
  ///  kr01定制项目
  ///  193:Outdoor Fun（户外玩耍）, 194:Other Activity（其他运动）
  ///  ```
  final int sportType;

  /// 图标类型 1:单张小运动图片 2:单张大运动图片 3:多运动动画图片 4:单张中运动图片 5:运动最小图标
  int iconType;

  /// 运动图标 - 动画
  final bool isSports;

  SportFileModel(
      {required super.filePath,
      required super.fileName,
      required this.iconType,
      required this.sportType,
      required this.isSports,
      super.fileSize})
      : super(fileType: isSports ? FileTransType.sports : FileTransType.sport) {
    if (isSports) {
      iconType = 3; // 动图时，强制iconType类型为3
    }
  }

  @override
  String toString() {
    return 'SportFileModel{sportType: $sportType, iconType: $iconType, isSports: $isSports '
    'fileType: $fileType, filePath: $filePath, fileName: '
        '$fileName, fileSize: $fileSize, originalFileSize: $originalFileSize}';
  }
}
