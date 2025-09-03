import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lunch_sharing/src/models/api_models.dart';
import 'package:lunch_sharing/src/pages/manage_user/bloc/user_repository.dart';

part 'manage_user_event.dart';
part 'manage_user_state.dart';

class ManageUserBloc extends Bloc<ManageUserEvent, ManageUserState> {
  final UserRepository repository;

  ManageUserBloc({required this.repository}) : super(ManageUserState()) {
    on<FetchUsers>(_onFetchUsers);
    on<DeleteUser>(_onDeleteUser);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
  }

  FutureOr<void> _onFetchUsers(
      FetchUsers event, Emitter<ManageUserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response = await repository.fetchUser();

      emit(
        state.copyWith(
            isLoading: false, users: response.data, errorMessage: ''),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onAddUser(
      AddUser event, Emitter<ManageUserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response = await repository.createUser(event.name);

      final newList = [...state.users];
      if (response.code == 200 && response.data != null) {
        newList.insert(0, response.data!);
      }

      emit(state.copyWith(isLoading: false, users: newList, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onDeleteUser(
      DeleteUser event, Emitter<ManageUserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      await repository.deleteUser(event.userId);

      // Remove user from local state
      final updatedUsers =
          state.users.where((user) => user.id != event.userId).toList();

      emit(state.copyWith(
          isLoading: false, users: updatedUsers, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onUpdateUser(
      UpdateUser event, Emitter<ManageUserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response =
          await repository.updateUser(event.userId);

      if (response.success && response.data != null) {
        // Update user in local state
        final updatedUsers = state.users.map((user) {
          return user.id == event.userId ? response.data! : user;
        }).toList();

        emit(state.copyWith(
            isLoading: false, users: updatedUsers, errorMessage: ''));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
