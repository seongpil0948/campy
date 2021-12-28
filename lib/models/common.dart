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

class Time {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  Time();

  Time.fromJson(Map<String, dynamic> j)
      : createdAt = j['createdAt'],
        updatedAt = j['updatedAt'];

  Map<String, dynamic> toJson() =>
      {'createdAt': createdAt, 'updatedAt': updatedAt};
}
