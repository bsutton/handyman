import 'package:json_annotation/json_annotation.dart';

/// Telephone AreaCode .e.g. 03
class AreaCode {
  String areaCode;
  AreaCode(this.areaCode);
}

class AreaCodeConverter implements JsonConverter<AreaCode, String> {
  const AreaCodeConverter();

  @override
  AreaCode fromJson(String json) {
    return AreaCode(json);
  }

  @override
  String toJson(AreaCode areaCode) {
    return areaCode == null ? '' : areaCode.areaCode;
  }
}
