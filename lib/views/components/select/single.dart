import 'package:flutter/material.dart';

class PySingleSelect extends StatefulWidget {
  List<String> items;
  String hint;
  String? model;
  PySingleSelect(
      {Key? key, required this.hint, required this.items, required this.model})
      : super(key: key);

  @override
  State<PySingleSelect> createState() => _PySingleSelectState();
}

/// This is the private State class that goes with PySingleSelect.
class _PySingleSelectState extends State<PySingleSelect> {
  @override
  Widget build(BuildContext ctx) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Theme.of(ctx).cardColor,
        height: 50,
        child: DropdownButton<String>(
          hint: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(widget.hint),
          ),
          underline: Container(),
          menuMaxHeight: 300,
          dropdownColor: Theme.of(ctx).cardColor,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          // style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newVal) {
            setState(() {
              widget.model = newVal;
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
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
