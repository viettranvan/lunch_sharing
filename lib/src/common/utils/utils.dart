import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


String formatFirebaseTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedDate = DateFormat(
    "EEEE, 'Ngày' dd-MM-yyyy",
    'vi_VN',
  ).format(dateTime);

  return formattedDate;
}

// convert Datetime to "EEEE, 'Ngày' dd-MM-yyyy",
String formatDateTime(DateTime dateTime) {
  String formattedDate = DateFormat(
    "EEEE, 'Ngày' dd-MM-yyyy",
    'vi_VN',
  ).format(dateTime);

  return formattedDate;
}