import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// used to transport the Firebase User UID generated
/// at the completion of the stage 1 firebase sign in 
/// (post mobile no. verification).
class FirebaseTempUserUid extends Equatable {
  const FirebaseTempUserUid(String guid) : _uid = guid;

  factory FirebaseTempUserUid.fromJson(dynamic json) =>
      FirebaseTempUserUid(json as String);
  final String _uid;

  bool get isEmpty => _uid.isEmpty;

  bool get isValid => _uid.isNotEmpty;
  @override
  String toString() => _uid;

  @override
  List<Object> get props => [_uid];

  String toJson() => _uid;
}

class FirebaseTempUserUidConverter
    implements JsonConverter<FirebaseTempUserUid, dynamic> {
  const FirebaseTempUserUidConverter();

  @override
  FirebaseTempUserUid fromJson(dynamic json) =>
      FirebaseTempUserUid(json as String);

  @override
  String toJson(FirebaseTempUserUid guid) => guid._uid;
}
