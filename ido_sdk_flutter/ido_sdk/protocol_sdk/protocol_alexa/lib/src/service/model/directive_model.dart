import 'package:json_annotation/json_annotation.dart';

part 'directive_model.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class DirectiveModel {
  final Header? header;
  final Payload? payload;
  final Endpoint? endpoint;

  const DirectiveModel({
    this.header,
    this.payload,
    this.endpoint,
  });

  factory DirectiveModel.fromJson(Map<String, dynamic> json) =>
      _$DirectiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$DirectiveModelToJson(this);

  @override
  String toString() {
    return '{header: $header, payload: $payload, endpoint: $endpoint}';
  }

  // 停止流数据
  bool get isStopCapture => header?.name == 'StopCapture';

  // 存在流数据
  bool get isSpeak => header?.name == 'Speak';
}

@JsonSerializable()
class Header {
  final String? namespace;
  final String? name;
  final String? messageId;
  final String? dialogRequestId;
  final String? payloadVersion;
  final String? eventCorrelationToken;
  final String? correlationToken;
  final String? instance;

  const Header({
    this.namespace,
    this.name,
    this.messageId,
    this.dialogRequestId,
    this.payloadVersion,
    this.eventCorrelationToken,
    this.correlationToken,
    this.instance,
  });

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderToJson(this);

  @override
  String toString() {
    return '{namespace: $namespace, name: $name, messageId: $messageId, dialogRequestId: $dialogRequestId, payloadVersion: $payloadVersion, '
        'eventCorrelationToken: $eventCorrelationToken, correlationToken: $correlationToken, instance: $instance}';
  }
}

@JsonSerializable()
class Payload {
  final String? type;
  final String? token;
  final Title? title;
  final dynamic textField;
  final Image? image;
  final String? playBehavior;
  final String? clearBehavior;
  final String? url;
  final String? scheduledTime;
  final String? label;
  final dynamic rangeValue;
  final dynamic rangeValueDelta;
  final dynamic dialogRequestId;

  final Caption? caption;
  final AudioItem? audioItem;
  final List? listItems;
  //* 天气 */
  final String? currentWeather;
  final Map? currentWeatherIcon;
  final Map? highTemperature;
  final Map? lowTemperature;
  final List? weatherForecast;
  final dynamic? tokens;//删除闹钟用的到

  const Payload({
    this.type,
    this.token,
    this.title,
    this.textField,
    this.image,
    this.playBehavior,
    this.url,
    this.caption,
    this.audioItem,
    this.clearBehavior,
    this.listItems,
    this.currentWeather,
    this.currentWeatherIcon,
    this.highTemperature,
    this.lowTemperature,
    this.weatherForecast,
    this.scheduledTime,
    this.rangeValue,
    this.rangeValueDelta,
    this.label,
    this.dialogRequestId,
    this.tokens,
  });

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);

  @override
  String toString() {
    return 'Payload{type: $type, token: $token, title: $title, textField: $textField, image: $image, '
           'playBehavior: $playBehavior, clearBehavior: $clearBehavior, url: $url, caption: $caption, '
           'audioItem: $audioItem, listItems: $listItems, currentWeather: $currentWeather, currentWeatherIcon: $currentWeatherIcon, '
        'highTemperature: $highTemperature, lowTemperature: $lowTemperature, weatherForecast: $weatherForecast, scheduledTime: $scheduledTime, '
        'rangeValue: $rangeValue, rangeValueDelta: $rangeValueDelta, label: $label, dialogRequestId: $dialogRequestId, tokens: $tokens}';
  }
}

@JsonSerializable()
class Endpoint {
  final String? endpointId;
  final dynamic cookie;

  const Endpoint({
    this.endpointId,
    this.cookie,
  });

  factory Endpoint.fromJson(Map<String, dynamic> json) =>
      _$EndpointFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointToJson(this);

  @override
  String toString() {
    return 'Endpoint{endpointId: $endpointId, cookie: $cookie}';
  }
}

@JsonSerializable()
class Title {
  final String? subTitle;
  final String? mainTitle;

  const Title({
    this.subTitle,
    this.mainTitle,
  });

  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json);

  Map<String, dynamic> toJson() => _$TitleToJson(this);

  @override
  String toString() {
    return 'Title{subTitle: $subTitle, mainTitle: $mainTitle}';
  }
}

@JsonSerializable()
class Image {
  final List<Sources>? sources;

  const Image({
    this.sources,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

  @override
  String toString() {
    return 'Image{sources: $sources}';
  }
}

@JsonSerializable()
class Sources {
  final String? size;
  final String? url;

  const Sources({
    this.size,
    this.url,
  });

  factory Sources.fromJson(Map<String, dynamic> json) =>
      _$SourcesFromJson(json);

  Map<String, dynamic> toJson() => _$SourcesToJson(this);

  @override
  String toString() {
    return 'Sources{size: $size, url: $url}';
  }
}

@JsonSerializable()
class Caption {
  final String? type;
  final String? content;

  const Caption({
    this.type,
    this.content,
  });

  factory Caption.fromJson(Map<String, dynamic> json) =>
      _$CaptionFromJson(json);

  Map<String, dynamic> toJson() => _$CaptionToJson(this);

  @override
  String toString() {
    return 'Caption{type: $type, content: $content}';
  }
}
@JsonSerializable()
class AudioItem {
  final AudioStream? stream;

  const AudioItem({
    this.stream,
  });

  factory AudioItem.fromJson(Map<String, dynamic> json) =>
      _$AudioItemFromJson(json);

  Map<String, dynamic> toJson() => _$AudioItemToJson(this);

  @override
  String toString() {
    return 'AudioItem{stream: $stream}';
  }
}
@JsonSerializable()
class AudioStream {
  final String? url;
  final Caption? caption;

  const AudioStream({
    this.url,
    this.caption,
  });

  factory AudioStream.fromJson(Map<String, dynamic> json) =>
      _$AudioStreamFromJson(json);

  Map<String, dynamic> toJson() => _$AudioStreamToJson(this);

  @override
  String toString() {
    return 'AudioStream{url: $url, caption: $caption}';
  }
}