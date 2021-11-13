import 'package:flutter/material.dart';

class PySingleSelect extends StatefulWidget {
  final List<String> items;
  final String hint;
  String? source;
  PySingleSelect(
      {Key? key, required this.hint, required this.items, this.source})
      : super(key: key);

  @override
  _PySingleSelectState createState() => _PySingleSelectState();
}

class _PySingleSelectState extends State<PySingleSelect> {
  String? dropdownValue;
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final sty = Theme.of(ctx)
        .textTheme
        .overline!
        .copyWith(color: Theme.of(ctx).hintColor);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Theme.of(ctx).cardColor,
        width: mq.size.width / 4,
        child: DropdownButton<String>(
          alignment: AlignmentDirectional.centerEnd,
          value: dropdownValue,
          hint: Text(widget.hint, style: sty),
          underline: Container(),
          menuMaxHeight: mq.size.height / 2,
          dropdownColor: Theme.of(ctx).cardColor,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          // style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newVal) {
            setState(() {
              widget.source = newVal;
              dropdownValue = newVal;
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value, style: sty)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
