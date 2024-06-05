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

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'color_code': colorCode,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };

  String name;
  String description;
  String colorCode;
}
