class BookingRequest {
  final String id;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  final bool imported;

  BookingRequest({
    required this.id,
    required this.createdAt,
    required this.data,
    required this.imported,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    data: Map<String, dynamic>.from(json['data'] as Map),
    imported: json['imported'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'data': data,
    'imported': imported,
  };
}
