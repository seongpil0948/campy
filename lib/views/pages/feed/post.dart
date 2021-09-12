import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return Pyffold(
        fButton: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: mq.size.height / 3,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: PyAssetCarousel(),
              ),
              Row(
                children: [Container(height: 200, child: PySingleSelect())],
              )
            ],
          ),
        ));
  }
}

class PySingleSelect extends StatefulWidget {
  const PySingleSelect({Key? key}) : super(key: key);

  @override
  State<PySingleSelect> createState() => _PySingleSelectState();
}

/// This is the private State class that goes with PySingleSelect.
class _PySingleSelectState extends State<PySingleSelect> {
  String dropdownValue = '오토 캠핑';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      alignment: AlignmentDirectional.topStart,
      hint: Text("캠핑종류"),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>["오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
