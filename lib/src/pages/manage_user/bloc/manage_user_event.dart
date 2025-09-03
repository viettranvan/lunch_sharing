part of 'manage_user_bloc.dart';

sealed class ManageUserEvent extends Equatable {
  const ManageUserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends ManageUserEvent {
  const FetchUsers();

  @override
  List<Object> get props => [];
}

class AddUser extends ManageUserEvent {
  const AddUser({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class DeleteUser extends ManageUserEvent {
  const DeleteUser(this.userId);

  final int userId;

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends ManageUserEvent {
  const UpdateUser(this.userId);

  final int userId;

  @override
  List<Object> get props => [userId];
}