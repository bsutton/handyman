import 'entity.dart';

class CheckListItemType extends Entity<CheckListItemType> {
  CheckListItemType({
    required super.id,
    required this.name,
    required this.description,
    required this.toPurchase,
    required this.colorCode,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  CheckListItemType.forInsert({
    required this.name,
    required this.description,
    required this.toPurchase,
    required this.colorCode,
  }) : super.forInsert();

  CheckListItemType.forUpdate({
    required super.entity,
    required this.name,
    required this.description,
    required this.toPurchase,
    required this.colorCode,
  }) : super.forUpdate();

  factory CheckListItemType.fromMap(Map<String, dynamic> map) =>
      CheckListItemType(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        toPurchase: map['to_purchase'] as int == 1,
        colorCode: map['color_code'] as String,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  String name;
  String description;
  bool toPurchase;
  String colorCode;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'to_purchase': toPurchase ? 1 : 0,
        'color_code': colorCode,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}