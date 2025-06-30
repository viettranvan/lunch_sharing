import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/models/invoices.dart';
import 'package:lunch_sharing/services/invoice_service.dart';

part 'mark_paid_event.dart';
part 'mark_paid_state.dart';

class MarkPaidBloc extends Bloc<MarkPaidEvent, MarkPaidState> {
  final InvoiceService invoiceService;
  MarkPaidBloc({required this.invoiceService})
      : super(
            MarkPaidState(startDate: DateTime.now(), endDate: DateTime.now())) {
    on<FetchInvoices>(_onFetchInvoices);
    on<MarkUserAsPaid>(_onMarkUserAsPaid);
    on<DeleteInvoice>(_onDeleteInvoice);
    on<OnChangeRangeDate>(_onChangeRangeDate);
    on<ToggleShowPaidInvoices>((event, emit) {
      emit(state.copyWith(showPaidInvoices: !state.showPaidInvoices));
    });
  }

  FutureOr<void> _onFetchInvoices(
    FetchInvoices event,
    Emitter<MarkPaidState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final response = await invoiceService.fetchInvoices(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(
        state.copyWith(isLoading: false, invoices: response, errorMessage: ''),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onMarkUserAsPaid(
    MarkUserAsPaid event,
    Emitter<MarkPaidState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final isMark = await invoiceService.markPaid(
        invoiceId: event.invoiceId,
        ordererId: event.ordererId,
      );

      if (isMark) {
        final newList = [...state.invoices];
        final index = newList.indexWhere(
          (invoice) => invoice.id == event.invoiceId,
        );
        if (index != -1) {
          final listOrderers = newList[index].orderers;
          final ordererIndex = listOrderers.indexWhere(
            (orderer) => orderer.id == event.ordererId,
          );
          if (ordererIndex != -1) {
            listOrderers[ordererIndex] = listOrderers[ordererIndex].copyWith(
              isPaid: true,
            );
            newList[index] = newList[index].copyWith(orderers: listOrderers);
            emit(
              state.copyWith(
                invoices: newList,
                isLoading: false,
                errorMessage: '',
              ),
            );
          }
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to mark as paid',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onChangeRangeDate(
    OnChangeRangeDate event,
    Emitter<MarkPaidState> emit,
  ) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
    add(FetchInvoices(startDate: event.startDate, endDate: event.endDate));
  }

  FutureOr<void> _onDeleteInvoice(
      DeleteInvoice event, Emitter<MarkPaidState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      final isDeleted = await invoiceService.deleteInvoice(event.invoiceId);

      if (isDeleted) {
        final newList = state.invoices
            .where((invoice) => invoice.id != event.invoiceId)
            .toList();
        emit(state.copyWith(
            invoices: newList, isLoading: false, errorMessage: ''));
        EasyLoading.showSuccess('Xóa hóa đơn thành công!');
      } else {
        emit(state.copyWith(
            isLoading: false, errorMessage: 'Failed to delete invoice'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
