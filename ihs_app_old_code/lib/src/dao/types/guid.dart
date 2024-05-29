import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

class GUID extends Equatable {
  const GUID(String guid) : _guid = guid;

  GUID.generate() : _guid = const Uuid().v4();

  factory GUID.fromJson(dynamic json) => GUID(json as String);
  final String _guid;

  bool get isEmpty => _guid.isEmpty;

  bool get isValid => _guid.isNotEmpty;
  @override
  String toString() => _guid;

  @override
  List<Object> get props => [_guid];

  String toJson() => _guid;
}

class GUIDConverter implements JsonConverter<GUID, dynamic> {
  const GUIDConverter();

  @override
  GUID fromJson(dynamic json) => GUID(json as String);

  @override
  String toJson(GUID guid) => guid._guid;
}
