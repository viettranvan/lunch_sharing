// import 'package:equatable/equatable.dart';

// class OrderRecord extends Equatable {
//   final String id;
//   final String name;
//   final double original;
//   final double actualPrice;
//   final double percentage;

//   const OrderRecord({
//     this.id = '',
//     required this.name,
//     this.original = 0,
//     this.percentage = 0,
//     this.actualPrice = 0,
//   });

//   factory OrderRecord.fromJson(String id, Map<String, dynamic> json) {
//     return OrderRecord(
//       id: id,
//       name: json['name'],
//       original: (json['itemPrice'] as num).toDouble(),
//       percentage: (json['percentage'] as num).toDouble(),
//       actualPrice: (json['actualPrice'] as num).toDouble(),
//     );
//   }

//   OrderRecord copyWith({String? name, double? original}) {
//     return OrderRecord(
//       name: name ?? this.name,
//       original: original ?? this.original,
//     );
//   }

//   OrderRecord calculatePercentage(double totalPrice) {
//     return OrderRecord(
//       name: name,
//       original: original,
//       actualPrice: actualPrice,
//       percentage: (original / totalPrice),
//     );
//   }

//   OrderRecord calculateActualPrice(double delta) {
//     return OrderRecord(
//       name: name,
//       original: original,
//       actualPrice: original + delta * percentage,
//       percentage: percentage,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "itemPrice": original,
//       "percentage": percentage,
//       "actualPrice": actualPrice,
//     };
//   }

//   @override
//   List<Object?> get props => [name];
// }
