import 'entity.dart';

class System extends Entity<System> {
  System({
    required super.id,
    required this.fromEmail,
    required this.bsb,
    required this.accountNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
    required this.webUrl,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  System.forInsert({
    required this.fromEmail,
    required this.bsb,
    required this.accountNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
    required this.webUrl,
  }) : super.forInsert();

  System.forUpdate({
    required super.entity,
    required this.fromEmail,
    required this.bsb,
    required this.accountNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.mobileNumber,
    required this.landLine,
    required this.officeNumber,
    required this.emailAddress,
    required this.webUrl,
  }) : super.forUpdate();

  factory System.fromMap(Map<String, dynamic> map) => System(
        id: map['id'] as int,
        fromEmail: map['fromEmail'] as String?,
        bsb: map['BSB'] as String?,
        accountNo: map['accountNo'] as String?,
        addressLine1: map['addressLine1'] as String?,
        addressLine2: map['addressLine2'] as String?,
        suburb: map['suburb'] as String?,
        state: map['state'] as String?,
        postcode: map['postcode'] as String?,
        mobileNumber: map['mobileNumber'] as String?,
        landLine: map['landLine'] as String?,
        officeNumber: map['officeNumber'] as String?,
        emailAddress: map['emailAddress'] as String?,
        webUrl: map['webUrl'] as String?,
        createdDate: DateTime.tryParse((map['createdDate']) as String? ?? '') ??
            DateTime.now(),
        modifiedDate:
            DateTime.tryParse((map['modifiedDate']) as String? ?? '') ??
                DateTime.now(),
      );

  String? fromEmail;
  String? bsb;
  String? accountNo;
  String? addressLine1;
  String? addressLine2;
  String? suburb;
  String? state;
  String? postcode;
  String? mobileNumber;
  String? landLine;
  String? officeNumber;
  String? emailAddress;
  String? webUrl;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'fromEmail': fromEmail,
        'BSB': bsb,
        'accountNo': accountNo,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'suburb': suburb,
        'state': state,
        'postcode': postcode,
        'mobileNumber': mobileNumber,
        'landLine': landLine,
        'officeNumber': officeNumber,
        'emailAddress': emailAddress,
        'webUrl': webUrl,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
