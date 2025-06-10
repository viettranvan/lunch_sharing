import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getListUser() async {
    List<String> users = [];

    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('userOrder')
          .doc('userList')
          .get();

      if (docSnapshot.exists) {
        users = List<String>.from(docSnapshot.get('users') as List);
        log("Danh sách users: $users");
      } else {
        log("Không tìm thấy tài liệu!");
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách: $e");
    }
    return users;
  }

  Future<bool> addUser({required String userName}) async {
    try {
      DocumentReference docRef = _firestore
          .collection('userOrder')
          .doc('userList');
      await docRef.update({
        'users': FieldValue.arrayUnion([userName]),
      });
      log("Thêm mới user thành công!");
      return true;
    } catch (e) {
      log("Lỗi khi thêm user: $e");
      return false;
    }
  }
}
