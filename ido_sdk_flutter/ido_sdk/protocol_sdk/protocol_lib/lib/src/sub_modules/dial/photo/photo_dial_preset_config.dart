import 'dart:ui' as ui;
import 'package:json_annotation/json_annotation.dart';

import '../../extension/list_ext.dart';
import 'photo_dial_config.dart';

/// 表盘包预置内容
// class IDOPhotoDialPresetConfig {
// //预置背景图路径
// //预置预览图路径
// //预置默认位置
// //预置默认颜色
// //预置时间颜色列表
// //是否支持功能
// //预置默认功能
// //预置功能列表
// //预置功能颜色列表
// //预置手表圆角
// }

part 'photo_dial_preset_config.g.dart';

@JsonSerializable()
class IDOPhotoDialPresetConfig extends Object {
  @JsonKey(name: 'app')
  IDODialJsonApp? app;

  @JsonKey(name: 'zipName')
  int? zipName;

  //兼容支持功能在外面控制
  ///是否支持功能 默认0不支持，  1：支持功能切换
  @JsonKey(name: 'function_support')
  int? functionSupport;

  //支持新 照片云表盘的功能列表，可选功能从functionList读取
  @JsonKey(name: 'function_support_new')
  int? functionSupportNew;

  @JsonKey(name: 'dialZipName')
  String? dialZipName;

  @JsonKey(name: 'backgrounds')
  List<IDODialJsonBackgrounds>? backgrounds;

  @JsonKey(name: 'imagegroupsize')
  IDOPhotoDialImageGroupSize? imagegroupsize;

  @JsonKey(name: 'clock')
  IDODialJsonClock? clock;

  @JsonKey(name: 'funcInfo')
  IDODialJsonFuncInfo? funcInfo;

  @JsonKey(name: 'select')
  IDODialJsonSelect? select;

  /// 时间/功能可选颜色列表，对齐 Android [CwdAppBean.colors]
  @JsonKey(name: 'colors')
  List<String>? colors;

  @JsonKey(name: 'styles')
  List<IDODialJsonStyles>? styles;

  @JsonKey(name: 'palettes')
  List<IDODialJsonPalettes>? palettes;

  @JsonKey(name: 'locations')
  List<IDODialJsonLocations>? locations;

  @JsonKey(name: 'counterTimers')
  List<IDODialJsonCounterTimers>? counterTimers;

  @JsonKey(name: 'cloudWallpaper')
  IDODialJsonCloudWallpaper? cloudWallpaper;

  @JsonKey(name: 'function_list')
  List<IDOPhotoDialFunctionList>? functionList;

  @JsonKey(name: 'time_widget_list')
  List<IDOPhotoDialTimeWidgetListItem>? timeWidgetList;

  /// 表盘尺寸
  @JsonKey(includeFromJson: false, includeToJson: false)
  ui.Size sizeWatchScreen = ui.Size.zero;

  /// 预览图尺寸
  @JsonKey(includeFromJson: false, includeToJson: false)
  ui.Size sizePreviewPicture = ui.Size.zero;

  /// 当前表盘配置
  @JsonKey(includeFromJson: false, includeToJson: false)
  IDOPhotoDialConfig? photoDialConfig;

  IDOPhotoDialPresetConfig(
      this.app,
      this.zipName,
      this.dialZipName,
      this.backgrounds,
      this.imagegroupsize,
      this.clock,
      this.funcInfo,
      this.select,
      this.colors,
      this.styles,
      this.palettes,
      this.locations,
      this.counterTimers,
      this.cloudWallpaper,
      );

  factory IDOPhotoDialPresetConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$PhotoDialPresetConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PhotoDialPresetConfigToJson(this);

  List<String> palettesToColorList() {
    if (colors != null && colors!.isNotEmpty) {
      return List<String>.from(colors!);
    }
    final list = <String>[];
    if (palettes != null) {
      for (final palette in palettes!) {
        final c = palette.colors;
        if (c != null && c.isNotEmpty) {
          list.add(c);
        }
      }
    }
    return list;
  }

