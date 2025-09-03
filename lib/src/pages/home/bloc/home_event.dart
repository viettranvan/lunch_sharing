part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitialData extends HomeEvent {
  final Map<String, String> queryParams;
  const InitialData({required this.queryParams});

  @override
  List<Object> get props => [queryParams];
}

class OnChangeRangeDate extends HomeEvent {
  final DateTime startDate;
  final DateTime endDate;

  const OnChangeRangeDate({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}

class FetchInvoices extends HomeEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const FetchInvoices({this.startDate, this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class ClearFilter extends HomeEvent {
  const ClearFilter();

  @override
  List<Object> get props => [];
}

final class ToggleShowPaidInvoices extends HomeEvent {}

class MarkInvoicePaid extends HomeEvent {
  final int invoiceId;
  final int ordererId;

  const MarkInvoicePaid(this.invoiceId, this.ordererId);

  @override
  List<Object> get props => [invoiceId, ordererId];
}

class DeleteInvoice extends HomeEvent {
  final int invoiceId;

  const DeleteInvoice(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}

class MarkUserAsPaidBulk extends HomeEvent {
  final int userId;

  const MarkUserAsPaidBulk(this.userId);

  @override
  List<Object> get props => [userId];
}
