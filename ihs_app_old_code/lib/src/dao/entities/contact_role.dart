import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'contact.dart';
import 'entity.dart';
import 'role.dart';

part 'contact_role.g.dart';

///
/// A [Contact]s role for the given job.
///
@JsonSerializable()
class ContactRole extends Entity<ContactRole> {
  ContactRole();

  factory ContactRole.fromJson(Map<String, dynamic> json) =>
      _$ContactRoleFromJson(json);

  @ERConverterJob()
  late Job job;

  @ERConverterContact()
  late Contact contact;

  @ERConverterRole()
  late Role role;

  String get name => '${contact.name} ${role.name}';

  @override
  Map<String, dynamic> toJson() => _$ContactRoleToJson(this);
}