  IDODialJsonLocations? locationsForType(int type) {
    if (locations?.isEmpty ?? true) {
      return null;
    }
    return locations!.firstWhereOrNull((element) => element.type == type);
  }

  IDOPhotoDialFunctionList? functionListForType(String type) {
    if (functionList?.isEmpty ?? true) {
      return null;
    }
    return functionList!.firstWhereOrNull((element) => element.name == type);
  }

  IDOPhotoDialFunctionList? functionListForFuncation(String type) {
    if (functionList?.isEmpty ?? true) {
      return null;
    }
    return functionList!.firstWhereOrNull((element) => element.name == type);
  }
}

@JsonSerializable()
class IDODialJsonApp extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'bpp')
  int? bpp;

  @JsonKey(name: 'format')
  String? format;

  IDODialJsonApp(
      this.name,
      this.bpp,
      this.format,
      );

  factory IDODialJsonApp.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonAppFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonAppToJson(this);
}

@JsonSerializable()
class IDODialJsonBackgrounds extends Object {
  @JsonKey(name: 'canChangeColor')
  int? canChangeColor;

  @JsonKey(name: 'backgroundColor')
  String? backgroundColor;

  @JsonKey(name: 'borderColor')
  String? borderColor;

  @JsonKey(name: 'borderWidth')
  double? borderWidth;

  @JsonKey(name: 'funcTintColor')
  String? funcTintColor;

  @JsonKey(name: 'image')
  String? image;

  IDODialJsonBackgrounds(
      this.canChangeColor,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
      this.funcTintColor,
      this.image,
      );

  factory IDODialJsonBackgrounds.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonBackgroundsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonBackgroundsToJson(this);
}

@JsonSerializable()
class IDOPhotoDialImageGroupSize extends Object {
  @JsonKey(name: 'height')
  int? height;

  @JsonKey(name: 'width')
  int? width;

  IDOPhotoDialImageGroupSize(
      this.height,
      this.width,
      );

  factory IDOPhotoDialImageGroupSize.fromJson(Map<String, dynamic> srcJson) =>
      _$ImagegroupsizeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImagegroupsizeToJson(this);
}

// 时间指针的对象
@JsonSerializable()
class IDODialJsonClock extends Object {
  @JsonKey(name: 'canChangeColor')
  int? canChangeColor;

  @JsonKey(name: 'image')
  String? image;

  ///时间的类型  0默认的时间  1世界时钟
  @JsonKey(name: 'type')
  int? type;

  //暂未用到
  @JsonKey(name: 'location')
  List<dynamic>? location;

  ///世界时钟的 定位城市名的位置， type=1时 有用
  @JsonKey(name: 'cityLocation')
  List<dynamic>? dialJsonCityLocation;

  IDODialJsonClock(
      this.canChangeColor,
      this.image,
      this.type,
      this.location,
      this.dialJsonCityLocation,
      );

  factory IDODialJsonClock.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonClockFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonClockToJson(this);
}

@JsonSerializable()
class IDODialJsonFuncInfo extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'version')
  String? version;

  @JsonKey(name: 'canChangeColor')
  int? canChangeColor;

  @JsonKey(name: 'defaultFuncs')
  List<IDODialJsonDefaultFuncs>? dialJsonDefaultFuncs;

  @JsonKey(name: 'list')
  List<IDODialJsonFuncList>? dialJsonFuncList;

  @JsonKey(name: 'isSupportClose')
  int? isSupportClose;

  IDODialJsonFuncInfo(
      this.name,
      this.version,
      this.canChangeColor,
      this.dialJsonDefaultFuncs,
      this.dialJsonFuncList,
      this.isSupportClose,
      );

  factory IDODialJsonFuncInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncInfoToJson(this);
}

