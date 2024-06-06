import 'entity.dart';

class TaskStatus extends Entity<TaskStatus> {
  TaskStatus({
    required super.id,
    required this.name,
    required this.description,
    required this.colorCode,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  TaskStatus.forInsert({
    required this.name,
    required this.description,
    required this.colorCode,
  }) : super.forInsert();

  TaskStatus.forUpdate({
    required super.entity,
    required this.name,
    required this.description,
    required this.colorCode,
  }) : super.forUpdate();

  factory TaskStatus.fromMap(Map<String, dynamic> map) => TaskStatus(
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
}
