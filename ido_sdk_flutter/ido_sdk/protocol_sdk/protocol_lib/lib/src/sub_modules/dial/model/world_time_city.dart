import 'dart:convert';

class WorldTimeCity {
  final int id;

  final String name;

  final String country;

  final String abbreviation;

  final String latitude;

  final String longitude;

  final String timeZoneName;

  final String nameKey;

  final String countryKey;

  WorldTimeCity(
      {required this.id,
      required this.name,
      required this.country,
      required this.abbreviation,
      required this.latitude,
      required this.longitude,
      required this.timeZoneName,
      required this.nameKey,
      required this.countryKey});

  factory WorldTimeCity.formJson(Map<String, dynamic> json) => _$WorldCityFromJson(json);



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorldTimeCity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // String getCityName({String? languageCode}) {
  //   return LanguageUtils.getWorldValue(nameKey, languageCode ?? TranslateManager().getCurrentLocal().languageCode);
  // }
  //
  // String getCountry({String? languageCode}) {
  //   return LanguageUtils.getWorldValue(countryKey,TranslateManager().getCurrentLocal().languageCode);
  // }
}

List<WorldTimeCity> worldCityListFromJson(String jsonStr) {
  List<dynamic> parse =  json.decode(jsonStr);
  return parse.map((e) => WorldTimeCity.formJson(e as Map<String, dynamic>)).toList();
}


WorldTimeCity _$WorldCityFromJson(Map<String, dynamic> json) => WorldTimeCity(
  id: json['id'] as int,
  name: json['name'] as String,
  country: json['country'] as String,
  abbreviation: json['abbreviation'] as String,
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  timeZoneName: json['timeZoneName'] as String,
  nameKey: json['nameKey'] as String,
  countryKey: json['countryKey'] as String,
);