@JsonSerializable()
class IDODialJsonDefaultFuncs extends Object {
  @JsonKey(name: 'isClose')
  int? isClose;

  @JsonKey(name: 'funcType')
  String? funcType;

  @JsonKey(name: 'funcIcon')
  String? funcIcon;

  @JsonKey(name: 'cornerRadius')
  int? cornerRadius;

  @JsonKey(name: 'modifyContent')
  int? modifyContent;

  @JsonKey(name: 'location')
  List<int>? location;

  IDODialJsonDefaultFuncs(
      this.isClose,
      this.funcType,
      this.funcIcon,
      this.cornerRadius,
      this.modifyContent,
      this.location,
      );

  factory IDODialJsonDefaultFuncs.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonDefaultFuncsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonDefaultFuncsToJson(this);
}

@JsonSerializable()
class IDODialJsonFuncList extends Object {
  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'items')
  List<IDODialJsonFuncItems>? dialJsonFuncItems;

  IDODialJsonFuncList(
      this.type,
      this.dialJsonFuncItems,
      );

  factory IDODialJsonFuncList.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncListToJson(this);
}

@JsonSerializable()
class IDODialJsonFuncItems extends Object {
  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'icon')
  String? icon;

  @JsonKey(name: 'contentStr')
  String? contentStr;

  //widgetType > 0 照片表盘使用
  @JsonKey(name: 'widgetType')
  int? widgetType;

  IDODialJsonFuncItems(
      this.type,
      this.icon,
      this.contentStr,
      this.widgetType,
      );

  factory IDODialJsonFuncItems.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncItemsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncItemsToJson(this);
}

@JsonSerializable()
class IDODialJsonSelect extends Object {
  @JsonKey(name: 'styleIndex')
  int? styleIndex;

  @JsonKey(name: 'backgroundIndex')
  int? backgroundIndex;

  @JsonKey(name: 'color')
  int? color;

  @JsonKey(name: 'paletteIndex')
  int? paletteIndex;

  @JsonKey(name: 'timeFuncLocation')
  int? timeFuncLocation;

  @JsonKey(name: 'timeColorIndex')
  int? timeColorIndex;

  @JsonKey(name: 'funcColorIndex')
  int? funcColorIndex;

  @JsonKey(name: 'function')
  List? function;

  @JsonKey(name: 'counterTimers')
  List<dynamic>? counterTimers;

  @JsonKey(name: 'worldClock')
  String? worldClock;

  IDODialJsonSelect(
      this.styleIndex,
      this.backgroundIndex,
      this.color,
      this.paletteIndex,
      this.timeFuncLocation,
      this.timeColorIndex,
      this.funcColorIndex,
      this.function,
      this.counterTimers,
      this.worldClock,
      );

  factory IDODialJsonSelect.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonSelectFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonSelectToJson(this);
}

@JsonSerializable()
class IDODialJsonStyles extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'canChangeColor')
  int? canChangeColor;

  @JsonKey(name: 'images')
  List<String>? images;

  @JsonKey(name: 'backgroundColor')
  String? backgroundColor;

  @JsonKey(name: 'borderColor')
  String? borderColor;

  @JsonKey(name: 'borderWidth')
  double? borderWidth;

  IDODialJsonStyles(
      this.name,
      this.canChangeColor,
      this.images,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
      );

  factory IDODialJsonStyles.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonStylesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonStylesToJson(this);
}

@JsonSerializable()
class IDODialJsonPalettes extends Object {
  @JsonKey(name: 'num')
  String? num;

  @JsonKey(name: 'colors')
  String? colors;

  @JsonKey(name: 'index')
  int? index;

  IDODialJsonPalettes(
      this.num,
      this.colors,
      this.index,
      );

  factory IDODialJsonPalettes.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonPalettesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonPalettesToJson(this);
}

