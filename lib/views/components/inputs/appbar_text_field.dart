import 'package:flutter/material.dart';

class PyAppBarTextField extends StatefulWidget {
  const PyAppBarTextField({Key? key}) : super(key: key);

  @override
  _PyAppBarTextFieldState createState() => _PyAppBarTextFieldState();
}

class _PyAppBarTextFieldState extends State<PyAppBarTextField> {
  TextEditingController searchVal = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
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
