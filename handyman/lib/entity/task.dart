import 'entity.dart';

class Task extends Entity<Task> {
  Task(
      {required super.id,
      required this.jobId,
      required this.name,
      required this.description,
      required this.completed,
      required super.createdDate,
      required super.modifiedDate})
      : super();

  Task.forInsert({
    required this.jobId,
    required this.name,
    required this.description,
    required this.completed,
  }) : super.forInsert();

  Task.forUpdate({
    required super.entity,
    required this.jobId,
    required this.name,
    required this.description,
    required this.completed,
  }) : super.forUpdate();

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as int,
        jobId: map['jobId'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        completed: map['completed'] == 1,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  int jobId;
  String name;
  String description;
  bool completed;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'jobId': jobId,
        'name': name,
        'description': description,
        'completed': completed ? 1 : 0,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
