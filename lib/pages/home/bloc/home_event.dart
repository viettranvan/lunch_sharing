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