part of 'mark_paid_bloc.dart';

class MarkPaidState extends Equatable {
  const MarkPaidState({
    this.isLoading = false,
    this.errorMessage = '',
    this.invoices = const [],
    required this.startDate,
    required this.endDate,
    this.showPaidInvoices = false,
  });

  final bool isLoading;
  final String errorMessage;
  final List<Invoices> invoices;
  final DateTime startDate;
  final DateTime endDate;
  final bool showPaidInvoices;

  @override
  List<Object> get props => [
        isLoading,
        errorMessage,
        invoices,
        startDate,
        endDate,
        showPaidInvoices,
      ];

  MarkPaidState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Invoices>? invoices,
    DateTime? startDate,
    DateTime? endDate,
    bool? showPaidInvoices,
  }) {
    return MarkPaidState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showPaidInvoices: showPaidInvoices ?? this.showPaidInvoices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      invoices: invoices ?? this.invoices,
    );
  }
}
