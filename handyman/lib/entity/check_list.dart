import 'entity.dart';

enum ListType { global, defaultList, owned }

class CheckList extends Entity<CheckList> {
  CheckList({
    required super.id,
    required this.name,
    required this.description,
    required this.listType,
    required super.createdDate,
    required super.modifiedDate,
  }) : super();

  CheckList.forInsert({
    required this.name,
    required this.description,
    required this.listType,
  }) : super.forInsert();

  CheckList.forUpdate({
    required super.entity,
    required this.name,
    required this.description,
    required this.listType,
  }) : super.forUpdate();

  factory CheckList.fromMap(Map<String, dynamic> map) => CheckList(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        listType: ListType.values[(map['list_type'] as int) - 1],
        createdDate: DateTime.parse(map['createdDate'] as String),
        modifiedDate: DateTime.parse(map['modifiedDate'] as String),
      );

  String name;
  String description;
  ListType listType;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'list_type': listType.index + 1,
        'createdDate': createdDate.toIso8601String(),
        'modifiedDate': modifiedDate.toIso8601String(),
      };
}
