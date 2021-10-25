import 'package:cloud_firestore/cloud_firestore.dart';

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

DateTime timeStamp2DateTime(Timestamp time) {
  return DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
}
