import 'entity.dart';

enum SupplierType { residential, realestate, tradePartner, community }

class Supplier extends Entity<Supplier> {
  Supplier({
    required super.id,
    required this.name,
    required this.businessNumber,
    required this.description,
    required this.bsb,
    required this.accountNumber,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Supplier.forInsert({
    required this.name,
    required this.businessNumber,
    required this.description,
    required this.bsb,
    required this.accountNumber,
  }) : super.forInsert();

  Supplier.forUpdate({
    required super.entity,
    required this.name,
    required this.businessNumber,
    required this.description,
    required this.bsb,
    required this.accountNumber,
  }) : super.forUpdate();

  factory Supplier.fromMap(Map<String, dynamic> map) => Supplier(
        id: map['id'] as int,
        name: map['name'] as String,
        businessNumber: map['businessNumber'] as String?,
        description: map['description'] as String?,
        bsb: map['bsb'] as String?,
        accountNumber: map['accountNumber'] as String?,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  String name;
  String? businessNumber;
  String? description;
  String? bsb;
  String? accountNumber;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'businessNumber': businessNumber,
        'description': description,
        'bsb': bsb,
        'accountNumber': accountNumber,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}