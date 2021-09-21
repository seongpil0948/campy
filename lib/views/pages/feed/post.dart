import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/models/auth.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/repositories/store/upload_file.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/components/select/single.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();
  var _hashTagsController = TextEditingController();
  String? kind;
  String? price;
  String? around;
  // ignore: unused_local_variable
  List<String> hashTags = [];
  List<PyFile> files = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _hashTagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final auth = ctx.watch<PyAuth>();
    PyUser writer = auth.currUser!;
    final mq = MediaQuery.of(ctx);

    return Pyffold(
        body: SingleChildScrollView(
      child: Provider.value(
        value: files,
        child: Column(
          children: [
            Container(
              height: mq.size.height / 3.1,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: PyAssetCarousel(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PySingleSelect(
                      model: kind,
                      hint: "캠핑 종류",
                      items: ["오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]),
                  PySingleSelect(model: price, hint: "가격 정보", items: [
                    "5만원 이하",
                    "10만원 이하",
                    "15만원 이하 ",
                    "20만원 이하",
                    "20만원 이상"
                  ]),
                  PySingleSelect(
                      model: around,
                      hint: "주변 정보",
                      items: ["마트 없음", "관광코스 없음", "계곡 없음", "산 없음"]),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _titleController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(ctx).cardColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "제목을 입력해주세요"),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _contentController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(ctx).cardColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "사진에 대한 내용을 입력해주세요"),
                maxLines: 10,
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: ctx,
                          builder: (ctx) {
                            return Dialog(
                              child: TextField(
                                controller: _hashTagsController,
                                keyboardType: TextInputType.text,
                              ),
                            );
                          });
                    },
                    child: Text("#태그추가"))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                    child: ElevatedButton(
                      onPressed: () {
                        List<PyFile> paths = [];
                        for (var f in files) {
                          uploadFilePathsToFirebase(
                                  f,
                                  Provider.of<PyAuth>(ctx, listen: false)
                                      .currUser!
                                      .userId)
                              .then((info) {
                            if (info != null &&
                                info.containsKey('url') &&
                                info.containsKey('pymime')) {
                              var file = PyFile.fromCdn(
                                  url: info['url'], ftype: info['pymime']);
                              paths.add(file);
                            }
                          });
                        }

                        final c = getCollection(Collections.Feeds);
                        var finfo = FeedInfo(
                          writer: writer,
                          isfavorite: false,
                          feedId: null,
                          files: paths,
                          title: _titleController.text,
                          content: _contentController.text,
                          hashTags: _hashTagsController.text,
                        );
                        final fjson = finfo.toJson();
                        print("Try to Insert to Firestore Feed Info $fjson");
                        c.doc().set(fjson).then((value) {
                          print("======== Feed Added =========");
                        }).catchError((error) {
                          print(
                              "!!!Failed to add Feed!!!: ${error.toString()}");
                        });
                      },
                      child: Center(
                        child: Text("올리기"),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
