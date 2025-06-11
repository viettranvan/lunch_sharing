part of 'mark_paid_bloc.dart';

class MarkPaidState extends Equatable {
  const MarkPaidState({
    this.isLoading = false,
    this.errorMessage = '',
    this.invoices = const [],
    required this.startDate,
    required this.endDate,
  });

  final bool isLoading;
  final String errorMessage;
  final List<Invoices> invoices;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object> get props => [
    isLoading,
    errorMessage,
    invoices,
    startDate,
    endDate,
  ];

  MarkPaidState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Invoices>? invoices,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return MarkPaidState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      invoices: invoices ?? this.invoices,
    );
  }
}
