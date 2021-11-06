import 'package:campy/components/assets/carousel.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/select/single.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/upload_file.dart';
import 'package:campy/utils/parsers.dart';
import 'package:campy/views/router/path.dart';
import 'package:campy/utils/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

import 'package:uuid/uuid.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  var _titleController = TextEditingController();
  late RichTextController _contentController;
  String? kind;
  String? price;
  String? around;
  // ignore: unused_local_variable
  List<String> hashTags = [];
  List<PyFile> files = [];
  bool once = false;

  void setHashTags(List<String> tags) {
    hashTags = tags;
  }

  @override
  void didChangeDependencies() {
    var ctx = context;
    if (once == false) {
      _contentController = RichTextController(
          patternMap: {
            // Returns every Hashtag with red color

            RegExp("#[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                Theme.of(ctx).primaryTextTheme.bodyText2!,
            // Returns every Mention with blue color and bold style.
            RegExp(r"@[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                Theme.of(ctx).primaryTextTheme.bodyText1!,
            //* Returns every word after '!' with yellow color and italic style.
            RegExp(r"![|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                TextStyle(color: Theme.of(ctx).colorScheme.error),
            // add as many expressions as you need!
          },
          // stringMap: {
          //   "성필": TextStyle(color: Colors.purple),
          //   "sp": TextStyle(color: Colors.purple),
          // },
          //! Assertion: Only one of the two matching options can be given at a time!
          onMatch: (matches) {
            setHashTags(matches);
            return matches.join(" ");
          });
      once = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
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
                      items: ["__오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]),
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
              child: PyContentEditor(controller: _contentController),
            ),
            Wrap(
              children: [
                for (var tag in hashTags)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          hashTags.remove(tag);
                        });
                      },
                      child: Text(tag, style: tagTextSty(tag, ctx))),
              ],
            ),
            FutureBuilder<PyUser>(
                future: ctx.watch<PyAuth>().currUser,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  var writer = snapshot.data!;
                  return Row(
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
                                    f, writer.userId);
                                if (info != null &&
                                    info.containsKey('url') &&
                                    info.containsKey('pymime')) {
                                  var file = PyFile.fromCdn(
                                      url: info['url'],
                                      fileType: info['pymime']);
                                  paths.add(file);
                                }
                              }

                              final doc = getCollection(c: Collections.Users)
                                  .doc(writer.userId);
                              var finfo = FeedInfo(
                                writer: writer,
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
                                  .collection(FeedCollection)
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
                  );
                })
          ],
        ),
      ),
    ));
  }
}

class PyContentEditor extends StatelessWidget {
  final TextEditingController controller;
  PyContentEditor({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Theme.of(ctx).cardColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: "사진에 대한 내용을 입력해주세요"),
      maxLines: 10,
    );
  }
}
