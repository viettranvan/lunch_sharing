part of 'add_record_bloc.dart';

class AddRecordState extends Equatable {
  const AddRecordState({
    this.isLoading = false,
    this.errorMessage = '',
    this.users = const [],
    required this.date,
    this.orderers = const [],
    this.discrepancy = 0.0,
  });

  final bool isLoading;
  final String errorMessage;
  final List<String> users;
  final DateTime date;
  final List<Orderers> orderers;
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

  AddRecordState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<String>? users,
    DateTime? date,
    List<Orderers>? orderers,
    double? discrepancy,
  }) {
    return AddRecordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      date: date ?? this.date,
      orderers: orderers ?? this.orderers,
      discrepancy: discrepancy ?? this.discrepancy,
    );
  }
}
