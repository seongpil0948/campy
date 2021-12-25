import 'package:campy/components/inputs/text_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class PyAppBarTextField extends StatelessWidget {
  const PyAppBarTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final searchVal = ctx.read<FeedSearchVal>();
    return TextField(
      textAlign: TextAlign.center,
      style: Theme.of(ctx).textTheme.caption,
      controller: searchVal,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "     캠핑라이프와 상품을 검색 해보세요",
          prefixIcon: Icon(
            Icons.search_outlined,
            size: 20,
            color: Colors.blue.shade900,
          )),
    );
  }
}
