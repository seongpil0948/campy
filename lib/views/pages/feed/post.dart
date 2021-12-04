import 'package:campy/components/assets/carousel.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/select/single.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/sns/feed.dart';
import 'package:campy/utils/parsers.dart';
import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  String? title;
  String? content;
  String? kind;
  String? price;
  String? around;
  // ignore: unused_local_variable
  List<String> hashTags = [];
  List<PyFile> files = [];

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return Pyffold(
        body: SingleChildScrollView(
      child: MultiProvider(
          providers: [
            Provider.value(value: title),
            Provider.value(value: content),
            Provider.value(value: hashTags),
            Provider.value(value: files),
          ],
          child: FeedPostW(
            mq: mq,
            kind: kind,
            price: price,
            around: around,
          )),
    ));
  }
}

class FeedPostW extends StatelessWidget {
  const FeedPostW({
    Key? key,
    required this.mq,
    required this.kind,
    required this.price,
    required this.around,
  }) : super(key: key);

  final MediaQueryData mq;
  final String? kind;
  final String? price;
  final String? around;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Container(
          height: mq.size.height / 2.1,
          child: PyAssetCarousel(),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PySingleSelect(
                  source: kind,
                  hint: "캠핑 종류",
                  items: ["__오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]),
              PySingleSelect(source: price, hint: "가격 정보", items: [
                "5만원 이하",
                "10만원 이하",
                "15만원 이하 ",
                "20만원 이하",
                "20만원 이상"
              ]),
              PySingleSelect(
                  source: around,
                  hint: "주변 정보",
                  items: ["마트 없음", "관광코스 없음", "계곡 없음", "산 없음"]),
            ],
          ),
        ),
        PyFeedEditors(),
        HashList(),
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
                        onPressed: () {
                          postFeed(
                              ctx: ctx,
                              writer: writer,
                              files: Provider.of(ctx, listen: false).files,
                              title: Provider.of(ctx, listen: false).title,
                              content: Provider.of(ctx, listen: false).content,
                              price: int.parse(price ?? '-1'),
                              hashTags: ctx.watch<List<String>>());
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
    );
  }
}

class PyFeedEditors extends StatefulWidget {
  const PyFeedEditors({Key? key}) : super(key: key);

  @override
  _PyEditorsState createState() => _PyEditorsState();
}

class _PyEditorsState extends State<PyFeedEditors> {
  var _titleController = TextEditingController();
  late RichTextController _contentController;
  bool once = false;

  void setHashTags(BuildContext ctx, List<String> tags) {
    var t = ctx.read<List<String>>();
    t = tags;
  }

  @override
  void didChangeDependencies() {
    var ctx = context;
    if (once == false) {
      _contentController = RichTextController(
          patternMap: {
            RegExp("#[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                Theme.of(ctx).primaryTextTheme.bodyText2!,
            RegExp(r"@[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                Theme.of(ctx).primaryTextTheme.bodyText1!,
            RegExp(r"![|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
                TextStyle(color: Theme.of(ctx).colorScheme.error),
          },
          onMatch: (matches) {
            setHashTags(ctx, matches);
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: OneLineEditor(titleController: _titleController),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: PyContentEditor(controller: _contentController),
        ),
      ],
    );
  }
}

class OneLineEditor extends StatelessWidget {
  const OneLineEditor({
    Key? key,
    required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext ctx) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _titleController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Theme.of(ctx).cardColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: "제목을 입력해주세요"),
    );
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

class HashList extends StatelessWidget {
  const HashList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final tags = ctx.watch<List<String>>(); // hashTags
    return Wrap(
      children: [
        for (var tag in tags)
          TextButton(
              onPressed: () {
                tags.remove(tag);
              },
              child: Text(tag, style: tagTextSty(tag, ctx))),
      ],
    );
  }
}
