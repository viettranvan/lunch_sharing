part of 'add_invoice_bloc.dart';

class AddInvoiceState extends Equatable {
  const AddInvoiceState({
    this.isLoading = false,
    this.errorMessage = '',
    this.users = const [],
    required this.date,
    this.orderers = const [],
    this.discrepancy = 0.0,
  });

  final bool isLoading;
  final String errorMessage;
  final List<ApiUser> users;
  final DateTime date;
  final List<ApiOrderer> orderers;
  final double discrepancy;

  @override
  List<Object> get props => [
        isLoading,
        errorMessage,
        users,
        date,
        orderers,
        discrepancy,
      ];

  AddInvoiceState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ApiUser>? users,
    DateTime? date,
    List<ApiOrderer>? orderers,
    double? discrepancy,
  }) {
    return AddInvoiceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      date: date ?? this.date,
      orderers: orderers ?? this.orderers,
      discrepancy: discrepancy ?? this.discrepancy,
    );
  }
}
