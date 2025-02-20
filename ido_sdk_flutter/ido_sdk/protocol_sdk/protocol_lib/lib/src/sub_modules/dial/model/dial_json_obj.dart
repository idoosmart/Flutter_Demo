import 'package:json_annotation/json_annotation.dart';
import '../../extension/list_ext.dart';


// 表盘自定义的json文件，app.json
part 'dial_json_obj.g.dart';

@JsonSerializable()
class DialJsonObj extends Object {
  @JsonKey(name: 'app')
  DialJsonApp? app;

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
  List<DialJsonBackgrounds>? backgrounds;

  @JsonKey(name: 'imagegroupsize')
  Imagegroupsize? imagegroupsize;

  @JsonKey(name: 'clock')
  DialJsonClock? clock;

  @JsonKey(name: 'funcInfo')
  DialJsonFuncInfo? funcInfo;

  @JsonKey(name: 'select')
  DialJsonSelect? select;

  @JsonKey(name: 'styles')
  List<DialJsonStyles>? styles;

  @JsonKey(name: 'palettes')
  List<DialJsonPalettes>? palettes;

  @JsonKey(name: 'locations')
  List<DialJsonLocations>? locations;

  @JsonKey(name: 'counterTimers')
  List<DialJsonCounterTimers>? counterTimers;

  @JsonKey(name: 'cloudWallpaper')
  DialJsonCloudWallpaper? cloudWallpaper;

  @JsonKey(name: 'function_list')
  List<FunctionList>? functionList;

  @JsonKey(name: 'time_widget_list')
  List<TimeWidgetListItem>? timeWidgetList;

  DialJsonObj(
    this.app,
    this.zipName,
    this.dialZipName,
    this.backgrounds,
    this.imagegroupsize,
    this.clock,
    this.funcInfo,
    this.select,
    this.styles,
    this.palettes,
    this.locations,
    this.counterTimers,
    this.cloudWallpaper,
  );

  factory DialJsonObj.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonObjToJson(this);

  List<String> palettesToColorList() {
    List<String> list = [];

    if (palettes != null) {
      for (DialJsonPalettes palettes in palettes!) {
        if (palettes.colors != null) {
          list.add(palettes.colors!);
        }
      }
    }

    return list;
  }

  DialJsonLocations? locationsForType(int type) {
    if (locations?.isEmpty ?? true) {
      return null;
    }
    return locations!.firstWhereOrNull((element) => element.type == type);
  }

  FunctionList? functionListForType(String type) {
    if (functionList?.isEmpty ?? true) {
      return null;
    }
    return functionList!.firstWhereOrNull((element) => element.name == type);
  }

  FunctionList? functionListForFuncation(String type) {
    if (functionList?.isEmpty ?? true) {
      return null;
    }
    return functionList!.firstWhereOrNull((element) => element.name == type);
  }
}

@JsonSerializable()
class DialJsonApp extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'bpp')
  int? bpp;

  @JsonKey(name: 'format')
  String? format;

  DialJsonApp(
    this.name,
    this.bpp,
    this.format,
  );

  factory DialJsonApp.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonAppFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonAppToJson(this);
}

@JsonSerializable()
class DialJsonBackgrounds extends Object {
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

  DialJsonBackgrounds(
    this.canChangeColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.funcTintColor,
    this.image,
  );

  factory DialJsonBackgrounds.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonBackgroundsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonBackgroundsToJson(this);
}

@JsonSerializable()
class Imagegroupsize extends Object {
  @JsonKey(name: 'height')
  int? height;

  @JsonKey(name: 'width')
  int? width;

  Imagegroupsize(
    this.height,
    this.width,
  );

  factory Imagegroupsize.fromJson(Map<String, dynamic> srcJson) =>
      _$ImagegroupsizeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImagegroupsizeToJson(this);
}

// 时间指针的对象
@JsonSerializable()
class DialJsonClock extends Object {
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

  DialJsonClock(
    this.canChangeColor,
    this.image,
    this.type,
    this.location,
    this.dialJsonCityLocation,
  );

  factory DialJsonClock.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonClockFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonClockToJson(this);
}

@JsonSerializable()
class DialJsonFuncInfo extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'version')
  String? version;

  @JsonKey(name: 'canChangeColor')
  int? canChangeColor;

  @JsonKey(name: 'defaultFuncs')
  List<DialJsonDefaultFuncs>? dialJsonDefaultFuncs;

  @JsonKey(name: 'list')
  List<DialJsonFuncList>? dialJsonFuncList;

  @JsonKey(name: 'isSupportClose')
  int? isSupportClose;

  DialJsonFuncInfo(
    this.name,
    this.version,
    this.canChangeColor,
    this.dialJsonDefaultFuncs,
    this.dialJsonFuncList,
    this.isSupportClose,
  );

  factory DialJsonFuncInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncInfoToJson(this);
}

