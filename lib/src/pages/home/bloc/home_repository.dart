import 'package:lunch_sharing/src/common/network/index.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class HomeRepository {
  final DioClient client;

  HomeRepository({required this.client});

  /// Fetch all invoices from the API
  Future<ApiListResponse<ApiInvoice>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (startDate != null) {
        queryParameters['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParameters['end_date'] = endDate.toIso8601String();
      }
      if (page != null) {
        queryParameters['page'] = page;
      }
      if (limit != null) {
        queryParameters['limit'] = limit;
      }

      final response = await client.getList<ApiInvoice>(
        '/invoices',
        queryParameters: queryParameters,
        fromJson: (json) => ApiInvoice.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiListResponse<ApiInvoice>.error(
        message: 'Failed to fetch invoices: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Fetch a specific invoice by ID
  Future<ApiResponse<ApiInvoice>> getInvoiceById(int invoiceId) async {
    try {
      final response = await client.get<ApiInvoice>(
        '/invoices/$invoiceId',
        fromJson: (data) => ApiInvoice.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiInvoice>.error(
        message: 'Failed to fetch invoice: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Create a new invoice
  Future<ApiResponse<ApiInvoice>> createInvoice({
    required String storeName,
    required double paidAmount,
    required List<Map<String, dynamic>> orderers,
  }) async {
    try {
      final response = await client.post<ApiInvoice>(
        '/invoices',
        data: {
          'store_name': storeName,
          'paid_amount': paidAmount,
          'orderers': orderers,
        },
        fromJson: (data) => ApiInvoice.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiInvoice>.error(
        message: 'Failed to create invoice: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Update an existing invoice
  Future<ApiResponse<ApiInvoice>> updateInvoice({
    required int invoiceId,
    String? storeName,
    double? paidAmount,
    List<Map<String, dynamic>>? orderers,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (storeName != null) data['store_name'] = storeName;
      if (paidAmount != null) data['paid_amount'] = paidAmount;
      if (orderers != null) data['orderers'] = orderers;

      final response = await client.put<ApiInvoice>(
        '/invoices/$invoiceId',
        data: data,
        fromJson: (data) => ApiInvoice.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiInvoice>.error(
        message: 'Failed to update invoice: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Delete an invoice
  Future<ApiResponse<void>> deleteInvoice(int invoiceId) async {
    try {
      final response = await client.delete<void>('/invoices/$invoiceId');
      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Failed to delete invoice: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Mark an orderer as paid
  Future<ApiResponse<ApiInvoice>> markOrdererAsPaid({
    required int invoiceId,
    required int ordererId,
  }) async {
    try {
      final response = await client.patch<ApiInvoice>(
        '/invoices/$invoiceId/orderers/$ordererId/mark-paid',
        fromJson: (data) => ApiInvoice.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiInvoice>.error(
        message: 'Failed to mark orderer as paid: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Mark all invoices of a specific user as paid
  Future<ApiResponse<Map<String, dynamic>>> markAllUserInvoicesAsPaid({
    required String userName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final data = <String, dynamic>{
        'user_name': userName,
      };

      if (startDate != null) {
        data['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        data['end_date'] = endDate.toIso8601String();
      }

      final response = await client.post<Map<String, dynamic>>(
        '/invoices/mark-all-user-paid',
        data: data,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(
        message: 'Failed to mark all user invoices as paid: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }
}
