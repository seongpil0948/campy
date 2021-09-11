import 'package:flutter/material.dart';

class AssetUpload extends StatelessWidget {
  const AssetUpload({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 60,
                color: Colors.grey,
              ),
              Text(
                "최대 10장 까지 업로드 가능합니다",
                style: Theme.of(ctx).textTheme.bodyText1,
              )
            ],
          ),
        ));
  }
}
