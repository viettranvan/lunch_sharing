import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:lunch_sharing/models/orderer.dart';

class Invoices extends Equatable {
  final String id;

  final String storeName;
  final double paidAmount;
  final Timestamp createdAt;
  final List<Orderers> orderers;
  const Invoices({
    required this.id,
    required this.storeName,
    required this.paidAmount,
    required this.createdAt,
    required this.orderers,
  });

  factory Invoices.fromMap(String id, Map<String, dynamic> map) {
    return Invoices(
      id: id,
      storeName: map['storeName'] ?? '',
      paidAmount: map['paidAmount']?.toDouble() ?? 0.0,
      createdAt: (map['createdAt'] as Timestamp),
      orderers: (map['orderers'] as List)
          .map((e) => Orderers.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, storeName, paidAmount, createdAt, orderers];

  Invoices copyWith({
    String? id,
    String? storeName,
    double? paidAmount,
    Timestamp? createdAt,
    List<Orderers>? orderers,
  }) {
    return Invoices(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      paidAmount: paidAmount ?? this.paidAmount,
      createdAt: createdAt ?? this.createdAt,
      orderers: orderers ?? this.orderers,
    );
  }
}
