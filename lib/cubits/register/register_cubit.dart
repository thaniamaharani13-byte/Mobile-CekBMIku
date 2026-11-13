import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._store) : super(const RegisterState());

  final LocalStore _store;

  /// Data usia dan jenis kelamin dilengkapi di Edit Profil setelah registrasi.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();

    if (cleanName.isEmpty || cleanEmail.isEmpty ||
        password.isEmpty || confirmPassword.isEmpty) {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        message: 'Semua kolom wajib diisi.',
      ));
      return;
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(cleanEmail)) {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        message: 'Format email belum benar.',
      ));
      return;
    }

    if (cleanEmail == 'admin@cekbmiku.id') {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        message: 'Email ini digunakan oleh akun admin demo.',
      ));
      return;
    }

    if (password.length < 6) {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        message: 'Password minimal 6 karakter.',
      ));
      return;
    }

    if (password != confirmPassword) {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        message: 'Konfirmasi password tidak cocok.',
      ));
      return;
    }

    emit(const RegisterState(status: RegisterStatus.loading));

    final error = await _store.register(
      AppUser(
        name: cleanName,
        email: cleanEmail,
        password: password,
        age: 0, // Penanda: belum diisi, bukan umur sebenarnya.
        gender: '', // Penanda: belum diisi, bukan pilihan default gender.
      ),
    );

    if (error != null) {
      emit(RegisterState(status: RegisterStatus.failure, message: error));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('joined_date_$cleanEmail', DateTime.now().toIso8601String());
      emit(const RegisterState(
        status: RegisterStatus.success,
        message: 'Pendaftaran berhasil. Silakan masuk dan lengkapi profil.',
      ));
    }
  }

  void reset() => emit(const RegisterState());
}
