import 'entity.dart';

class TimeEntry extends Entity<TimeEntry> {
  TimeEntry({
    required super.id,
    required this.taskId,
    required this.startTime,
    required super.createdDate,
    required super.modifiedDate,
    this.endTime,
    this.note,
    this.billed = false,
    this.invoiceLineId,
  }) : super();

  factory TimeEntry.fromMap(Map<String, dynamic> map) => TimeEntry(
        id: map['id'] as int,
        taskId: map['task_id'] as int,
        startTime: DateTime.parse(map['start_time'] as String),
        endTime: map['end_time'] != null
            ? DateTime.parse(map['end_time'] as String)
            : null,
        note: map['notes'] as String?,
        billed: map['billed'] == 1,
        invoiceLineId: map['invoice_line_id'] as int?,
        createdDate: DateTime.parse(map['created_date'] as String),
        modifiedDate: DateTime.parse(map['modified_date'] as String),
      );

  TimeEntry.forInsert(
      {required this.taskId,
      required this.startTime,
      this.note,
      this.billed = false})
      : super.forInsert();

  TimeEntry.forUpdate(
      {required super.entity,
      required this.taskId,
      required this.startTime,
      this.endTime,
      this.note,
      this.billed = false})
      : super.forUpdate();

  int taskId;
  DateTime startTime;
  DateTime? endTime;
  String? note;
  bool billed;

  /// If the time_enty has been billed then this is the invoice line
  /// that it has been billed to.
  int? invoiceLineId;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  TimeEntry copyWith({
    int? id,
    int? taskId,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
    bool? billed,
    int? invoiceLineId,
    DateTime? createdDate,
    DateTime? modifiedDate,
  }) =>
      TimeEntry(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        note: note ?? this.note,
        billed: billed ?? this.billed,
        invoiceLineId: invoiceLineId ?? this.invoiceLineId,
        createdDate: createdDate ?? this.createdDate,
        modifiedDate: modifiedDate ?? this.modifiedDate,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'task_id': taskId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'created_date': createdDate.toIso8601String(),
        'modified_date': modifiedDate.toIso8601String(),
        'notes': note,
        'billed': billed ? 1 : 0,
        'invoice_line_id': invoiceLineId,
      };
}
