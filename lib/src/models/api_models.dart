import 'package:equatable/equatable.dart';

/// User model for API response
class ApiUser extends Equatable {
  final int id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ApiUser({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, isActive, createdAt, updatedAt];

  @override
  String toString() => 'ApiUser(id: $id, name: $name, isActive: $isActive)';
}

/// Orderer model for API response
class ApiOrderer extends Equatable {
  final int id;
  final double actualPrice;
  final bool isPaid;
  final double itemPrice;
  final double percentage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ApiUser user;

  const ApiOrderer({
    required this.id,
    required this.actualPrice,
    required this.isPaid,
    required this.itemPrice,
    required this.percentage,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory ApiOrderer.empty() {
    return ApiOrderer(
      id: 0,
      actualPrice: 0.0,
      isPaid: false,
      itemPrice: 0.0,
      percentage: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: ApiUser(
        id: 0,
        name: '',
        isActive: true,
        createdAt: DateTime.now(),
      ),
    );
  }
  factory ApiOrderer.fromJson(Map<String, dynamic> json) {
    return ApiOrderer(
      id: json['id'] as int,
      actualPrice: (json['actualPrice'] as num).toDouble(),
      isPaid: json['isPaid'] as bool,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actualPrice': actualPrice,
      'isPaid': isPaid,
      'itemPrice': itemPrice,
      'percentage': percentage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        actualPrice,
        isPaid,
        itemPrice,
        percentage,
        createdAt,
        updatedAt,
        user,
      ];

  @override
  String toString() =>
      'ApiOrderer(id: $id, user: ${user.name}, isPaid: $isPaid)';
}

/// Invoice model for API response
class ApiInvoice extends Equatable {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String storeName;
  final double paidAmount;
  final List<ApiOrderer> orderers;

  const ApiInvoice({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.storeName,
    required this.paidAmount,
    required this.orderers,
  });

  factory ApiInvoice.empty() {
    return ApiInvoice(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: 0,
      storeName: '',
      paidAmount: 0.0,
      orderers: [],
    );
  }

  factory ApiInvoice.fromJson(Map<String, dynamic> json) {
    return ApiInvoice(
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      id: json['id'] as int,
      storeName: json['store_name'] as String,
      paidAmount: (json['paid_amount'] as num).toDouble(),
      orderers: (json['orderers'] as List<dynamic>)
          .map(
              (orderer) => ApiOrderer.fromJson(orderer as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
      'store_name': storeName,
      'paid_amount': paidAmount,
      'orderers': orderers.map((orderer) => orderer.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        createdAt,
        updatedAt,
        id,
        storeName,
        paidAmount,
        orderers,
      ];

  @override
  String toString() =>
      'ApiInvoice(id: $id, storeName: $storeName, orderers: ${orderers.length})';
}

/// Invoice list response model for API
class ApiInvoiceListResponse extends Equatable {
  final String version;
  final int code;
  final bool success;
  final String message;
  final int total;
  final List<ApiInvoice> data;

  const ApiInvoiceListResponse({
    required this.version,
    required this.code,
    required this.success,
    required this.message,
    required this.total,
    required this.data,
  });

  factory ApiInvoiceListResponse.fromJson(Map<String, dynamic> json) {
    return ApiInvoiceListResponse(
      version: json['version'] as String,
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      total: json['total'] as int,
      data: (json['data'] as List<dynamic>)
          .map(
              (invoice) => ApiInvoice.fromJson(invoice as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'code': code,
      'success': success,
      'message': message,
      'total': total,
      'data': data.map((invoice) => invoice.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [version, code, success, message, total, data];

  @override
  String toString() =>
      'ApiInvoiceListResponse(total: $total, data: ${data.length} invoices)';
}
