import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit(this._store) : super(const FeedbackState());

  final LocalStore _store;

  Future<void> submit({
    required AppUser user,
    required String message,
  }) async {
    if (message.trim().length < 5) {
      emit(const FeedbackState(
        status: FeedbackStatus.failure,
        message: 'Masukan minimal 5 karakter.',
      ));
      return;
    }

    emit(const FeedbackState(status: FeedbackStatus.loading));
    await _store.addFeedback(
      FeedbackItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        userEmail: user.email,
        userName: user.name,
        message: message.trim(),
        createdAt: DateTime.now(),
      ),
    );
    emit(const FeedbackState(
      status: FeedbackStatus.success,
      message: 'Terima kasih, masukan berhasil dikirim.',
    ));
  }

  void reset() => emit(const FeedbackState());
}
