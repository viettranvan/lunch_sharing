import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/models/orderer.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/services/user_order_service.dart';

part 'add_record_event.dart';
part 'add_record_state.dart';

class AddRecordBloc extends Bloc<AddRecordEvent, AddRecordState> {
  final InvoiceService invoiceService;
  final UserOrderService userOrderService;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  AddRecordBloc({required this.invoiceService, required this.userOrderService})
    : super(AddRecordState(date: DateTime.now())) {
    on<FetchUsers>(_onFetchUsers);
    on<AddNewUser>(_onAddNewUser);
    on<UpdateStateValue>(_onUpdateStateValue);
    on<AddNewRecord>(_onAddNewRecord);
  }

  FutureOr<void> _onFetchUsers(
    FetchUsers event,
    Emitter<AddRecordState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response = await userOrderService.getListUser();
      emit(state.copyWith(isLoading: false, users: response, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onAddNewUser(
    AddNewUser event,
    Emitter<AddRecordState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response = await userOrderService.addUser(userName: event.userName);
      if (response) {
        final updatedUsers = [...state.users, event.userName];

        emit(
          state.copyWith(
            isLoading: false,
            users: updatedUsers,
            errorMessage: '',
          ),
        );
        EasyLoading.showSuccess('Added user successfully!');
      } else {
        emit(
          state.copyWith(isLoading: false, errorMessage: 'Failed to add user.'),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onUpdateStateValue(
    UpdateStateValue event,
    Emitter<AddRecordState> emit,
  ) {
    List<Orderers>? orderers;
    double? discrepancy;

    if (event.orderers != null && amountController.text.isNotEmpty) {
      orderers = [];
      // Tổng số tiền thực tế đã trả
      final amountYouPaid = double.tryParse(amountController.text) ?? 0.0;

      // Tổng số tiền thực tế của các orderers trên hóa đơn
      final totalPrice = event.orderers!.fold(
        0.0,
        (sum, item) => sum + item.itemPrice,
      );

      // Số tiền chênh lệch giữa số tiền bạn đã trả và tổng số tiền thực tế của các orderers
      discrepancy = amountYouPaid - totalPrice;

      // Cập nhật giá thực tế cho từng orderer dựa trên tỷ lệ phần trăm của họ
      for (final item in event.orderers!) {
        final actualPrice = item.itemPrice + discrepancy * item.percentage;
        orderers.add(item.copyWith(actualPrice: actualPrice));
      }
    }
    emit(
      state.copyWith(
        date: event.date,
        orderers: orderers ?? event.orderers,
        isLoading: false,
        errorMessage: '',
        discrepancy: discrepancy,
      ),
    );
  }

  FutureOr<void> _onAddNewRecord(
    AddNewRecord event,
    Emitter<AddRecordState> emit,
  ) async {
    try {
      if (nameController.text.isEmpty) {
        EasyLoading.showError('Please enter a store name.');
      } else if (amountController.text.isEmpty) {
        EasyLoading.showError('Please enter a paid amount.');
      } else if (state.orderers.isEmpty) {
        EasyLoading.showError('Please add at least one orderer.');
      } else {
        EasyLoading.show();

        final sts = await invoiceService.addInvoice(
          storeName: nameController.text,
          paidAmount: double.tryParse(amountController.text) ?? 0.0,
          date: state.date,
          orderers: state.orderers,
        );
        if (sts) {
          nameController.clear();
          amountController.clear();
          emit(
            state.copyWith(
              isLoading: false,
              orderers: [],
              discrepancy: 0.0,
              date: DateTime.now(),
              errorMessage: '',
            ),
          );
          EasyLoading.showSuccess('Record added successfully!');
        }
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
