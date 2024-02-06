import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

class GUID extends Equatable {
  final String _guid;

  GUID(String guid) : _guid = guid;

  GUID.generate() : _guid = Uuid().v4();

  bool get isEmpty => _guid == null || _guid.isEmpty;

  bool get isValid => _guid != null && _guid.isNotEmpty;
  @override
  String toString() => _guid;

  @override
  List<Object> get props => [_guid];

  factory GUID.fromJson(dynamic json) {
    return GUID(json as String);
  }

  String toJson() {
    return _guid;
  }
}

class GUIDConverter implements JsonConverter<GUID, dynamic> {
  const GUIDConverter();

  @override
  GUID fromJson(dynamic json) {
    return GUID(json as String);
  }

  @override
  String toJson(GUID guid) {
    return guid == null ? '' : guid._guid;
  }
}
