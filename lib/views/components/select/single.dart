import 'package:flutter/material.dart';

class PySingleSelect extends StatelessWidget {
  final List<String> items;
  final String hint;
  final void Function(String?)? onChange;
  PySingleSelect(
      {Key? key,
      required this.hint,
      required this.items,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Theme.of(ctx).cardColor,
        child: DropdownButton<String>(
          hint: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(hint),
          ),
          underline: Container(),
          menuMaxHeight: mq.size.height / 2,
          dropdownColor: Theme.of(ctx).cardColor,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          // style: const TextStyle(color: Colors.deepPurple),
          onChanged: onChange,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
