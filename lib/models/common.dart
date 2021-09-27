enum ContentType { Feed, Store, Comment }

class PyDateMixin {
  final DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  void updateTime() {
    updatedAt = DateTime.now();
  }
}
