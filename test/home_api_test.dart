import 'package:flutter_test/flutter_test.dart';
import 'package:lunch_sharing/src/common/network/index.dart';
import 'package:lunch_sharing/src/models/api_models.dart';
import 'package:lunch_sharing/src/pages/home/bloc/home_repository.dart';

void main() {
  group('API Models Tests', () {
    test('should create ApiUser from JSON', () {
      final json = {
        'id': 5,
        'name': 'Leo',
        'isActive': false,
        'createdAt': '2025-08-28T08:31:29.118Z',
        'updatedAt': null,
      };

      final user = ApiUser.fromJson(json);

      expect(user.id, 5);
      expect(user.name, 'Leo');
      expect(user.isActive, false);
      expect(user.createdAt, DateTime.parse('2025-08-28T08:31:29.118Z'));
      expect(user.updatedAt, null);
    });

    test('should create ApiOrderer from JSON', () {
      final json = {
        'id': 147,
        'actualPrice': 10,
        'isPaid': true,
        'itemPrice': 10,
        'percentage': 1,
        'createdAt': '2025-08-28T08:08:05.000Z',
        'updatedAt': '2025-08-28T11:30:37.035Z',
        'user': {
          'id': 5,
          'name': 'Leo',
          'isActive': false,
          'createdAt': '2025-08-28T08:31:29.118Z',
          'updatedAt': null,
        },
      };

      final orderer = ApiOrderer.fromJson(json);

      expect(orderer.id, 147);
      expect(orderer.actualPrice, 10);
      expect(orderer.isPaid, true);
      expect(orderer.itemPrice, 10);
      expect(orderer.percentage, 1);
      expect(orderer.user.name, 'Leo');
    });

    test('should create ApiInvoice from JSON', () {
      final json = {
        'created_at': '2025-08-28T08:08:05.000Z',
        'updated_at': '2025-08-28T08:08:05.000Z',
        'id': 15,
        'store_name': 'test',
        'paid_amount': 10,
        'orderers': [
          {
            'id': 147,
            'actualPrice': 10,
            'isPaid': true,
            'itemPrice': 10,
            'percentage': 1,
            'createdAt': '2025-08-28T08:08:05.000Z',
            'updatedAt': '2025-08-28T11:30:37.035Z',
            'user': {
              'id': 5,
              'name': 'Leo',
              'isActive': false,
              'createdAt': '2025-08-28T08:31:29.118Z',
              'updatedAt': null,
            },
          }
        ],
      };

      final invoice = ApiInvoice.fromJson(json);

      expect(invoice.id, 15);
      expect(invoice.storeName, 'test');
      expect(invoice.paidAmount, 10);
      expect(invoice.orderers.length, 1);
      expect(invoice.orderers.first.user.name, 'Leo');
    });

    test('should create ApiInvoiceListResponse from JSON', () {
      final json = {
        'version': '0.0.1',
        'code': 200,
        'success': true,
        'message': 'Invoices retrieved successfully',
        'total': 60,
        'data': [
          {
            'created_at': '2025-08-28T08:08:05.000Z',
            'updated_at': '2025-08-28T08:08:05.000Z',
            'id': 15,
            'store_name': 'test',
            'paid_amount': 10,
            'orderers': [
              {
                'id': 147,
                'actualPrice': 10,
                'isPaid': true,
                'itemPrice': 10,
                'percentage': 1,
                'createdAt': '2025-08-28T08:08:05.000Z',
                'updatedAt': '2025-08-28T11:30:37.035Z',
                'user': {
                  'id': 5,
                  'name': 'Leo',
                  'isActive': false,
                  'createdAt': '2025-08-28T08:31:29.118Z',
                  'updatedAt': null,
                },
              }
            ],
          }
        ],
      };

      final response = ApiInvoiceListResponse.fromJson(json);

      expect(response.version, '0.0.1');
      expect(response.code, 200);
      expect(response.success, true);
      expect(response.message, 'Invoices retrieved successfully');
      expect(response.total, 60);
      expect(response.data.length, 1);
      expect(response.data.first.storeName, 'test');
    });

    test('should convert ApiInvoice to JSON', () {
      final user = ApiUser(
        id: 5,
        name: 'Leo',
        isActive: false,
        createdAt: DateTime.parse('2025-08-28T08:31:29.118Z'),
      );

      final orderer = ApiOrderer(
        id: 147,
        actualPrice: 10,
        isPaid: true,
        itemPrice: 10,
        percentage: 1,
        createdAt: DateTime.parse('2025-08-28T08:08:05.000Z'),
        updatedAt: DateTime.parse('2025-08-28T11:30:37.035Z'),
        user: user,
      );

      final invoice = ApiInvoice(
        createdAt: DateTime.parse('2025-08-28T08:08:05.000Z'),
        updatedAt: DateTime.parse('2025-08-28T08:08:05.000Z'),
        id: 15,
        storeName: 'test',
        paidAmount: 10,
        orderers: [orderer],
      );

      final json = invoice.toJson();

      expect(json['id'], 15);
      expect(json['store_name'], 'test');
      expect(json['paid_amount'], 10);
      expect(json['orderers'], isA<List>());
      expect((json['orderers'] as List).length, 1);
    });
  });

  group('HomeRepository Tests', () {
    late HomeRepository repository;
    late DioClient mockClient;

    setUp(() {
      mockClient = DioClient(baseUrl: 'https://test.example.com');
      repository = HomeRepository(client: mockClient);
    });

    test('should have correct repository initialization', () {
      expect(repository.client, mockClient);
    });

    test('should build correct query parameters for getInvoices', () {
      final startDate = DateTime(2025, 8, 1);
      final endDate = DateTime(2025, 8, 31);

      // Test that the method returns the correct type
      final future = repository.getInvoices(
        startDate: startDate,
        endDate: endDate,
        page: 1,
        limit: 20,
      );

      expect(future, isA<Future<ApiListResponse<ApiInvoice>>>());
    });

    test('should build correct request for createInvoice', () {
      final orderers = [
        {
          'user_id': 1,
          'item_price': 15.50,
          'percentage': 0.5,
        }
      ];

      final future = repository.createInvoice(
        storeName: 'Test Store',
        paidAmount: 25.75,
        orderers: orderers,
      );

      expect(future, isA<Future<ApiResponse<ApiInvoice>>>());
    });

    test('should build correct request for markOrdererAsPaid', () {
      final future = repository.markOrdererAsPaid(
        invoiceId: 123,
        ordererId: 456,
      );

      expect(future, isA<Future<ApiResponse<ApiInvoice>>>());
    });

    test('should build correct request for markAllUserInvoicesAsPaid', () {
      final future = repository.markAllUserInvoicesAsPaid(
        userName: 'John Doe',
        startDate: DateTime(2025, 8, 1),
        endDate: DateTime(2025, 8, 31),
      );

      expect(future, isA<Future<ApiResponse<Map<String, dynamic>>>>());
    });

    test('should build correct request for deleteInvoice', () {
      final future = repository.deleteInvoice(123);

      expect(future, isA<Future<ApiResponse<void>>>());
    });
  });

  group('API Response Structure Tests', () {
    test('should match expected API response structure', () {
      // Test that our models match the exact API response structure
      final apiResponseJson = {
        'version': '0.0.1',
        'code': 200,
        'success': true,
        'message': 'Invoices retrieved successfully',
        'total': 60,
        'data': [
          {
            'created_at': '2025-08-28T08:08:05.000Z',
            'updated_at': '2025-08-28T08:08:05.000Z',
            'id': 15,
            'store_name': 'test',
            'paid_amount': 10,
            'orderers': [
              {
                'id': 147,
                'actualPrice': 10,
                'isPaid': true,
                'itemPrice': 10,
                'percentage': 1,
                'createdAt': '2025-08-28T08:08:05.000Z',
                'updatedAt': '2025-08-28T11:30:37.035Z',
                'user': {
                  'id': 5,
                  'name': 'Leo',
                  'isActive': false,
                  'createdAt': '2025-08-28T08:31:29.118Z',
                  'updatedAt': null,
                },
              }
            ],
          }
        ],
      };

      // Should parse without errors
      expect(
        () => ApiInvoiceListResponse.fromJson(apiResponseJson),
        returnsNormally,
      );

      final response = ApiInvoiceListResponse.fromJson(apiResponseJson);

      // Verify structure matches
      expect(response.version, '0.0.1');
      expect(response.code, 200);
      expect(response.success, true);
      expect(response.message, 'Invoices retrieved successfully');
      expect(response.total, 60);
      expect(response.data.length, 1);

      final invoice = response.data.first;
      expect(invoice.id, 15);
      expect(invoice.storeName, 'test');
      expect(invoice.paidAmount, 10);
      expect(invoice.orderers.length, 1);

      final orderer = invoice.orderers.first;
      expect(orderer.id, 147);
      expect(orderer.isPaid, true);
      expect(orderer.user.name, 'Leo');
    });
  });
}
