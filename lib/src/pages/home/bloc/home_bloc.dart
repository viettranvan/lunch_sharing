import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lunch_sharing/src/models/api_models.dart';
import 'package:lunch_sharing/src/pages/home/bloc/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HomeRepository homeRepository;

  HomeBloc({
    required this.homeRepository,
  }) : super(HomeState()) {
    on<InitialData>(_onInitial);
    on<OnChangeRangeDate>(_onChangeRangeDate);
    on<FetchInvoices>(_onFetchInvoice);
    on<ClearFilter>(_onClearFilter);
    on<ToggleShowPaidInvoices>((event, emit) {
      emit(state.copyWith(showPaidInvoices: !state.showPaidInvoices));
    });
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
      final response = await homeRepository.getInvoices(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(
        state.copyWith(isLoading: false, apiInvoices: response.data, errorMessage: ''),
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

    // Trigger both old and new API calls for backward compatibility
    add(FetchInvoices(startDate: event.startDate, endDate: event.endDate));
  }

  FutureOr<void> _onClearFilter(ClearFilter event, Emitter<HomeState> emit) {
    emit(
      HomeState(
        isLoading: false,
        errorMessage: '',
        apiInvoices: state.apiInvoices,
        startDate: null,
        endDate: null,
        total: state.total,
      ),
    );

    add(FetchInvoices());

  }
}
