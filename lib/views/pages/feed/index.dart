import 'package:campy/models/feed.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/components/structs/feed/list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// FIXME: 전부다 갈아없어여함
/// 유저스트림과 퓨쳐빌더를 할 필요가 없음
/// 프로바이더로 전체화면 말고 리스트 보여주는 부분만 받아오면 리빌드 하고
/// 리스트 위젯(피드를 인자로받는) 부분만 구현하면  인자 바뀌지 않느이상 안바뀔듯
/// 프로그래스바 뜰때 기존 피드는 없어지지 않는 상태로
/// 로드했을때 한번 불러오고, 스크롤 위로 할때만 새로 보여주는걸로 참고는 밑에 링크
/// https://medium.com/@jun.chenying/flutter-tutorial-part-5-listview-pagination-scroll-up-to-load-more-ed132f6a06be
class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);
  List<FeedInfo> feeds = [];
// if (userSnapShot.hasError) {
//   return Text('Something went wrong of Users');
// } else if (userSnapShot.connectionState == ConnectionState.waiting) {
//     return Text("Loading of Users");
  @override
  Widget build(BuildContext ctx) {
    return Pyffold(
        fButton: FeedFab(),
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              print("Scroll Info: $scrollInfo");
              return false; // not bubble
            },
            child: Provider.value(
              value: feeds,
              child: FeedList(feeds: feeds),
            )));
  }
}
