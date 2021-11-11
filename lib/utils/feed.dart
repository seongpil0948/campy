import 'package:campy/models/feed.dart';
import 'package:campy/utils/io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<List<PyFile>> imgsOfFeed({required FeedInfo f, int limit = 1}) async {
  List<PyFile> imgs = [];
  for (var i = 0; i < f.files.length; i++) {
    var file = f.files[i];
    if (file.ftype == PyFileType.Video) {
      final tempPath = await getTemporaryDirectory();
      final fileName = await VideoThumbnail.thumbnailFile(
        video: file.url!,
        thumbnailPath: tempPath.path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );
      imgs.add(PyFile.fileName(fileName: fileName!, ftype: PyFileType.Image));
    } else {
      // img
      imgs.add(file);
    }

    if ((limit - 1) <= i) break;
  }
  return imgs;
}
