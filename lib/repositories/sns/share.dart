import 'package:campy/models/feed.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialShare { Twitter, Email }
Future snsShare(SocialShare ss, FeedInfo F) async {
  switch (ss) {
    case SocialShare.Twitter:
      launch(Uri(
              scheme: "https",
              path: "twitter.com/intent/tweet",
              query: "text=${F.content}")
          .toString());
      break;
    case SocialShare.Email:
      // await launch(Uri.encodeComponent(
      //     "mailto:?subject=$subject&body=$txt\n\n$urlShare"));
      launch(Uri(
        scheme: 'mailto',
        path: 'smith@example.com',
        query: 'subject=${F.title}&body=${F.content}\n\nby Camping',
      ).toString());
      break;
  }

  // await launch(url);
}
