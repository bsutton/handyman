class Entity {

  Entity(
      {required this.id,
      required this.createdDate,
      required this.modifiedDate});
  Entity.forInsert()
      : id = -1,
        createdDate = DateTime.now(),
        modifiedDate = DateTime.now();

  Entity.forUpdate({required Entity entity})
      : id = entity.id,
        createdDate = entity.createdDate,
        modifiedDate = DateTime.now();

  int id;
  DateTime createdDate;
  DateTime modifiedDate;
}
