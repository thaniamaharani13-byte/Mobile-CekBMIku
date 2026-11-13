import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/broca_calculator.dart';
import '../../models/models.dart';
import '../../services/local_store.dart';

part 'bmi_event.dart';
part 'bmi_state.dart';

class BmiBloc extends Bloc<BmiEvent, BmiState> {
  BmiBloc(this._store) : super(const BmiState()) {
    on<BmiCalculateRequested>(_onCalculate);
    on<BmiResetRequested>((event, emit) => emit(const BmiState()));
  }

  final LocalStore _store;

  Future<void> _onCalculate(
    BmiCalculateRequested event,
    Emitter<BmiState> emit,
  ) async {
    final heightCm = double.tryParse(event.heightText.replaceAll(',', '.'));
    final weightKg = double.tryParse(event.weightText.replaceAll(',', '.'));

    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      emit(const BmiState(
        status: BmiStatus.failure,
        message: 'Tinggi dan berat badan harus berupa angka lebih dari 0.',
      ));
      return;
    }

    if (heightCm < 50 || heightCm > 250 || weightKg < 10 || weightKg > 300) {
      emit(const BmiState(
        status: BmiStatus.failure,
        message: 'Nilai tinggi atau berat berada di luar rentang yang wajar.',
      ));
      return;
    }

    emit(const BmiState(status: BmiStatus.loading));

    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    // Gunakan rumus bersama agar hasil di BLoC dan tampilan selalu sama.
    final idealWeight = BrocaCalculator.estimate(
      heightCm: heightCm,
      gender: event.gender,
    );
    if (event.gender != 'L' && event.gender != 'P') {
      emit(const BmiState(
        status: BmiStatus.failure,
        message: 'Silakan pilih Pria atau Wanita.',
      ));
      return;
    }
    final category = _categoryFor(bmi);

    final result = BmiResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userEmail: event.userEmail ?? '',
      heightCm: heightCm,
      weightKg: weightKg,
      bmi: bmi,
      idealWeight: idealWeight ?? 0.0, // Tidak tersedia untuk TB <= 100 cm.
      category: category,
      gender: event.gender,
      createdAt: DateTime.now(),
    );

    if ((event.userEmail ?? '').isNotEmpty) {
      await _store.addBmi(result);
    }

    emit(BmiState(status: BmiStatus.success, result: result));
  }

  String _categoryFor(double bmi) {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Kelebihan Berat Badan';
    return 'Obesitas';
  }
}
