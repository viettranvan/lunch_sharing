import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:lunch_sharing/src/common/network/api_reponse.dart';

class DioClient {
  late final Dio _dio;
  static const String _logTag = 'DioClient';

  DioClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? const String.fromEnvironment('BASE_URL'),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _setupInterceptors();
  }

  /// Setup interceptors for logging and error handling
  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          dev.log(
            'REQUEST[${options.method}] => PATH: ${options.path} '
            'DATA: ${options.data} HEADERS: ${options.headers}',
            name: _logTag,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          dev.log(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} '
            'DATA: ${response.data}',
            name: _logTag,
          );
          handler.next(response);
        },
        onError: (error, handler) {
          dev.log(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path} '
            'MESSAGE: ${error.message} DATA: ${error.response?.data}',
            name: _logTag,
          );
          handler.next(error);
        },
      ),
    );
  }

  /// Add authorization token to headers
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token from headers
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Generic GET request that returns ApiResponse
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Generic POST request that returns ApiResponse
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Generic PUT request that returns ApiResponse
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Generic PATCH request that returns ApiResponse
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Generic DELETE request that returns ApiResponse
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// GET request that returns ApiListResponse for arrays
  Future<ApiListResponse<T>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleListResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleListError<T>(e);
    } catch (e) {
      return ApiListResponse<T>.error(
        message: 'Unexpected error: $e',
        code: HttpStatusCode.internalServerError,
      );
    }
  }

  /// Handle successful response and convert to ApiResponse
  ApiResponse<T> _handleResponse<T>(
      Response response, T Function(dynamic)? fromJson) {
    final data = response.data;

    // If response data is already in ApiResponse format
    if (data is Map<String, dynamic> &&
        data.containsKey('success') &&
        data.containsKey('message') &&
        data.containsKey('code')) {
      return ApiResponse<T>.fromJson(data, fromJson);
    }

    // If response data is raw, wrap it in ApiResponse format
    return ApiResponse<T>.success(
      code: response.statusCode ?? HttpStatusCode.ok,
      message: _getSuccessMessage(response.statusCode),
      data: fromJson != null ? fromJson(data) : data as T?,
    );
  }

  /// Handle successful list response and convert to ApiListResponse
  ApiListResponse<T> _handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = response.data;

    // If response data is already in ApiResponse format
    if (data is Map<String, dynamic> &&
        data.containsKey('success') &&
        data.containsKey('message') &&
        data.containsKey('code')) {
      return ApiListResponse<T>.fromJson(data, fromJson);
    }

    // If response data is raw array, wrap it in ApiListResponse format
    List<T> items = [];
    if (data is List) {
      items = data
          .whereType<Map<String, dynamic>>()
          .map((item) => fromJson(item))
          .toList();
    }

    return ApiListResponse<T>.success(
      code: response.statusCode ?? HttpStatusCode.ok,
      message: _getSuccessMessage(response.statusCode),
      data: items,
    );
  }

  /// Handle DioException and convert to ApiResponse error
  ApiResponse<T> _handleError<T>(DioException error) {
    final response = error.response;
    final statusCode =
        response?.statusCode ?? HttpStatusCode.internalServerError;

    String message;
    dynamic errorData;

    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      message = data['message'] ?? _getErrorMessage(error.type, statusCode);
      errorData = data['data'];
    } else {
      message = _getErrorMessage(error.type, statusCode);
      errorData = response?.data;
    }

    return ApiResponse<T>.error(
      code: statusCode,
      message: message,
      data: errorData,
    );
  }

  /// Handle DioException and convert to ApiListResponse error
  ApiListResponse<T> _handleListError<T>(DioException error) {
    final response = error.response;
    final statusCode =
        response?.statusCode ?? HttpStatusCode.internalServerError;

    String message;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      message = data['message'] ?? _getErrorMessage(error.type, statusCode);
    } else {
      message = _getErrorMessage(error.type, statusCode);
    }

    return ApiListResponse<T>.error(
      code: statusCode,
      message: message,
    );
  }

  /// Get success message based on status code
  String _getSuccessMessage(int? statusCode) {
    switch (statusCode) {
      case HttpStatusCode.ok:
        return 'Request successful';
      case HttpStatusCode.created:
        return 'Resource created successfully';
      case HttpStatusCode.accepted:
        return 'Request accepted';
      case HttpStatusCode.noContent:
        return 'Request successful, no content';
      default:
        return 'Request completed successfully';
    }
  }

  /// Get error message based on DioExceptionType and status code
  String _getErrorMessage(DioExceptionType type, int statusCode) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Request took too long to send.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Server took too long to respond.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
      case DioExceptionType.badResponse:
        return _getStatusCodeMessage(statusCode);
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Get specific error message based on HTTP status code
  String _getStatusCodeMessage(int statusCode) {
    switch (statusCode) {
      case HttpStatusCode.badRequest:
        return 'Bad request. Please check your input.';
      case HttpStatusCode.unauthorized:
        return 'Unauthorized. Please login again.';
      case HttpStatusCode.forbidden:
        return 'Access forbidden. You don\'t have permission.';
      case HttpStatusCode.notFound:
        return 'Resource not found.';
      case HttpStatusCode.methodNotAllowed:
        return 'Method not allowed.';
      case HttpStatusCode.conflict:
        return 'Conflict. Resource already exists.';
      case HttpStatusCode.unprocessableEntity:
        return 'Validation error. Please check your input.';
      case HttpStatusCode.internalServerError:
        return 'Internal server error. Please try again later.';
      case HttpStatusCode.notImplemented:
        return 'Feature not implemented.';
      case HttpStatusCode.badGateway:
        return 'Bad gateway. Please try again later.';
      case HttpStatusCode.serviceUnavailable:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred (Code: $statusCode).';
    }
  }

  /// Get the raw Dio instance for advanced usage
  Dio get instance => _dio;

  /// Close the client and clean up resources
  void close() {
    _dio.close();
  }
}
