import 'dart:ui';

import 'entity.dart';

class JobStatus extends Entity<JobStatus> {
  JobStatus({
    required super.id,
    required this.name,
    required this.description,
    required this.colorCode,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  JobStatus.forInsert({
    required this.name,
    required this.description,
    required this.colorCode,
  }) : super.forInsert();

  JobStatus.forUpdate({
    required super.entity,
    required this.name,
    required this.description,
    required this.colorCode,
  }) : super.forUpdate();

  factory JobStatus.fromMap(Map<String, dynamic> map) => JobStatus(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        colorCode: map['color_code'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  String name;
  String description;
  String colorCode;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'color_code': colorCode,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };

  Color getColour() {
    // Remove the leading `#` if present
    var hex = colorCode.replaceAll('#', '');

    // If the hex code is 6 characters long, add the opacity value (ff)
    if (hex.length == 6) {
      hex = 'ff$hex';
    }

    // Parse the hex string to an integer and create a Color object
    return Color(int.parse(hex, radix: 16));
  }
}
