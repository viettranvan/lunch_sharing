part of 'add_record_bloc.dart';

sealed class AddRecordEvent extends Equatable {
  const AddRecordEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends AddRecordEvent {
  const FetchUsers();

  @override
  List<Object> get props => [];
}

class AddNewUser extends AddRecordEvent {
  const AddNewUser({required this.userName});

  final String userName;

  @override
  List<Object> get props => [userName];
}

class AddNewRecord extends AddRecordEvent {
  const AddNewRecord();

  @override
  List<Object> get props => [];
}

class UpdateStateValue extends AddRecordEvent {
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
  final List<Orderers>? orderers;

  @override
  List<Object?> get props => [isLoading, errorMessage, users, date, orderers];
}
