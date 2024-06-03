import 'entity.dart';

enum CustomerType { residential, realestate, tradePartner, community }

class Customer extends Entity<Customer> {
  Customer({
    required super.id,
    required this.name,
    required this.disbarred,
    required this.customerType,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  Customer.forInsert({
    required this.name,
    required this.disbarred,
    required this.customerType,
  }) : super.forInsert();

  Customer.forUpdate({
    required super.entity,
    required this.name,
    required this.disbarred,
    required this.customerType,
  }) : super.forUpdate();

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
        id: map['id'] as int,
        name: map['name'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
        disbarred: map['disbarred'] as int == 1,
        customerType: CustomerType.values[map['customerType'] as int],
      );
  String name;
  bool disbarred;
  CustomerType customerType;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
        'disbarred': disbarred ? 1 : 0,
        'customerType': customerType.index,
      };
}
