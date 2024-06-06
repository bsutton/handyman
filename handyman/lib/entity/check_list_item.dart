import 'entity.dart';

class CheckListItem extends Entity<CheckListItem> {
  CheckListItem({
    required super.id,
    required this.checkListId,
    required this.description,
    required this.itemTypeId,
    required this.cost,
    required this.effortInHours,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  CheckListItem.forInsert({
    required this.checkListId,
    required this.description,
    required this.itemTypeId,
    required this.cost,
    required this.effortInHours,
  }) : super.forInsert();

  CheckListItem.forUpdate({
    required super.entity,
    required this.checkListId,
    required this.description,
    required this.itemTypeId,
    required this.cost,
    required this.effortInHours,
  }) : super.forUpdate();

  factory CheckListItem.fromMap(Map<String, dynamic> map) => CheckListItem(
        id: map['id'] as int,
        checkListId: map['check_list_id'] as int,
        description: map['description'] as String,
        itemTypeId: map['item_type_id'] as int,
        cost: map['cost'] as int,
        effortInHours: map['effort_in_hours'] as int,
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  int checkListId;
  String description;
  int itemTypeId;
  int cost; // in cents
  int effortInHours;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'check_list_id': checkListId,
        'description': description,
        'item_type_id': itemTypeId,
        'cost': cost,
        'effort_in_hours': effortInHours,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