@JsonSerializable()
class DialJsonDefaultFuncs extends Object {
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

  DialJsonDefaultFuncs(
    this.isClose,
    this.funcType,
    this.funcIcon,
    this.cornerRadius,
    this.modifyContent,
    this.location,
  );

  factory DialJsonDefaultFuncs.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonDefaultFuncsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonDefaultFuncsToJson(this);
}

@JsonSerializable()
class DialJsonFuncList extends Object {
  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'items')
  List<DialJsonFuncItems>? dialJsonFuncItems;

  DialJsonFuncList(
    this.type,
    this.dialJsonFuncItems,
  );

  factory DialJsonFuncList.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncListToJson(this);
}

@JsonSerializable()
class DialJsonFuncItems extends Object {
  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'icon')
  String? icon;

  @JsonKey(name: 'contentStr')
  String? contentStr;

  //widgetType > 0 照片表盘使用
  @JsonKey(name: 'widgetType')
  int? widgetType;

  DialJsonFuncItems(
    this.type,
    this.icon,
    this.contentStr,
    this.widgetType,
  );

  factory DialJsonFuncItems.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonFuncItemsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonFuncItemsToJson(this);
}

@JsonSerializable()
class DialJsonSelect extends Object {
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

  DialJsonSelect(
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

  factory DialJsonSelect.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonSelectFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonSelectToJson(this);
}

@JsonSerializable()
class DialJsonStyles extends Object {
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

  DialJsonStyles(
    this.name,
    this.canChangeColor,
    this.images,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  );

  factory DialJsonStyles.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonStylesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonStylesToJson(this);
}

@JsonSerializable()
class DialJsonPalettes extends Object {
  @JsonKey(name: 'num')
  String? num;

  @JsonKey(name: 'colors')
  String? colors;

  @JsonKey(name: 'index')
  int? index;

  DialJsonPalettes(
    this.num,
    this.colors,
    this.index,
  );

  factory DialJsonPalettes.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonPalettesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonPalettesToJson(this);
}

@JsonSerializable()
class DialJsonLocations extends Object {
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
  List<FunctionCoordinate>? functionCoordinate;

  DialJsonLocations(
    this.type,
    this.time,
    this.day,
    this.week,
  );

  factory DialJsonLocations.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonLocationsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonLocationsToJson(this);
}

@JsonSerializable()
class DialJsonCounterTimers extends Object {
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

  DialJsonCounterTimers(
    this.location,
    this.defaultIndex,
    this.cornerRadius,
    this.timers,
    this.textColor,
    this.fontSize,
  );

  factory DialJsonCounterTimers.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonCounterTimersFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonCounterTimersToJson(this);
}

@JsonSerializable()
class DialJsonCloudWallpaper extends Object {
  ///是否支持功能 默认0不支持，  1：支持功能切换
  @JsonKey(name: 'function_support')
  int? functionSupport;

  ///是否支持修改时间显示位置，默认0支持 1表盘不支持
  @JsonKey(name: 'no_support_location')
  int? noSupportLocation;

  ///是否支持修改颜色，默认0支持 1表盘不支持
  @JsonKey(name: 'no_support_colors')
  int? noSupportColors;

  DialJsonCloudWallpaper(
    this.functionSupport,
    this.noSupportLocation,
    this.noSupportColors,
  );

  factory DialJsonCloudWallpaper.fromJson(Map<String, dynamic> srcJson) =>
      _$DialJsonCloudWallpaperFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialJsonCloudWallpaperToJson(this);
}

@JsonSerializable()
class FunctionCoordinate extends Object {
  @JsonKey(name: 'function')
  int function;

  @JsonKey(name: 'item')
  List<FunctionCoordinateItem> item;

  FunctionCoordinate(
    this.function,
    this.item,
  );

  factory FunctionCoordinate.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionCoordinateFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionCoordinateToJson(this);
}

@JsonSerializable()
class FunctionCoordinateItem extends Object {
  @JsonKey(name: 'widget')
  String widget;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'coordinate')
  List<int> coordinate;

  FunctionCoordinateItem(
    this.widget,
    this.type,
    this.coordinate,
  );

  factory FunctionCoordinateItem.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionCoordinateItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionCoordinateItemToJson(this);
}

@JsonSerializable()
class FunctionList extends Object {
  @JsonKey(name: 'function')
  int function;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'item')
  List<Map> item;

  FunctionList(
    this.function,
    this.name,
    this.item,
  );

  factory FunctionList.fromJson(Map<String, dynamic> srcJson) =>
      _$FunctionListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FunctionListToJson(this);
}

@JsonSerializable()
class TimeWidgetListItem extends Object {
  @JsonKey(name: 'widget')
  String widget;

  @JsonKey(name: 'type')
  String type;

  TimeWidgetListItem(
    this.widget,
    this.type,
  );

  factory TimeWidgetListItem.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeWidgetListItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeWidgetListItemToJson(this);
}
