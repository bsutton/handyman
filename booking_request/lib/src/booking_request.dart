class BookingRequest {
  final String id;
  final DateTime createdAt;
  final String businessName;
  final String firstName;
  final String surname;
  final String email;
  final String phone;
  final String description;
  final String street;
  final String suburb;
  final String day1;
  final String day2;
  final String day3;
  final bool imported;

  BookingRequest({
    required this.id,
    required this.createdAt,
    required this.businessName,
    required this.firstName,
    required this.surname,
    required this.email,
    required this.phone,
    required this.description,
    required this.street,
    required this.suburb,
    required this.day1,
    required this.day2,
    required this.day3,
    required this.imported,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    final legacyData =
        json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : <String, dynamic>{};

    String readString(String key) {
      final direct = json[key];
      if (direct != null) {
        return direct.toString();
      }
      final nested = legacyData[key];
      return nested == null ? '' : nested.toString();
    }

    return BookingRequest(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      businessName: readString('businessName'),
      firstName: readString('firstName'),
      surname: readString('surname'),
      email: readString('email'),
      phone: readString('phone'),
      description: readString('description'),
      street: readString('street'),
      suburb: readString('suburb'),
      day1: readString('day1'),
      day2: readString('day2'),
      day3: readString('day3'),
      imported: json['imported'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'businessName': businessName,
    'firstName': firstName,
    'surname': surname,
    'email': email,
    'phone': phone,
    'description': description,
    'street': street,
    'suburb': suburb,
    'day1': day1,
    'day2': day2,
    'day3': day3,
    'imported': imported,
  };
}
