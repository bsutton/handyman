import 'entity.dart';

class Job extends Entity<Job> {
  Job({
    required super.id,
    required this.customerId,
    required this.summary,
    required this.description,
    required this.startDate,
    required this.siteId,
    required this.contactId,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Job.forInsert({
    required this.customerId,
    required this.summary,
    required this.description,
    required this.startDate,
    required this.siteId,
    required this.contactId,
  }) : super.forInsert();

  Job.forUpdate({
    required super.entity,
    required this.customerId,
    required this.summary,
    required this.description,
    required this.startDate,
    required this.siteId,
    required this.contactId,
  }) : super.forUpdate();

  factory Job.fromMap(Map<String, dynamic> map) => Job(
        id: map['id'] as int,
        customerId: map['customer_id'] as int?,
        summary: map['summary'] as String,
        description: map['description'] as String,
        startDate: DateTime.parse(map['startDate'] as String),
        siteId: map['site_id'] as int?,
        contactId: map['contact_id'] as int?,
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
        'site_id': siteId,
        'contact_id': contactId,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };

  int? customerId;
  DateTime startDate;
  String summary;
  String description;
  int? siteId;
  int? contactId;
}
