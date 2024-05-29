import 'package:json_annotation/json_annotation.dart';

import 'entity.dart';

part 'attachment.g.dart';

enum AttachmentStorage { url, file }

/// Takes a URL or a byte buffer and stores it into a temporary file.
@JsonSerializable()
class Attachment extends Entity<Attachment> {
  Attachment();
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  /// Creates an empty Attachment object
  Attachment.empty() : storageType = AttachmentStorage.file;

  Attachment.fromURL(
    this.url,
  ) : storageType = AttachmentStorage.url;

  late String name;
  String? description;
  late AttachmentStorage storageType;
  String? url;

  @override
  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
