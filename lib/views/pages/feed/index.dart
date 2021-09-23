import 'package:campy/repositories/store/init.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);
  final _usersStream = getCollection(Collections.Users)
      .doc('107244136590105907240')
      .collection("feeds")
      .snapshots();

  @override
  Widget build(BuildContext ctx) {
    getCollection(Collections.Users) // TODO: Feeds By Users
        .get()
        .then((val) => print("====== 1 =====> ${val.docs[1].data()}"));
    return Pyffold(
        fButton: FeedFab(),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                  var data = doc.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(" >>> \n $data \n <<<"),
                  );
                }).toList(),
              );
            }));
  }
}

class PyFeedList extends StatelessWidget {
  const PyFeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
