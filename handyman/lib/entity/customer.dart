import 'entity.dart';

enum CustomerType { residential, realestate, tradePartner, community }

class Customer extends Entity {
  String name;
  String primaryFirstName;
  String primarySurname;
  String primaryAddressLine1;
  String primaryAddressLine2;
  String primarySuburb;
  String primaryState;
  String primaryPostcode;
  String primaryMobileNumber;
  String primaryLandLine;
  String primaryOfficeNumber;
  String primaryEmailAddress;
  String secondaryFirstName;
  String secondarySurname;
  String secondaryAddressLine1;
  String secondaryAddressLine2;
  String secondarySuburb;
  String secondaryState;
  String secondaryPostcode;
  String secondaryMobileNumber;
  String secondaryLandLine;
  String secondaryOfficeNumber;
  String secondaryEmailAddress;
  bool disbarred;
  CustomerType customerType;

  Customer({
    required super.id,
    required this.name,
    required this.primaryFirstName,
    required this.primarySurname,
    required this.primaryAddressLine1,
    required this.primaryAddressLine2,
    required this.primarySuburb,
    required this.primaryState,
    required this.primaryPostcode,
    required this.primaryMobileNumber,
    required this.primaryLandLine,
    required this.primaryOfficeNumber,
    required this.primaryEmailAddress,
    required this.secondaryFirstName,
    required this.secondarySurname,
    required this.secondaryAddressLine1,
    required this.secondaryAddressLine2,
    required this.secondarySuburb,
    required this.secondaryState,
    required this.secondaryPostcode,
    required this.secondaryMobileNumber,
    required this.secondaryLandLine,
    required this.secondaryOfficeNumber,
    required this.secondaryEmailAddress,
    required this.disbarred,
    required this.customerType,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Customer.forInsert({
    required this.name,
    required this.primaryFirstName,
    required this.primarySurname,
    required this.primaryAddressLine1,
    required this.primaryAddressLine2,
    required this.primarySuburb,
    required this.primaryState,
    required this.primaryPostcode,
    required this.primaryMobileNumber,
    required this.primaryLandLine,
    required this.primaryOfficeNumber,
    required this.primaryEmailAddress,
    required this.secondaryFirstName,
    required this.secondarySurname,
    required this.secondaryAddressLine1,
    required this.secondaryAddressLine2,
    required this.secondarySuburb,
    required this.secondaryState,
    required this.secondaryPostcode,
    required this.secondaryMobileNumber,
    required this.secondaryLandLine,
    required this.secondaryOfficeNumber,
    required this.secondaryEmailAddress,
    required this.disbarred,
    required this.customerType,
  }) : super.forInsert();

  Customer.forUpdate({
    required super.entity,
    required this.name,
    required this.primaryFirstName,
    required this.primarySurname,
    required this.primaryAddressLine1,
    required this.primaryAddressLine2,
    required this.primarySuburb,
    required this.primaryState,
    required this.primaryPostcode,
    required this.primaryMobileNumber,
    required this.primaryLandLine,
    required this.primaryOfficeNumber,
    required this.primaryEmailAddress,
    required this.secondaryFirstName,
    required this.secondarySurname,
    required this.secondaryAddressLine1,
    required this.secondaryAddressLine2,
    required this.secondarySuburb,
    required this.secondaryState,
    required this.secondaryPostcode,
    required this.secondaryMobileNumber,
    required this.secondaryLandLine,
    required this.secondaryOfficeNumber,
    required this.secondaryEmailAddress,
    required this.disbarred,
    required this.customerType,
  }) : super.forUpdate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'primaryFirstName': primaryFirstName,
      'primarySurname': primarySurname,
      'primaryAddressLine1': primaryAddressLine1,
      'primaryAddressLine2': primaryAddressLine2,
      'primarySuburb': primarySuburb,
      'primaryState': primaryState,
      'primaryPostcode': primaryPostcode,
      'primaryMobileNumber': primaryMobileNumber,
      'primaryLandLine': primaryLandLine,
      'primaryOfficeNumber': primaryOfficeNumber,
      'primaryEmailAddress': primaryEmailAddress,
      'secondaryFirstName': secondaryFirstName,
      'secondarySurname': secondarySurname,
      'secondaryAddressLine1': secondaryAddressLine1,
      'secondaryAddressLine2': secondaryAddressLine2,
      'secondarySuburb': secondarySuburb,
      'secondaryState': secondaryState,
      'secondaryPostcode': secondaryPostcode,
      'secondaryMobileNumber': secondaryMobileNumber,
      'secondaryLandLine': secondaryLandLine,
      'secondaryOfficeNumber': secondaryOfficeNumber,
      'secondaryEmailAddress': secondaryEmailAddress,
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'disbarred': disbarred ? 1 : 0,
      'customerType': customerType.index,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      primaryFirstName: map['primaryFirstName'],
      primarySurname: map['primarySurname'],
      primaryAddressLine1: map['primaryAddressLine1'],
      primaryAddressLine2: map['primaryAddressLine2'],
      primarySuburb: map['primarySuburb'],
      primaryState: map['primaryState'],
      primaryPostcode: map['primaryPostcode'],
      primaryMobileNumber: map['primaryMobileNumber'],
      primaryLandLine: map['primaryLandLine'],
      primaryOfficeNumber: map['primaryOfficeNumber'],
      primaryEmailAddress: map['primaryEmailAddress'],
      secondaryFirstName: map['secondaryFirstName'],
      secondarySurname: map['secondarySurname'],
      secondaryAddressLine1: map['secondaryAddressLine1'],
      secondaryAddressLine2: map['secondaryAddressLine2'],
      secondarySuburb: map['secondarySuburb'],
      secondaryState: map['secondaryState'],
      secondaryPostcode: map['secondaryPostcode'],
      secondaryMobileNumber: map['secondaryMobileNumber'],
      secondaryLandLine: map['secondaryLandLine'],
      secondaryOfficeNumber: map['secondaryOfficeNumber'],
      secondaryEmailAddress: map['secondaryEmailAddress'],
      createdDate: DateTime.parse(map['createdDate']),
      modifiedDate: DateTime.parse(map['modifiedDate']),
      disbarred: map['disbarred'] == 1 ? true : false,
      customerType: CustomerType.values[map['customerType']],
    );
  }
}
