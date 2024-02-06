import 'package:json_annotation/json_annotation.dart';

class Timezone {
  String name;
  String humanName;

  Timezone(this.name, this.humanName);
}

class TimezoneConverter implements JsonConverter<Timezone, Map<String, dynamic>> {
  const TimezoneConverter();
  @override
  Timezone fromJson(Map<String, dynamic> value) {
    var name = value['name'] as String;
    var humanName = value['humanName'] as String;

    return Timezone(name, humanName);
  }

  @override
  Map<String, dynamic> toJson(Timezone timezone) {
    var map = <String, String>{};

    if (timezone != null) {
      map = {
        'name': '${timezone.name}',
        'humanName': '${timezone.humanName}',
      };
    }
    return map;
  }
}
