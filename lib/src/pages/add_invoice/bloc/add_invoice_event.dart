part of 'add_invoice_bloc.dart';

sealed class AddInvoiceEvent extends Equatable {
  const AddInvoiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends AddInvoiceEvent {
  const FetchUsers();

  @override
  List<Object> get props => [];
}


class AddNewRecord extends AddInvoiceEvent {
  const AddNewRecord();

  @override
  List<Object> get props => [];
}

class UpdateStateValue extends AddInvoiceEvent {
  const UpdateStateValue({
    this.isLoading,
    this.errorMessage,
    this.users,
    this.date,
    this.orderers,
  });

  final bool? isLoading;
  final String? errorMessage;
  final List<String>? users;
  final DateTime? date;
  final List<ApiOrderer>? orderers;

  @override
  List<Object?> get props => [isLoading, errorMessage, users, date, orderers];
}
