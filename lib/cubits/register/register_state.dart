part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.message,
  });

  final RegisterStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
