import 'package:equatable/equatable.dart';

class Orderers extends Equatable {
  final String id;
  final double actualPrice;
  final bool isPaid;
  final double itemPrice;
  final String name;
  final double percentage;
  const Orderers({
    this.id = '',
    this.actualPrice = 0,
    this.isPaid = false,
    this.itemPrice = 0,
    this.name = '',
    this.percentage = 0,
  });

  Orderers copyWith({String? name, double? itemPrice}) {
    return Orderers(
      id: id,
      actualPrice: actualPrice,
      isPaid: isPaid,
      percentage: percentage,
      name: name ?? this.name,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Orderers calculatePercentage(double totalPrice) {
    return Orderers(
      id: id,
      name: name,
      itemPrice: itemPrice,
      isPaid: isPaid,
      actualPrice: actualPrice,
      percentage: (itemPrice / totalPrice),
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
