import 'entity.dart';

enum SupplierType { residential, realestate, tradePartner, community }

class Supplier extends Entity<Supplier> {
  Supplier({
    required super.id,
    required this.name,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Supplier.forInsert({
    required this.name,
  }) : super.forInsert();

  Supplier.forUpdate({
    required super.entity,
    required this.name,
  }) : super.forUpdate();

  factory Supplier.fromMap(Map<String, dynamic> map) => Supplier(
        id: map['id'] as int,
        name: map['name'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );
  String name;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
