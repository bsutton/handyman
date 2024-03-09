import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../../util/format.dart';
import '../../util/log.dart';
import '../../widgets/audio_media.dart';
import '../types/byte_buffer_converter.dart';
import '../types/er.dart';
import 'entity.dart';
import 'user.dart';

part 'audio_file.g.dart';

@JsonSerializable()
class ChecklistItem extends Entity<ChecklistItem> {
  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);

  @EROrganisationConverter()
  late ER<Organisation> owner;

  late DateTime created = DateTime.now();

  late String name;

  ER<ChecklistItemType> checkListItemType;

  DateTime getCreated() => created;

  @override
  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);
}
