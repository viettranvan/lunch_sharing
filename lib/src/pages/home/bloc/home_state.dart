part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.errorMessage = '',
    this.apiInvoices = const [],
    this.startDate,
    this.endDate,
    this.showPaidInvoices = false,
    this.total = 0,
  });

  final bool isLoading;
  final String errorMessage;
  final List<ApiInvoice> apiInvoices; // New API invoices
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showPaidInvoices;
  final int total;

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        apiInvoices,
        startDate,
        endDate,
        showPaidInvoices,
        total,
      ];

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ApiInvoice>? apiInvoices,
    DateTime? startDate,
    DateTime? endDate,
    bool? showPaidInvoices,
    int? total,
  }) {
    return HomeState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      apiInvoices: apiInvoices ?? this.apiInvoices,
      showPaidInvoices: showPaidInvoices ?? this.showPaidInvoices,
      total: total ?? this.total,
    );
  }
}
