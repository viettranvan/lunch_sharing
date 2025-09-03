part of 'manage_user_bloc.dart';

class ManageUserState extends Equatable {
  const ManageUserState(
      {this.users = const [], this.isLoading = false, this.errorMessage = ''});

  final List<ApiUser> users;
  final bool isLoading;
  final String errorMessage;

  @override
  List<Object> get props => [users, isLoading, errorMessage];

  ManageUserState copyWith({
    List<ApiUser>? users,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ManageUserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
