import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lunch_sharing/models/invoices.dart';
import 'package:lunch_sharing/services/invoice_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  InvoiceService invoiceService = InvoiceService();

  HomeBloc({required this.invoiceService})
    : super(HomeState(startDate: DateTime.now(), endDate: DateTime.now())) {
    on<InitialData>(_onInitial);
    on<OnChangeRangeDate>(_onChangeRangeDate);
    on<FetchInvoices>(_onFetchInvoice);
  }

  FutureOr<void> _onInitial(InitialData event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        startDate: event.queryParams['start_date'] != null
            ? DateTime.parse(event.queryParams['start_date']!)
            : DateTime.now(),
        endDate: event.queryParams['end_date'] != null
            ? DateTime.parse(event.queryParams['end_date']!)
            : DateTime.now(),
      ),
    );
  }

  FutureOr<void> _onFetchInvoice(
    FetchInvoices event,
    Emitter<HomeState> emit,
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

  FutureOr<void> _onChangeRangeDate(
    OnChangeRangeDate event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
    add(FetchInvoices(startDate: event.startDate, endDate: event.endDate));
  }
}
