import 'entity.dart';

enum CustomerType { residential, realestate, tradePartner, community }

class Customer extends Entity<Customer> {
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

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
        id: map['id'] as int,
        name: map['name'] as String,
        primaryFirstName: map['primaryFirstName'] as String,
        primarySurname: map['primarySurname'] as String,
        primaryAddressLine1: map['primaryAddressLine1'] as String,
        primaryAddressLine2: map['primaryAddressLine2'] as String,
        primarySuburb: map['primarySuburb'] as String,
        primaryState: map['primaryState'] as String,
        primaryPostcode: map['primaryPostcode'] as String,
        primaryMobileNumber: map['primaryMobileNumber'] as String,
        primaryLandLine: map['primaryLandLine'] as String,
        primaryOfficeNumber: map['primaryOfficeNumber'] as String,
        primaryEmailAddress: map['primaryEmailAddress'] as String,
        secondaryFirstName: map['secondaryFirstName'] as String,
        secondarySurname: map['secondarySurname'] as String,
        secondaryAddressLine1: map['secondaryAddressLine1'] as String,
        secondaryAddressLine2: map['secondaryAddressLine2'] as String,
        secondarySuburb: map['secondarySuburb'] as String,
        secondaryState: map['secondaryState'] as String,
        secondaryPostcode: map['secondaryPostcode'] as String,
        secondaryMobileNumber: map['secondaryMobileNumber'] as String,
        secondaryLandLine: map['secondaryLandLine'] as String,
        secondaryOfficeNumber: map['secondaryOfficeNumber'] as String,
        secondaryEmailAddress: map['secondaryEmailAddress'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
        disbarred: map['disbarred'] as int == 1,
        customerType: CustomerType.values[map['customerType'] as int],
      );
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

  @override
  Map<String, dynamic> toMap() => {
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
