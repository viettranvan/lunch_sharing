import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const List<String> kBaseUser = ['Ryuk', 'Leo', 'Richard', 'Eric', 'Levi'];

String formatFirebaseTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  final DateFormat formatter = DateFormat("EEEE, 'Ngày' dd-MM-yyyy", 'vi_VN');

  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}
