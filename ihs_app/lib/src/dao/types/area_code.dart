import 'package:json_annotation/json_annotation.dart';

/// Telephone AreaCode .e.g. 03
class AreaCode {
  AreaCode(this.areaCode);
  String areaCode;
}

class AreaCodeConverter implements JsonConverter<AreaCode, String> {
  const AreaCodeConverter();

  @override
  AreaCode fromJson(String json) => AreaCode(json);

  @override
  String toJson(AreaCode areaCode) => areaCode.areaCode;
}
