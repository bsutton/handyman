import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import 'entity.dart';

part 'tutorial.g.dart';

@JsonSerializable()
class Tutorial extends Entity<Tutorial> {
  Tutorial(
      {this.summary,
      this.serialVersionUID,
      this.htmlBody,
      this.subject,
      this.urlToVideoMedia,
      GUID? guid,
      int? id,
      this.body,
      this.type,
      this.creationDate})
      : super.known(id, guid);

  factory Tutorial.fromJson(Map<String, dynamic> json) =>
      _$TutorialFromJson(json);
  String? summary;
  int? serialVersionUID;
  String? htmlBody;
  String? subject;
  String? urlToVideoMedia;
  //@ERTextFragmentConverter()
  String? body;
  String? type;

  @LocalDateConverter()
  LocalDate? creationDate;

  Tutorial copyWith(
          {String? summary,
          int? serialVersionUID,
          String? htmlBody,
          String? subject,
          String? urlToVideoMedia,
          String? guid,
          int? id,
          String? body,
          String? type}) =>
      Tutorial(
        summary: summary ?? this.summary,
        serialVersionUID: serialVersionUID ?? this.serialVersionUID,
        htmlBody: htmlBody ?? this.htmlBody,
        subject: subject ?? this.subject,
        urlToVideoMedia: urlToVideoMedia ?? this.urlToVideoMedia,
        body: body ?? this.body,
        type: type ?? this.type,
      );

  @override
  Future<bool> search(String filter) async => Future.value(
      (summary != null && summary!.toLowerCase().contains(filter)) ||
          (subject != null && subject!.toLowerCase().contains(filter)));

  @override
  Map<String, dynamic> toJson() => _$TutorialToJson(this);
}

// ignore: avoid_classes_with_only_static_members
class TutorialValidator {
  static String? subject(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must not be empty';
    }
    return null;
  }

  static String? summary(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must not be empty';
    }
    return null;
  }
}
