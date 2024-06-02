import 'entity.dart';

class Site extends Entity<Site> {
  Site({
    required super.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Site.forInsert({
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
  }) : super.forInsert();

  Site.forUpdate({
    required super.entity,
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
  }) : super.forUpdate();

  factory Site.fromMap(Map<String, dynamic> map) => Site(
        id: map['id'] as int,
        addressLine1: map['AddressLine1'] as String,
        addressLine2: map['AddressLine2'] as String,
        suburb: map['Suburb'] as String,
        state: map['State'] as String,
        postcode: map['Postcode'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );
  String addressLine1;
  String addressLine2;
  String suburb;
  String state;
  String postcode;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'AddressLine1': addressLine1,
        'AddressLine2': addressLine2,
        'Suburb': suburb,
        'State': state,
        'Postcode': postcode,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
