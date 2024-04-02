class Entity {
  Entity.forInsert()
      : id = -1,
        createdDate = DateTime.now(),
        modifiedDate = DateTime.now();

  Entity.forUpdate({required Entity entity})
      : id = entity.id,
        createdDate = entity.createdDate,
        modifiedDate = DateTime.now();

  Entity(
      {required this.id,
      required this.createdDate,
      required this.modifiedDate});

  int id;
  DateTime createdDate;
  DateTime modifiedDate;
}
