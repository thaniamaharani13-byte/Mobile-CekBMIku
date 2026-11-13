part of 'bmi_bloc.dart';

enum BmiStatus { initial, loading, success, failure }

class BmiState extends Equatable {
  const BmiState({
    this.status = BmiStatus.initial,
    this.result,
    this.message,
  });

  final BmiStatus status;
  final BmiResult? result;
  final String? message;

  @override
  List<Object?> get props => [status, result, message];
}
