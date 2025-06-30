part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.errorMessage = '',
    this.invoices = const [],
    this.startDate,
    this.endDate,
    this.showPaidInvoices = false,
  });

  final bool isLoading;
  final String errorMessage;
  final List<Invoices> invoices;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showPaidInvoices;

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        invoices,
        startDate,
        endDate,
        showPaidInvoices,
      ];

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Invoices>? invoices,
    DateTime? startDate,
    DateTime? endDate,
    bool? showPaidInvoices,
  }) {
    return HomeState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      invoices: invoices ?? this.invoices,
      showPaidInvoices: showPaidInvoices ?? this.showPaidInvoices,
    );
  }
}
