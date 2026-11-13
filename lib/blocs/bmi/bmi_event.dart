part of 'bmi_bloc.dart';

sealed class BmiEvent extends Equatable {
  const BmiEvent();

  @override
  List<Object?> get props => [];
}

class BmiCalculateRequested extends BmiEvent {
  const BmiCalculateRequested({
    required this.heightText,
    required this.weightText,
    required this.gender,
    this.userEmail,
  });

  final String heightText;
  final String weightText;
  final String gender;
  final String? userEmail;

  @override
  List<Object?> get props => [heightText, weightText, gender, userEmail];
}

class BmiResetRequested extends BmiEvent {
  const BmiResetRequested();
}