@JsonSerializable()
class IDODialJsonLocations extends Object {
  @JsonKey(name: 'type')
  int? type;

  @JsonKey(name: 'time')
  List<int>? time;

  @JsonKey(name: 'day')
  List<int>? day;

  @JsonKey(name: 'week')
  List<int>? week;

  @JsonKey(name: 'time_widget')
  List<Map>? timeWidget;

  @JsonKey(name: 'function_coordinate')
  List<IDOPhotoDialFunctionCoordinate>? functionCoordinate;

  IDODialJsonLocations(
      this.type,
      this.time,
      this.day,
      this.week,
      );

  factory IDODialJsonLocations.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonLocationsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonLocationsToJson(this);
}

@JsonSerializable()
class IDODialJsonCounterTimers extends Object {
  @JsonKey(name: 'location')
  List<int>? location;

  @JsonKey(name: 'defaultIndex')
  int? defaultIndex;

  //暂时无用
  @JsonKey(name: 'cornerRadius')
  int? cornerRadius;

  @JsonKey(name: 'timers')
  List<int>? timers;

  @JsonKey(name: 'textColor')
  String? textColor;

  @JsonKey(name: 'fontSize')
  int? fontSize;

  IDODialJsonCounterTimers(
      this.location,
      this.defaultIndex,
      this.cornerRadius,
      this.timers,
      this.textColor,
      this.fontSize,
      );

  factory IDODialJsonCounterTimers.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonCounterTimersFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonCounterTimersToJson(this);
}

@JsonSerializable()
class IDODialJsonCloudWallpaper extends Object {
  ///是否支持功能 默认0不支持，  1：支持功能切换
  @JsonKey(name: 'function_support')
  int? functionSupport;

  ///是否支持修改时间显示位置，默认0支持 1表盘不支持
  @JsonKey(name: 'no_support_location')
  int? noSupportLocation;

  ///是否支持修改颜色，默认0支持 1表盘不支持
  @JsonKey(name: 'no_support_colors')
  int? noSupportColors;

  IDODialJsonCloudWallpaper(
      this.functionSupport,
      this.noSupportLocation,
      this.noSupportColors,
      );

  factory IDODialJsonCloudWallpaper.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonCloudWallpaperFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonCloudWallpaperToJson(this);
}

@JsonSerializable()
class IDOPhotoDialFunctionCoordinate extends Object {
  @JsonKey(name: 'function')
  int function;

  @JsonKey(name: 'item')
  List<IDOPhotoDialFunctionCoordinateItem> item;

  IDOPhotoDialFunctionCoordinate(
      this.function,
      this.item,
      );

  factory IDOPhotoDialFunctionCoordinate.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionCoordinateFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionCoordinateToJson(this);
}

@JsonSerializable()
class IDOPhotoDialFunctionCoordinateItem extends Object {
  @JsonKey(name: 'widget')
  String widget;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'coordinate')
  List<int> coordinate;

  IDOPhotoDialFunctionCoordinateItem(
      this.widget,
      this.type,
      this.coordinate,
      );

  factory IDOPhotoDialFunctionCoordinateItem.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionCoordinateItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionCoordinateItemToJson(this);
}

@JsonSerializable()
class IDOPhotoDialFunctionList extends Object {
  @JsonKey(name: 'function')
  int function;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'item')
  List<Map> item;

  IDOPhotoDialFunctionList(
      this.function,
      this.name,
      this.item,
      );

  factory IDOPhotoDialFunctionList.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionListToJson(this);
}

@JsonSerializable()
class IDOPhotoDialTimeWidgetListItem extends Object {
  @JsonKey(name: 'widget')
  String widget;

  @JsonKey(name: 'type')
  String type;

  IDOPhotoDialTimeWidgetListItem(
      this.widget,
      this.type,
      );

  factory IDOPhotoDialTimeWidgetListItem.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeWidgetListItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeWidgetListItemToJson(this);
}
