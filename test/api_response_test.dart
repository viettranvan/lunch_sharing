import 'package:flutter_test/flutter_test.dart';
import 'package:lunch_sharing/src/common/network/api_reponse.dart';

void main() {
  group('ApiResponse Tests', () {
    test('should create successful response', () {
      final response = ApiResponse<String>.success(
        message: 'Test successful',
        data: 'test data',
      );

      expect(response.success, true);
      expect(response.code, 200);
      expect(response.version, '0.0.1');
      expect(response.message, 'Test successful');
      expect(response.data, 'test data');
      expect(response.isSuccess, true);
      expect(response.isError, false);
    });

    test('should create error response', () {
      final response = ApiResponse<String>.error(
        code: 400,
        message: 'Test error',
      );

      expect(response.success, false);
      expect(response.code, 400);
      expect(response.message, 'Test error');
      expect(response.isSuccess, false);
      expect(response.isError, true);
    });

    test('should create response from JSON', () {
      final json = {
        'version': '1.0.0',
        'code': 200,
        'success': true,
        'message': 'Success',
        'data': {'key': 'value'},
      };

      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(response.version, '1.0.0');
      expect(response.code, 200);
      expect(response.success, true);
      expect(response.message, 'Success');
      expect(response.data, {'key': 'value'});
    });

    test('should convert response to JSON', () {
      final response = ApiResponse<Map<String, dynamic>>.success(
        version: '1.0.0',
        code: 201,
        message: 'Created',
        data: {'id': 123},
      );

      final json = response.toJson();

      expect(json['version'], '1.0.0');
      expect(json['code'], 201);
      expect(json['success'], true);
      expect(json['message'], 'Created');
      expect(json['data'], {'id': 123});
    });

    test('should copy with modifications', () {
      final original = ApiResponse<String>.success(
        message: 'Original',
        data: 'original data',
      );

      final modified = original.copyWith(
        message: 'Modified',
        code: 201,
      );

      expect(modified.message, 'Modified');
      expect(modified.code, 201);
      expect(modified.data, 'original data'); // unchanged
      expect(modified.success, true); // unchanged
    });
  });

  group('ApiListResponse Tests', () {
    test('should create successful list response', () {
      final response = ApiListResponse<String>.success(
        message: 'Users retrieved',
        data: ['user1', 'user2', 'user3'],
      );

      expect(response.success, true);
      expect(response.count, 3);
      expect(response.isNotEmpty, true);
      expect(response.isEmpty, false);
    });

    test('should create empty list response', () {
      final response = ApiListResponse<String>.success(
        message: 'No users found',
        data: [],
      );

      expect(response.count, 0);
      expect(response.isEmpty, true);
      expect(response.isNotEmpty, false);
    });

    test('should create list response from JSON', () {
      final json = {
        'version': '0.0.1',
        'code': 200,
        'success': true,
        'message': 'Users retrieved',
        'data': [
          {'id': 1, 'name': 'John'},
          {'id': 2, 'name': 'Jane'},
        ],
      };

      final response = ApiListResponse<Map<String, dynamic>>.fromJson(
        json,
        (item) => item,
      );

      expect(response.count, 2);
      expect(response.data?[0]['name'], 'John');
      expect(response.data?[1]['name'], 'Jane');
    });
  });

  group('HttpStatusCode Tests', () {
    test('should have correct status codes', () {
      expect(HttpStatusCode.ok, 200);
      expect(HttpStatusCode.created, 201);
      expect(HttpStatusCode.badRequest, 400);
      expect(HttpStatusCode.unauthorized, 401);
      expect(HttpStatusCode.notFound, 404);
      expect(HttpStatusCode.internalServerError, 500);
    });
  });
}
