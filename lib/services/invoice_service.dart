import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunch_sharing/models/index.dart';

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Invoices>> fetchInvoices({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> invoiceSnap;
      if (startDate == null && endDate == null) {
        invoiceSnap = await _firestore
            .collection('invoices')
            .orderBy('createdAt', descending: true)
            .get();
      } else {
        invoiceSnap = await _firestore
            .collection('invoices')
            .where('createdAt', isGreaterThanOrEqualTo: startDate)
            .where('createdAt', isLessThanOrEqualTo: DateTime(endDate!.year, endDate.month,endDate.day, 23, 59, 59))
            .orderBy('createdAt', descending: true)
            .get();
      }
      return Future.wait(
        invoiceSnap.docs.map((invDoc) async {
          return Invoices.fromMap(invDoc.id, invDoc.data());
        }).toList(),
      );
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  // Hàm để thêm một hóa đơn mới
  Future<bool> addInvoice({
    required String storeName,
    required double paidAmount,
    required DateTime date,
    required List<Orderers> orderers,
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

  Future<bool> markPaid({
    required String invoiceId,
    required String ordererId,
  }) async {
    try {
      final invoiceRef = FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId);

      final snapshot = await invoiceRef.get();
      if (!snapshot.exists) {
        log("Invoice không tồn tại");
        return false;
      }
      final orderers = snapshot.data()?['orderers'] ?? [];
      for (var orderer in orderers) {
        if (orderer['id'] == ordererId) {
          orderer['isPaid'] = true;
          break;
        }
      }
      await invoiceRef.update({'orderers': orderers});
      log(
        'Đánh dấu đã thanh toán thành công cho orderer $ordererId trong hóa đơn $invoiceId',
      );

      return true;
    } catch (e) {
      log('Lỗi khi đánh dấu đã thanh toán: $e');
      return false;
    }
  }
}
