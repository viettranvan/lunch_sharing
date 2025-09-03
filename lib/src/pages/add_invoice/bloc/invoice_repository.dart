import 'package:lunch_sharing/src/common/network/index.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class InvoiceRepository {
  final DioClient client;

  InvoiceRepository({required this.client});

  Future<List<ApiUser>> fetchUsers() async {
    try {
      final response = await client.get('/users');
      return (response.data as List)
          .map((user) => ApiUser.fromJson(user))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addInvoice({
    required String storeName,
    required double paidAmount,
    required DateTime date,
    required List<ApiOrderer> orderers,
  }) async {
    try {
      final response = await client.post('/invoices', data: {
        'storeName': storeName,
        'paidAmount': paidAmount,
        'date': date.toIso8601String(),
        'orderers': orderers.map((o) => o.toJson()).toList(),
      });
      return response.success;
    } catch (e) {
      return false;
    }
  }
}