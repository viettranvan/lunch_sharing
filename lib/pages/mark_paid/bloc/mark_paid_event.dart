part of 'mark_paid_bloc.dart';

sealed class MarkPaidEvent extends Equatable {
  const MarkPaidEvent();

  @override
  List<Object?> get props => [];
}

class FetchInvoices extends MarkPaidEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FetchInvoices({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class MarkUserAsPaid extends MarkPaidEvent {
  final String ordererId;
  final String invoiceId;

  const MarkUserAsPaid({required this.ordererId, required this.invoiceId});

  @override
  List<Object?> get props => [ordererId, invoiceId];
}

class OnChangeRangeDate extends MarkPaidEvent {
  final DateTime startDate;
  final DateTime endDate;

  const OnChangeRangeDate({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}
