import 'package:equatable/equatable.dart';

/// Base API Response class that wraps all API responses
class ApiResponse<T> extends Equatable {
  /// API version
  final String version;

  /// HTTP status code
  final int code;

  /// Indicates if the request was successful
  final bool success;

  /// Response message
  final String message;

  /// Response data - can be object, null, array, etc.
  final T? data;

  const ApiResponse({
    required this.version,
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  /// Factory constructor for successful response
  factory ApiResponse.success({
    String version = "0.0.1",
    int code = 200,
    required String message,
    T? data,
  }) {
    return ApiResponse<T>(
      version: version,
      code: code,
      success: true,
      message: message,
      data: data,
    );
  }

  /// Factory constructor for error response
  factory ApiResponse.error({
    String version = "0.0.1",
    int code = 400,
    required String message,
    T? data,
  }) {
    return ApiResponse<T>(
      version: version,
      code: code,
      success: false,
      message: message,
      data: data,
    );
  }

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      version: json['version'] ?? "0.0.1",
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  /// Convert ApiResponse to JSON
  Map<String, dynamic> toJson([Object? Function(T)? toJsonT]) {
    return {
      'version': version,
      'code': code,
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
    };
  }

  /// Create a copy with modified properties
  ApiResponse<T> copyWith({
    String? version,
    int? code,
    bool? success,
    String? message,
    T? data,
  }) {
    return ApiResponse<T>(
      version: version ?? this.version,
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// Check if response indicates success
  bool get isSuccess => success && code >= 200 && code < 300;

  /// Check if response indicates error
  bool get isError => !success || code < 200 || code >= 300;

  @override
  List<Object?> get props => [version, code, success, message, data];

  @override
  String toString() {
    return 'ApiResponse(version: $version, code: $code, success: $success, message: $message, data: $data)';
  }
}

/// Specialized API Response for list data
class ApiListResponse<T> extends ApiResponse<List<T>> {
  const ApiListResponse({
    required super.version,
    required super.code,
    required super.success,
    required super.message,
    super.data,
  });

  /// Factory constructor for successful list response
  factory ApiListResponse.success({
    String version = "0.0.1",
    int code = 200,
    required String message,
    List<T>? data,
  }) {
    return ApiListResponse<T>(
      version: version,
      code: code,
      success: true,
      message: message,
      data: data ?? [],
    );
  }

  /// Factory constructor for error list response
  factory ApiListResponse.error({
    String version = "0.0.1",
    int code = 400,
    required String message,
    List<T>? data,
  }) {
    return ApiListResponse<T>(
      version: version,
      code: code,
      success: false,
      message: message,
      data: data,
    );
  }

  /// Create ApiListResponse from JSON
  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    List<T>? dataList;
    if (json['data'] != null && fromJsonT != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List)
            .map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList();
      }
    }

    return ApiListResponse<T>(
      version: json['version'] ?? "0.0.1",
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList,
    );
  }

  /// Get the count of items in the data list
  int get count => data?.length ?? 0;

  /// Check if the data list is empty
  bool get isEmpty => data?.isEmpty ?? true;

  /// Check if the data list is not empty
  bool get isNotEmpty => data?.isNotEmpty ?? false;
}

/// Common HTTP status codes for easier usage
class HttpStatusCode {
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
}
