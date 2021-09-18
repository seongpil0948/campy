import 'package:flutter/material.dart';

class AssetUploadCard extends StatelessWidget {
  AssetUploadCard(
      {Key? key, required this.photoPressed, required this.videoPressed})
      : super(key: key);
  final void Function() photoPressed;
  final void Function() videoPressed;

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      splashColor: Theme.of(ctx).colorScheme.secondary,
      onTap: () => showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
                title: Text("이미지 혹은 영상 선택"),
                content: Row(
                  children: [
                    IconButton(
                        onPressed: photoPressed,
                        icon: const Icon(Icons.photo_library)),
                    IconButton(
                      onPressed: videoPressed,
                      icon: Icon(Icons.video_library),
                    ),
                  ],
                ),
              )),
      child: Card(
          // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
                size: 60, color: Theme.of(ctx).colorScheme.secondary),
            Text(
              "최대 10장 까지 업로드 가능합니다",
              style: Theme.of(ctx).textTheme.bodyText1,
            )
          ],
        ),
      )),
    );
  }
}
