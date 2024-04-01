import 'entity.dart';

class Customer extends Entity {
  String name;
  String siteLocation;
  String contactDetails;

  Customer.forInsert(
      {required this.name,
      required this.siteLocation,
      required this.contactDetails})
      : super.forInsert();
  Customer(
      {required super.id,
      required this.name,
      required this.siteLocation,
      required this.contactDetails});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'siteLocation': siteLocation,
      'contactDetails': contactDetails,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      siteLocation: map['siteLocation'],
      contactDetails: map['contactDetails'],
    );
  }
}
