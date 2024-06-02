import 'entity.dart';

class Contact extends Entity<Contact> {
  Contact({
    required super.id,
    required this.customerId,
    required this.firstName,
    required this.surname,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Contact.forInsert({
    required this.customerId,
    required this.firstName,
    required this.surname,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
  }) : super.forInsert();

  Contact.forUpdate({
    required super.entity,
    required this.customerId,
    required this.firstName,
    required this.surname,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
  }) : super.forUpdate();

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
        id: map['id'] as int,
        customerId: map['customer_id'] as int,
        firstName: map['firstName'] as String,
        surname: map['surname'] as String,
        mobileNumber: map['mobileNumber'] as String,
        landLine: map['landLine'] as String,
        officeNumber: map['officeNumber'] as String,
        emailAddress: map['emailAddress'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );
  int customerId;
  String firstName;
  String surname;
  String mobileNumber;
  String landLine;
  String officeNumber;
  String emailAddress;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'firstName': firstName,
        'surname': surname,
        'mobileNumber': mobileNumber,
        'landLine': landLine,
        'officeNumber': officeNumber,
        'emailAddress': emailAddress,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
