// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_dial_preset_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDOPhotoDialPresetConfig _$PhotoDialPresetConfigFromJson(
        Map<String, dynamic> json) =>
    IDOPhotoDialPresetConfig(
      json['app'] == null
          ? null
          : IDODialJsonApp.fromJson(json['app'] as Map<String, dynamic>),
      (json['zipName'] as num?)?.toInt(),
      json['dialZipName'] as String?,
      (json['backgrounds'] as List<dynamic>?)
          ?.map((e) => IDODialJsonBackgrounds.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['imagegroupsize'] == null
          ? null
          : IDOPhotoDialImageGroupSize.fromJson(
              json['imagegroupsize'] as Map<String, dynamic>),
      json['clock'] == null
          ? null
          : IDODialJsonClock.fromJson(json['clock'] as Map<String, dynamic>),
      json['funcInfo'] == null
          ? null
          : IDODialJsonFuncInfo.fromJson(json['funcInfo'] as Map<String, dynamic>),
      json['select'] == null
          ? null
          : IDODialJsonSelect.fromJson(json['select'] as Map<String, dynamic>),
      (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['styles'] as List<dynamic>?)
          ?.map((e) => IDODialJsonStyles.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['palettes'] as List<dynamic>?)
          ?.map((e) => IDODialJsonPalettes.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['locations'] as List<dynamic>?)
          ?.map((e) => IDODialJsonLocations.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counterTimers'] as List<dynamic>?)
          ?.map(
              (e) => IDODialJsonCounterTimers.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['cloudWallpaper'] == null
          ? null
          : IDODialJsonCloudWallpaper.fromJson(
              json['cloudWallpaper'] as Map<String, dynamic>),
    )
      ..functionSupport = (json['function_support'] as num?)?.toInt()
      ..functionSupportNew = (json['function_support_new'] as num?)?.toInt()
      ..functionList = (json['function_list'] as List<dynamic>?)
          ?.map((e) => IDOPhotoDialFunctionList.fromJson(e as Map<String, dynamic>))
          .toList()
      ..timeWidgetList = (json['time_widget_list'] as List<dynamic>?)
          ?.map((e) => IDOPhotoDialTimeWidgetListItem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PhotoDialPresetConfigToJson(
        IDOPhotoDialPresetConfig instance) =>
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
      'colors': instance.colors,
      'styles': instance.styles,
      'palettes': instance.palettes,
      'locations': instance.locations,
      'counterTimers': instance.counterTimers,
      'cloudWallpaper': instance.cloudWallpaper,
      'function_list': instance.functionList,
      'time_widget_list': instance.timeWidgetList,
    };

IDODialJsonApp _$DialJsonAppFromJson(Map<String, dynamic> json) => IDODialJsonApp(
      json['name'] as String?,
      (json['bpp'] as num?)?.toInt(),
      json['format'] as String?,
    );

Map<String, dynamic> _$DialJsonAppToJson(IDODialJsonApp instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bpp': instance.bpp,
      'format': instance.format,
    };

IDODialJsonBackgrounds _$DialJsonBackgroundsFromJson(Map<String, dynamic> json) =>
    IDODialJsonBackgrounds(
      (json['canChangeColor'] as num?)?.toInt(),
      json['backgroundColor'] as String?,
      json['borderColor'] as String?,
      (json['borderWidth'] as num?)?.toDouble(),
      json['funcTintColor'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$DialJsonBackgroundsToJson(
        IDODialJsonBackgrounds instance) =>
    <String, dynamic>{
      'canChangeColor': instance.canChangeColor,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'funcTintColor': instance.funcTintColor,
      'image': instance.image,
    };

IDOPhotoDialImageGroupSize _$ImagegroupsizeFromJson(Map<String, dynamic> json) =>
    IDOPhotoDialImageGroupSize(
      (json['height'] as num?)?.toInt(),
      (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ImagegroupsizeToJson(IDOPhotoDialImageGroupSize instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
    };

IDODialJsonClock _$DialJsonClockFromJson(Map<String, dynamic> json) =>
    IDODialJsonClock(
      (json['canChangeColor'] as num?)?.toInt(),
      json['image'] as String?,
      (json['type'] as num?)?.toInt(),
      json['location'] as List<dynamic>?,
      json['cityLocation'] as List<dynamic>?,
    );

Map<String, dynamic> _$DialJsonClockToJson(IDODialJsonClock instance) =>
    <String, dynamic>{
      'canChangeColor': instance.canChangeColor,
      'image': instance.image,
      'type': instance.type,
      'location': instance.location,
      'cityLocation': instance.dialJsonCityLocation,
    };

IDODialJsonFuncInfo _$DialJsonFuncInfoFromJson(Map<String, dynamic> json) =>
    IDODialJsonFuncInfo(
      json['name'] as String?,
      json['version'] as String?,
      (json['canChangeColor'] as num?)?.toInt(),
      (json['defaultFuncs'] as List<dynamic>?)
          ?.map((e) => IDODialJsonDefaultFuncs.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['list'] as List<dynamic>?)
          ?.map((e) => IDODialJsonFuncList.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['isSupportClose'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DialJsonFuncInfoToJson(IDODialJsonFuncInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'canChangeColor': instance.canChangeColor,
      'defaultFuncs': instance.dialJsonDefaultFuncs,
      'list': instance.dialJsonFuncList,
      'isSupportClose': instance.isSupportClose,
    };

IDODialJsonDefaultFuncs _$DialJsonDefaultFuncsFromJson(
        Map<String, dynamic> json) =>
    IDODialJsonDefaultFuncs(
      (json['isClose'] as num?)?.toInt(),
      json['funcType'] as String?,
      json['funcIcon'] as String?,
      (json['cornerRadius'] as num?)?.toInt(),
      (json['modifyContent'] as num?)?.toInt(),
      (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$DialJsonDefaultFuncsToJson(
        IDODialJsonDefaultFuncs instance) =>
    <String, dynamic>{
      'isClose': instance.isClose,
      'funcType': instance.funcType,
      'funcIcon': instance.funcIcon,
      'cornerRadius': instance.cornerRadius,
      'modifyContent': instance.modifyContent,
      'location': instance.location,
    };

IDODialJsonFuncList _$DialJsonFuncListFromJson(Map<String, dynamic> json) =>
    IDODialJsonFuncList(
      json['type'] as String?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => IDODialJsonFuncItems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DialJsonFuncListToJson(IDODialJsonFuncList instance) =>
    <String, dynamic>{
      'type': instance.type,
      'items': instance.dialJsonFuncItems,
    };

IDODialJsonFuncItems _$DialJsonFuncItemsFromJson(Map<String, dynamic> json) =>
    IDODialJsonFuncItems(
      json['type'] as String?,
      json['icon'] as String?,
      json['contentStr'] as String?,
      (json['widgetType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DialJsonFuncItemsToJson(IDODialJsonFuncItems instance) =>
    <String, dynamic>{
      'type': instance.type,
      'icon': instance.icon,
      'contentStr': instance.contentStr,
      'widgetType': instance.widgetType,
    };

IDODialJsonSelect _$DialJsonSelectFromJson(Map<String, dynamic> json) =>
    IDODialJsonSelect(
      (json['styleIndex'] as num?)?.toInt(),
      (json['backgroundIndex'] as num?)?.toInt(),
      (json['color'] as num?)?.toInt(),
      (json['paletteIndex'] as num?)?.toInt(),
      (json['timeFuncLocation'] as num?)?.toInt(),
      (json['timeColorIndex'] as num?)?.toInt(),
      (json['funcColorIndex'] as num?)?.toInt(),
      json['function'] as List<dynamic>?,
      json['counterTimers'] as List<dynamic>?,
      json['worldClock'] as String?,
    );

Map<String, dynamic> _$DialJsonSelectToJson(IDODialJsonSelect instance) =>
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

IDODialJsonStyles _$DialJsonStylesFromJson(Map<String, dynamic> json) =>
    IDODialJsonStyles(
      json['name'] as String?,
      (json['canChangeColor'] as num?)?.toInt(),
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['backgroundColor'] as String?,
      json['borderColor'] as String?,
      (json['borderWidth'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DialJsonStylesToJson(IDODialJsonStyles instance) =>
    <String, dynamic>{
      'name': instance.name,
      'canChangeColor': instance.canChangeColor,
      'images': instance.images,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
    };

IDODialJsonPalettes _$DialJsonPalettesFromJson(Map<String, dynamic> json) =>
    IDODialJsonPalettes(
      json['num'] as String?,
      json['colors'] as String?,
      (json['index'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DialJsonPalettesToJson(IDODialJsonPalettes instance) =>
    <String, dynamic>{
      'num': instance.num,
      'colors': instance.colors,
      'index': instance.index,
    };

IDODialJsonLocations _$DialJsonLocationsFromJson(Map<String, dynamic> json) =>
    IDODialJsonLocations(
      (json['type'] as num?)?.toInt(),
      (json['time'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      (json['day'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      (json['week'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
    )
      ..timeWidget = (json['time_widget'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..functionCoordinate = (json['function_coordinate'] as List<dynamic>?)
          ?.map((e) => IDOPhotoDialFunctionCoordinate.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$DialJsonLocationsToJson(IDODialJsonLocations instance) =>
    <String, dynamic>{
      'type': instance.type,
      'time': instance.time,
      'day': instance.day,
      'week': instance.week,
      'time_widget': instance.timeWidget,
      'function_coordinate': instance.functionCoordinate,
    };

IDODialJsonCounterTimers _$DialJsonCounterTimersFromJson(
        Map<String, dynamic> json) =>
    IDODialJsonCounterTimers(
      (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      (json['defaultIndex'] as num?)?.toInt(),
      (json['cornerRadius'] as num?)?.toInt(),
      (json['timers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      json['textColor'] as String?,
      (json['fontSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DialJsonCounterTimersToJson(
        IDODialJsonCounterTimers instance) =>
    <String, dynamic>{
      'location': instance.location,
      'defaultIndex': instance.defaultIndex,
      'cornerRadius': instance.cornerRadius,
      'timers': instance.timers,
      'textColor': instance.textColor,
      'fontSize': instance.fontSize,
    };

IDODialJsonCloudWallpaper _$DialJsonCloudWallpaperFromJson(
        Map<String, dynamic> json) =>
    IDODialJsonCloudWallpaper(
      (json['function_support'] as num?)?.toInt(),
      (json['no_support_location'] as num?)?.toInt(),
      (json['no_support_colors'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DialJsonCloudWallpaperToJson(
        IDODialJsonCloudWallpaper instance) =>
    <String, dynamic>{
      'function_support': instance.functionSupport,
      'no_support_location': instance.noSupportLocation,
      'no_support_colors': instance.noSupportColors,
    };

IDOPhotoDialFunctionCoordinate _$FunctionCoordinateFromJson(Map<String, dynamic> json) =>
    IDOPhotoDialFunctionCoordinate(
      (json['function'] as num).toInt(),
      (json['item'] as List<dynamic>)
          .map(
              (e) => IDOPhotoDialFunctionCoordinateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionCoordinateToJson(IDOPhotoDialFunctionCoordinate instance) =>
    <String, dynamic>{
      'function': instance.function,
      'item': instance.item,
    };

IDOPhotoDialFunctionCoordinateItem _$FunctionCoordinateItemFromJson(
        Map<String, dynamic> json) =>
    IDOPhotoDialFunctionCoordinateItem(
      json['widget'] as String,
      json['type'] as String,
      (json['coordinate'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$FunctionCoordinateItemToJson(
        IDOPhotoDialFunctionCoordinateItem instance) =>
    <String, dynamic>{
      'widget': instance.widget,
      'type': instance.type,
      'coordinate': instance.coordinate,
    };

IDOPhotoDialFunctionList _$FunctionListFromJson(Map<String, dynamic> json) => IDOPhotoDialFunctionList(
      (json['function'] as num).toInt(),
      json['name'] as String,
      (json['item'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$FunctionListToJson(IDOPhotoDialFunctionList instance) =>
    <String, dynamic>{
      'function': instance.function,
      'name': instance.name,
      'item': instance.item,
    };

IDOPhotoDialTimeWidgetListItem _$TimeWidgetListItemFromJson(Map<String, dynamic> json) =>
    IDOPhotoDialTimeWidgetListItem(
      json['widget'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$TimeWidgetListItemToJson(IDOPhotoDialTimeWidgetListItem instance) =>
    <String, dynamic>{
      'widget': instance.widget,
      'type': instance.type,
    };
