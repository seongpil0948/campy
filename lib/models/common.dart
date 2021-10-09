enum ContentType { Feed, Store, Comment, Reply }

extension ParseToString on ContentType {
  String toCustomString() {
    return this.toString().split('.').last;
  }
}

ContentType contentTypeFromString(String ftype) {
  switch (ftype) {
    case "Feed":
      return ContentType.Feed;
    case "Store":
      return ContentType.Store;
    case "Comment":
      return ContentType.Comment;
    default:
      return ContentType.Comment;
  }
}

class PyDateMixin {
  final DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  void updateTime() {
    updatedAt = DateTime.now();
  }
}
