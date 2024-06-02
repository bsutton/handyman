import 'entity.dart';

class Job extends Entity<Job> {
  Job({
    required super.id,
    required super.createdDate,
    required super.modifiedDate,
    required this.customerId,
    required this.startDate,
    required this.summary,
    required this.description,
    required this.address,
  }) : super();

  Job.forInsert({
    required this.customerId,
    required this.summary,
    required this.description,
    required this.startDate,
    required this.address,
  }) : super.forInsert();

  Job.forUpdate({
    required super.entity,
    required this.customerId,
    required this.summary,
    required this.description,
    required this.startDate,
    required this.address,
  }) : super.forUpdate();

  factory Job.fromMap(Map<String, dynamic> map) => Job(
        id: map['id'] as int,
        customerId: map['customer_id'] as int?,
        summary: map['summary'] as String,
        description: map['description'] as String,
        startDate: DateTime.parse(map['startDate'] as String),
        address: map['address'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'summary': summary,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'address': address,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };

  int? customerId;
  DateTime startDate;
  String summary;
  String description;
  String address;
}
