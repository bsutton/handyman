import 'package:json_annotation/json_annotation.dart';

class Timezone {
  Timezone(this.name, this.humanName);
  String name;
  String humanName;
}

class TimezoneConverter
    implements JsonConverter<Timezone, Map<String, dynamic>> {
  const TimezoneConverter();
  @override
  Timezone fromJson(Map<String, dynamic> value) {
    final name = value['name'] as String;
    final humanName = value['humanName'] as String;

    return Timezone(name, humanName);
  }

  @override
  Map<String, dynamic> toJson(Timezone timezone) => {
        'name': timezone.name,
        'humanName': timezone.humanName,
      };
}
