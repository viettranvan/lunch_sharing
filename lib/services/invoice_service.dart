import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunch_sharing/utils/index.dart';

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm để thêm một hóa đơn mới
  Future<bool> addInvoice({
    required String storeName,
    required double paidAmount,
    required DateTime date,
    required List<OrderRecord> orderers,
  }) async {
    try {
      // Dữ liệu mẫu
      Map<String, dynamic> newInvoiceData = {
        "storeName": storeName,
        "paidAmount": paidAmount,
        "createdAt": Timestamp.fromDate(date),
        "orderers": orderers.map((e) => e.toJson()).toList(),
      };

      await _firestore.collection('invoices').add(newInvoiceData);
      log('Thêm hóa đơn thành công!');
      return true;
    } catch (e) {
      log('Lỗi khi thêm hóa đơn: $e');
      return false;
    }
  }

  // Hàm để đọc tất cả hóa đơn (dưới dạng stream để tự động cập nhật UI)
  Stream<QuerySnapshot> getInvoicesStream() {
    return _firestore
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Hàm để đọc các hóa đơn trong một ngày cụ thể
  Future<List<QueryDocumentSnapshot>> getInvoicesByDate(DateTime date) async {
    // Xác định thời gian bắt đầu và kết thúc của ngày
    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _firestore
        .collection('invoices')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs;
  }
}
