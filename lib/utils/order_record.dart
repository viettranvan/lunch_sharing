import 'package:equatable/equatable.dart';

class OrderRecord extends Equatable {
  final String name;
  final double original;
  final double actualPrice;
  final double percentage;

  const OrderRecord({
    required this.name,
    this.original = 0,
    this.percentage = 0,
    this.actualPrice = 0,
  });

  OrderRecord copyWith({String? name, double? original}) {
    return OrderRecord(
      name: name ?? this.name,
      original: original ?? this.original,
    );
  }

  OrderRecord calculatePercentage(double totalPrice) {
    return OrderRecord(
      name: name,
      original: original,
      actualPrice: actualPrice,
      percentage: (original / totalPrice),
    );
  }

  OrderRecord calculateActualPrice(double delta) {
    return OrderRecord(
      name: name,
      original: original,
      actualPrice: original + delta * percentage,
      percentage: percentage,
    );
  }

  toJson() {
    return {
      "name": name,
      "itemPrice": original,
      "percentage": percentage,
      "actualPrice": actualPrice,
    };
  }

  @override
  List<Object?> get props => [name];
}
