import 'package:campy/models/feed.dart';
import 'package:campy/utils/io.dart';

Iterable<PyFile> imgsOfFeed(FeedInfo f) {
  return f.files.where((f) => f.ftype == PyFileType.Image && f.url != null);
}
