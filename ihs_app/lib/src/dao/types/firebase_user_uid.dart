import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// used to transport the Firebase User UID generated
/// at the completion of the stage 1 firebase sign in (post mobile no. verification).
class FirebaseTempUserUid extends Equatable {
  final String _uid;

  FirebaseTempUserUid(String guid) : _uid = guid;

  bool get isEmpty => _uid.isEmpty;

  bool get isValid => _uid != null && _uid.isNotEmpty;
  @override
  String toString() => _uid;

  @override
  List<Object> get props => [_uid];

  factory FirebaseTempUserUid.fromJson(dynamic json) {
    return FirebaseTempUserUid(json as String);
  }

  String toJson() {
    return _uid;
  }
}

class FirebaseTempUserUidConverter implements JsonConverter<FirebaseTempUserUid, dynamic> {
  const FirebaseTempUserUidConverter();

  @override
  FirebaseTempUserUid fromJson(dynamic json) {
    return FirebaseTempUserUid(json as String);
  }

  @override
  String toJson(FirebaseTempUserUid guid) {
    return guid == null ? '' : guid._uid;
  }
}
