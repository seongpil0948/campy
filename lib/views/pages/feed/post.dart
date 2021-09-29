import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/models/auth.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/repositories/store/upload_file.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/components/select/single.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/router/path.dart';
import 'package:campy/utils/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();
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
                      onChange: (newVal) {
                        setState(() {
                          kind = newVal;
                        });
                      },
                      hint: "캠핑 종류",
                      items: ["오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]),
                  PySingleSelect(
                      onChange: (newVal) {
                        setState(() {
                          price = newVal?.split("만원")[0];
                        });
                      },
                      hint: "가격 정보",
                      items: [
                        "5만원 이하",
                        "10만원 이하",
                        "15만원 이하 ",
                        "20만원 이하",
                        "20만원 이상"
                      ]),
                  PySingleSelect(
                      onChange: (newVal) {
                        setState(() {
                          around = newVal;
                        });
                      },
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
            Wrap(
              children: [
                for (var tag in hashTags)
                  TextButton(
                    onPressed: () {},
                    child: Text("#$tag"),
                  ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: ctx,
                          builder: (ctx) {
                            return Dialog(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                onSubmitted: (String val) {
                                  print("Hash Values $val");
                                  setState(() {
                                    for (var t in val.split(" ")) {
                                      if (!hashTags.contains(t)) {
                                        hashTags.add(t);
                                      }
                                    }
                                  });
                                },
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
                      onPressed: () async {
                        const uuid = Uuid();
                        final newFeedId = uuid.v4();
                        List<PyFile> paths = [];
                        for (var f in files) {
                          var info = await uploadFilePathsToFirebase(
                              f,
                              Provider.of<PyAuth>(ctx, listen: false)
                                  .currUser!
                                  .userId);
                          if (info != null &&
                              info.containsKey('url') &&
                              info.containsKey('pymime')) {
                            var file = PyFile.fromCdn(
                                url: info['url'], fileType: info['pymime']);
                            paths.add(file);
                          }
                        }

                        final doc =
                            getCollection(Collections.Users).doc(writer.userId);
                        var finfo = FeedInfo(
                          writer: writer,
                          isfavorite: false,
                          feedId: newFeedId,
                          files: paths,
                          title: _titleController.text,
                          content: _contentController.text,
                          placeAround: around ?? '',
                          placePrice: int.parse(price ?? '-1'),
                          campKind: kind ?? '',
                          hashTags: hashTags,
                        );
                        // If you don't add a field to the document it will be orphaned.
                        doc.set(writer.toJson(), SetOptions(merge: true));
                        doc
                            .collection("feeds")
                            .doc(newFeedId)
                            .set(finfo.toJson())
                            .then((value) {
                          print(">>> Feed Added <<<");
                          ctx.read<PyState>().currPageAction =
                              PageAction.feed();
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
