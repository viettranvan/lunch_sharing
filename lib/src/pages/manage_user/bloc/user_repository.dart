import 'package:lunch_sharing/src/common/network/api_reponse.dart';
import 'package:lunch_sharing/src/common/network/dio_client.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class UserRepository {
  final DioClient client;

  UserRepository({required this.client});

  Future<ApiListResponse<ApiUser>> fetchUser() async {
    try {
      final response = await client.getList<ApiUser>(
        '/users',
        fromJson: (json) => ApiUser.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiListResponse<ApiUser>.error(
        message: 'Failed to fetch users: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  Future<ApiResponse<ApiUser>> createUser(String userName) async {
    try {
      final response = await client.post<ApiUser>(
        '/users',
        data: {'name': userName},
        fromJson: (json) => ApiUser.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiUser>.error(
        message: 'Failed to create user: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  Future<ApiResponse<ApiUser>> updateUser(int userId) async {
    try {
      final response = await client.patch<ApiUser>(
        '/users/$userId',
        fromJson: (json) => ApiUser.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiUser>.error(
        message: 'Failed to update user: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  Future<ApiResponse<ApiUser>> updateUserStatus(
      int userId, bool isActive) async {
    try {
      final response = await client.put<ApiUser>(
        '/users/$userId/status',
        data: {'isActive': isActive},
        fromJson: (json) => ApiUser.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiUser>.error(
        message: 'Failed to update user status: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  Future<ApiResponse<ApiUser>> deleteUser(int userId) async {
    try {
      final response = await client.delete<ApiUser>(
        '/users/$userId',
        fromJson: (json) => ApiUser.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<ApiUser>.error(
        message: 'Failed to delete user: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }
}
