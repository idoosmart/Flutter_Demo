// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectiveModel _$DirectiveModelFromJson(Map<String, dynamic> json) =>
    DirectiveModel(
      header: json['header'] == null
          ? null
          : Header.fromJson(json['header'] as Map<String, dynamic>),
      payload: json['payload'] == null
          ? null
          : Payload.fromJson(json['payload'] as Map<String, dynamic>),
      endpoint: json['endpoint'] == null
          ? null
          : Endpoint.fromJson(json['endpoint'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DirectiveModelToJson(DirectiveModel instance) =>
    <String, dynamic>{
      'header': instance.header,
      'payload': instance.payload,
      'endpoint': instance.endpoint,
    };

Header _$HeaderFromJson(Map<String, dynamic> json) => Header(
      namespace: json['namespace'] as String?,
      name: json['name'] as String?,
      messageId: json['messageId'] as String?,
      dialogRequestId: json['dialogRequestId'] as String?,
      payloadVersion: json['payloadVersion'] as String?,
      eventCorrelationToken: json['eventCorrelationToken'] as String?,
      correlationToken: json['correlationToken'] as String?,
      instance: json['instance'] as String?,
    );

Map<String, dynamic> _$HeaderToJson(Header instance) => <String, dynamic>{
      'namespace': instance.namespace,
      'name': instance.name,
      'messageId': instance.messageId,
      'dialogRequestId': instance.dialogRequestId,
      'payloadVersion': instance.payloadVersion,
      'eventCorrelationToken': instance.eventCorrelationToken,
      'correlationToken': instance.correlationToken,
      'instance': instance.instance,
    };

Payload _$PayloadFromJson(Map<String, dynamic> json) => Payload(
      type: json['type'] as String?,
      token: json['token'] as String?,
      title: json['title'] == null
          ? null
          : Title.fromJson(json['title'] as Map<String, dynamic>),
      textField: json['textField'],
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      playBehavior: json['playBehavior'] as String?,
      url: json['url'] as String?,
      caption: json['caption'] == null
          ? null
          : Caption.fromJson(json['caption'] as Map<String, dynamic>),
      audioItem: json['audioItem'] == null
          ? null
          : AudioItem.fromJson(json['audioItem'] as Map<String, dynamic>),
      clearBehavior: json['clearBehavior'] as String?,
      listItems: json['listItems'] as List<dynamic>?,
      currentWeather: json['currentWeather'] as String?,
      currentWeatherIcon: json['currentWeatherIcon'] as Map<String, dynamic>?,
      highTemperature: json['highTemperature'] as Map<String, dynamic>?,
      lowTemperature: json['lowTemperature'] as Map<String, dynamic>?,
      weatherForecast: json['weatherForecast'] as List<dynamic>?,
      scheduledTime: json['scheduledTime'] as String?,
      rangeValue: json['rangeValue'],
      rangeValueDelta: json['rangeValueDelta'],
      label: json['label'] as String?,
      dialogRequestId: json['dialogRequestId'],
      tokens: json['tokens'],
    );

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'type': instance.type,
      'token': instance.token,
      'title': instance.title,
      'textField': instance.textField,
      'image': instance.image,
      'playBehavior': instance.playBehavior,
      'clearBehavior': instance.clearBehavior,
      'url': instance.url,
      'scheduledTime': instance.scheduledTime,
      'label': instance.label,
      'rangeValue': instance.rangeValue,
      'rangeValueDelta': instance.rangeValueDelta,
      'dialogRequestId': instance.dialogRequestId,
      'caption': instance.caption,
      'audioItem': instance.audioItem,
      'listItems': instance.listItems,
      'currentWeather': instance.currentWeather,
      'currentWeatherIcon': instance.currentWeatherIcon,
      'highTemperature': instance.highTemperature,
      'lowTemperature': instance.lowTemperature,
      'weatherForecast': instance.weatherForecast,
      'tokens': instance.tokens,
    };

Endpoint _$EndpointFromJson(Map<String, dynamic> json) => Endpoint(
      endpointId: json['endpointId'] as String?,
      cookie: json['cookie'],
    );

Map<String, dynamic> _$EndpointToJson(Endpoint instance) => <String, dynamic>{
      'endpointId': instance.endpointId,
      'cookie': instance.cookie,
    };

Title _$TitleFromJson(Map<String, dynamic> json) => Title(
      subTitle: json['subTitle'] as String?,
      mainTitle: json['mainTitle'] as String?,
    );

Map<String, dynamic> _$TitleToJson(Title instance) => <String, dynamic>{
      'subTitle': instance.subTitle,
      'mainTitle': instance.mainTitle,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => Sources.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'sources': instance.sources,
    };

Sources _$SourcesFromJson(Map<String, dynamic> json) => Sources(
      size: json['size'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$SourcesToJson(Sources instance) => <String, dynamic>{
      'size': instance.size,
      'url': instance.url,
    };

Caption _$CaptionFromJson(Map<String, dynamic> json) => Caption(
      type: json['type'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$CaptionToJson(Caption instance) => <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
    };

AudioItem _$AudioItemFromJson(Map<String, dynamic> json) => AudioItem(
      stream: json['stream'] == null
          ? null
          : AudioStream.fromJson(json['stream'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AudioItemToJson(AudioItem instance) => <String, dynamic>{
      'stream': instance.stream,
    };

AudioStream _$AudioStreamFromJson(Map<String, dynamic> json) => AudioStream(
      url: json['url'] as String?,
      caption: json['caption'] == null
          ? null
          : Caption.fromJson(json['caption'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AudioStreamToJson(AudioStream instance) =>
    <String, dynamic>{
      'url': instance.url,
      'caption': instance.caption,
    };
