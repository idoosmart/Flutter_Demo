// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_json_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialJsonObj _$DialJsonObjFromJson(Map<String, dynamic> json) => DialJsonObj(
      json['app'] == null
          ? null
          : DialJsonApp.fromJson(json['app'] as Map<String, dynamic>),
      json['zipName'] as int?,
      json['dialZipName'] as String?,
      (json['backgrounds'] as List<dynamic>?)
          ?.map((e) => DialJsonBackgrounds.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['imagegroupsize'] == null
          ? null
          : Imagegroupsize.fromJson(
              json['imagegroupsize'] as Map<String, dynamic>),
      json['clock'] == null
          ? null
          : DialJsonClock.fromJson(json['clock'] as Map<String, dynamic>),
      json['funcInfo'] == null
          ? null
          : DialJsonFuncInfo.fromJson(json['funcInfo'] as Map<String, dynamic>),
      json['select'] == null
          ? null
          : DialJsonSelect.fromJson(json['select'] as Map<String, dynamic>),
      (json['styles'] as List<dynamic>?)
          ?.map((e) => DialJsonStyles.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['palettes'] as List<dynamic>?)
          ?.map((e) => DialJsonPalettes.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['locations'] as List<dynamic>?)
          ?.map((e) => DialJsonLocations.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counterTimers'] as List<dynamic>?)
          ?.map(
              (e) => DialJsonCounterTimers.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['cloudWallpaper'] == null
          ? null
          : DialJsonCloudWallpaper.fromJson(
              json['cloudWallpaper'] as Map<String, dynamic>),
    )
      ..functionSupport = json['function_support'] as int?
      ..functionSupportNew = json['function_support_new'] as int?
      ..functionList = (json['function_list'] as List<dynamic>?)
          ?.map((e) => FunctionList.fromJson(e as Map<String, dynamic>))
          .toList()
      ..timeWidgetList = (json['time_widget_list'] as List<dynamic>?)
          ?.map((e) => TimeWidgetListItem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$DialJsonObjToJson(DialJsonObj instance) =>
    <String, dynamic>{
      'app': instance.app,
      'zipName': instance.zipName,
      'function_support': instance.functionSupport,
      'function_support_new': instance.functionSupportNew,
      'dialZipName': instance.dialZipName,
      'backgrounds': instance.backgrounds,
      'imagegroupsize': instance.imagegroupsize,
      'clock': instance.clock,
      'funcInfo': instance.funcInfo,
      'select': instance.select,
      'styles': instance.styles,
      'palettes': instance.palettes,
      'locations': instance.locations,
      'counterTimers': instance.counterTimers,
      'cloudWallpaper': instance.cloudWallpaper,
      'function_list': instance.functionList,
      'time_widget_list': instance.timeWidgetList,
    };

DialJsonApp _$DialJsonAppFromJson(Map<String, dynamic> json) => DialJsonApp(
      json['name'] as String?,
      json['bpp'] as int?,
      json['format'] as String?,
    );

Map<String, dynamic> _$DialJsonAppToJson(DialJsonApp instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bpp': instance.bpp,
      'format': instance.format,
    };

DialJsonBackgrounds _$DialJsonBackgroundsFromJson(Map<String, dynamic> json) =>
    DialJsonBackgrounds(
      json['canChangeColor'] as int?,
      json['backgroundColor'] as String?,
      json['borderColor'] as String?,
      (json['borderWidth'] as num?)?.toDouble(),
      json['funcTintColor'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$DialJsonBackgroundsToJson(
        DialJsonBackgrounds instance) =>
    <String, dynamic>{
      'canChangeColor': instance.canChangeColor,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'funcTintColor': instance.funcTintColor,
      'image': instance.image,
    };

Imagegroupsize _$ImagegroupsizeFromJson(Map<String, dynamic> json) =>
    Imagegroupsize(
      json['height'] as int?,
      json['width'] as int?,
    );

Map<String, dynamic> _$ImagegroupsizeToJson(Imagegroupsize instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
    };

DialJsonClock _$DialJsonClockFromJson(Map<String, dynamic> json) =>
    DialJsonClock(
      json['canChangeColor'] as int?,
      json['image'] as String?,
      json['type'] as int?,
      json['location'] as List<dynamic>?,
      json['cityLocation'] as List<dynamic>?,
    );

Map<String, dynamic> _$DialJsonClockToJson(DialJsonClock instance) =>
    <String, dynamic>{
      'canChangeColor': instance.canChangeColor,
      'image': instance.image,
      'type': instance.type,
      'location': instance.location,
      'cityLocation': instance.dialJsonCityLocation,
    };

DialJsonFuncInfo _$DialJsonFuncInfoFromJson(Map<String, dynamic> json) =>
    DialJsonFuncInfo(
      json['name'] as String?,
      json['version'] as String?,
      json['canChangeColor'] as int?,
      (json['defaultFuncs'] as List<dynamic>?)
          ?.map((e) => DialJsonDefaultFuncs.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['list'] as List<dynamic>?)
          ?.map((e) => DialJsonFuncList.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['isSupportClose'] as int?,
    );

Map<String, dynamic> _$DialJsonFuncInfoToJson(DialJsonFuncInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'canChangeColor': instance.canChangeColor,
      'defaultFuncs': instance.dialJsonDefaultFuncs,
      'list': instance.dialJsonFuncList,
      'isSupportClose': instance.isSupportClose,
    };

DialJsonDefaultFuncs _$DialJsonDefaultFuncsFromJson(
        Map<String, dynamic> json) =>
    DialJsonDefaultFuncs(
      json['isClose'] as int?,
      json['funcType'] as String?,
      json['funcIcon'] as String?,
      json['cornerRadius'] as int?,
      json['modifyContent'] as int?,
      (json['location'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$DialJsonDefaultFuncsToJson(
        DialJsonDefaultFuncs instance) =>
    <String, dynamic>{
      'isClose': instance.isClose,
      'funcType': instance.funcType,
      'funcIcon': instance.funcIcon,
      'cornerRadius': instance.cornerRadius,
      'modifyContent': instance.modifyContent,
      'location': instance.location,
    };

DialJsonFuncList _$DialJsonFuncListFromJson(Map<String, dynamic> json) =>
    DialJsonFuncList(
      json['type'] as String?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => DialJsonFuncItems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DialJsonFuncListToJson(DialJsonFuncList instance) =>
    <String, dynamic>{
      'type': instance.type,
      'items': instance.dialJsonFuncItems,
    };

DialJsonFuncItems _$DialJsonFuncItemsFromJson(Map<String, dynamic> json) =>
    DialJsonFuncItems(
      json['type'] as String?,
      json['icon'] as String?,
      json['contentStr'] as String?,
      json['widgetType'] as int?,
    );

Map<String, dynamic> _$DialJsonFuncItemsToJson(DialJsonFuncItems instance) =>
    <String, dynamic>{
      'type': instance.type,
      'icon': instance.icon,
      'contentStr': instance.contentStr,
      'widgetType': instance.widgetType,
    };

DialJsonSelect _$DialJsonSelectFromJson(Map<String, dynamic> json) =>
    DialJsonSelect(
      json['styleIndex'] as int?,
      json['backgroundIndex'] as int?,
      json['color'] as int?,
      json['paletteIndex'] as int?,
      json['timeFuncLocation'] as int?,
      json['timeColorIndex'] as int?,
      json['funcColorIndex'] as int?,
      json['function'] as List<dynamic>?,
      json['counterTimers'] as List<dynamic>?,
      json['worldClock'] as String?,
    );

Map<String, dynamic> _$DialJsonSelectToJson(DialJsonSelect instance) =>
    <String, dynamic>{
      'styleIndex': instance.styleIndex,
      'backgroundIndex': instance.backgroundIndex,
      'color': instance.color,
      'paletteIndex': instance.paletteIndex,
      'timeFuncLocation': instance.timeFuncLocation,
      'timeColorIndex': instance.timeColorIndex,
      'funcColorIndex': instance.funcColorIndex,
      'function': instance.function,
      'counterTimers': instance.counterTimers,
      'worldClock': instance.worldClock,
    };

DialJsonStyles _$DialJsonStylesFromJson(Map<String, dynamic> json) =>
    DialJsonStyles(
      json['name'] as String?,
      json['canChangeColor'] as int?,
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['backgroundColor'] as String?,
      json['borderColor'] as String?,
      (json['borderWidth'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DialJsonStylesToJson(DialJsonStyles instance) =>
    <String, dynamic>{
      'name': instance.name,
      'canChangeColor': instance.canChangeColor,
      'images': instance.images,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
    };

DialJsonPalettes _$DialJsonPalettesFromJson(Map<String, dynamic> json) =>
    DialJsonPalettes(
      json['num'] as String?,
      json['colors'] as String?,
      json['index'] as int?,
    );

Map<String, dynamic> _$DialJsonPalettesToJson(DialJsonPalettes instance) =>
    <String, dynamic>{
      'num': instance.num,
      'colors': instance.colors,
      'index': instance.index,
    };

DialJsonLocations _$DialJsonLocationsFromJson(Map<String, dynamic> json) =>
    DialJsonLocations(
      json['type'] as int?,
      (json['time'] as List<dynamic>?)?.map((e) => e as int).toList(),
      (json['day'] as List<dynamic>?)?.map((e) => e as int).toList(),
      (json['week'] as List<dynamic>?)?.map((e) => e as int).toList(),
    )
      ..timeWidget = (json['time_widget'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..functionCoordinate = (json['function_coordinate'] as List<dynamic>?)
          ?.map((e) => FunctionCoordinate.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$DialJsonLocationsToJson(DialJsonLocations instance) =>
    <String, dynamic>{
      'type': instance.type,
      'time': instance.time,
      'day': instance.day,
      'week': instance.week,
      'time_widget': instance.timeWidget,
      'function_coordinate': instance.functionCoordinate,
    };

DialJsonCounterTimers _$DialJsonCounterTimersFromJson(
        Map<String, dynamic> json) =>
    DialJsonCounterTimers(
      (json['location'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['defaultIndex'] as int?,
      json['cornerRadius'] as int?,
      (json['timers'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['textColor'] as String?,
      json['fontSize'] as int?,
    );

Map<String, dynamic> _$DialJsonCounterTimersToJson(
        DialJsonCounterTimers instance) =>
    <String, dynamic>{
      'location': instance.location,
      'defaultIndex': instance.defaultIndex,
      'cornerRadius': instance.cornerRadius,
      'timers': instance.timers,
      'textColor': instance.textColor,
      'fontSize': instance.fontSize,
    };

DialJsonCloudWallpaper _$DialJsonCloudWallpaperFromJson(
        Map<String, dynamic> json) =>
    DialJsonCloudWallpaper(
      json['function_support'] as int?,
      json['no_support_location'] as int?,
      json['no_support_colors'] as int?,
    );

Map<String, dynamic> _$DialJsonCloudWallpaperToJson(
        DialJsonCloudWallpaper instance) =>
    <String, dynamic>{
      'function_support': instance.functionSupport,
      'no_support_location': instance.noSupportLocation,
      'no_support_colors': instance.noSupportColors,
    };

FunctionCoordinate _$FunctionCoordinateFromJson(Map<String, dynamic> json) =>
    FunctionCoordinate(
      json['function'] as int,
      (json['item'] as List<dynamic>)
          .map(
              (e) => FunctionCoordinateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionCoordinateToJson(FunctionCoordinate instance) =>
    <String, dynamic>{
      'function': instance.function,
      'item': instance.item,
    };

FunctionCoordinateItem _$FunctionCoordinateItemFromJson(
        Map<String, dynamic> json) =>
    FunctionCoordinateItem(
      json['widget'] as String,
      json['type'] as String,
      (json['coordinate'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$FunctionCoordinateItemToJson(
        FunctionCoordinateItem instance) =>
    <String, dynamic>{
      'widget': instance.widget,
      'type': instance.type,
      'coordinate': instance.coordinate,
    };

FunctionList _$FunctionListFromJson(Map<String, dynamic> json) => FunctionList(
      json['function'] as int,
      json['name'] as String,
      (json['item'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$FunctionListToJson(FunctionList instance) =>
    <String, dynamic>{
      'function': instance.function,
      'name': instance.name,
      'item': instance.item,
    };

TimeWidgetListItem _$TimeWidgetListItemFromJson(Map<String, dynamic> json) =>
    TimeWidgetListItem(
      json['widget'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$TimeWidgetListItemToJson(TimeWidgetListItem instance) =>
    <String, dynamic>{
      'widget': instance.widget,
      'type': instance.type,
    };
