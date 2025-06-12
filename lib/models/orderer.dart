import 'package:equatable/equatable.dart';

class Orderers extends Equatable {
  final String id;
  final double actualPrice;
  final bool isPaid;
  final double itemPrice;
  final String name;
  final double percentage;
  const Orderers({
    required this.id,
    this.actualPrice = 0,
    this.isPaid = false,
    this.itemPrice = 0,
    this.name = '',
    this.percentage = 0,
  });

  Orderers copyWith({
    String? id,
    double? actualPrice,
    bool? isPaid,
    double? itemPrice,
    String? name,
    double? percentage,
  }) {
    return Orderers(
      id: id ?? this.id,
      actualPrice: actualPrice ?? this.actualPrice,
      isPaid: isPaid ?? this.isPaid,
      itemPrice: itemPrice ?? this.itemPrice,
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
    );
  }

  Orderers calculateActualPrice(double delta) {
    return Orderers(
      id: id,
      name: name,
      isPaid: isPaid,
      itemPrice: itemPrice,
      actualPrice: itemPrice + delta * percentage,
      percentage: percentage,
    );
  }

  factory Orderers.fromMap(Map<String, dynamic> map) {
    return Orderers(
      id: map['id'] ?? '',
      actualPrice: map['actualPrice']?.toDouble() ?? 0.0,
      isPaid: map['isPaid'] ?? false,
      itemPrice: map['itemPrice']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      percentage: map['percentage']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "itemPrice": itemPrice,
      "isPaid": isPaid,
      "percentage": percentage,
      "actualPrice": actualPrice,
    };
  }

  @override
  List<Object?> get props => [actualPrice, isPaid, itemPrice, name, percentage];
}
