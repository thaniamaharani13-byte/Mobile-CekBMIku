import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._store) : super(const ProfileState());

  final LocalStore _store;

  Future<void> load(String email) async {
    emit(const ProfileState(status: ProfileStatus.loading));
    final users = await _store.getUsers();
    AppUser? user;
    for (final item in users) {
      if (item.email == email) {
        user = item;
        break;
      }
    }

    if (user == null) {
      emit(const ProfileState(
        status: ProfileStatus.failure,
        message: 'Data profil tidak ditemukan.',
      ));
      return;
    }

    final history = await _store.historyFor(email);
    emit(ProfileState(
      status: ProfileStatus.loaded,
      user: user,
      history: history,
    ));
  }

  Future<void> updateProfile({
    required AppUser current,
    required String name,
    required String ageText,
    required String gender,
  }) async {
    final age = int.tryParse(ageText.trim());
    if (name.trim().isEmpty || age == null || age <= 0) {
      emit(ProfileState(
        status: ProfileStatus.failure,
        user: current,
        message: 'Nama dan umur harus diisi dengan benar.',
      ));
      return;
    }

    final updated = current.copyWith(
      name: name.trim(),
      age: age,
      gender: gender,
    );

    await _store.updateUser(updated);
    final history = await _store.historyFor(updated.email);
    emit(ProfileState(
      status: ProfileStatus.updated,
      user: updated,
      history: history,
      message: 'Profil berhasil diperbarui.',
    ));
  }
}
