import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._store) : super(const AdminState());

  final LocalStore _store;

  Future<void> load() async {
    emit(const AdminState(status: AdminStatus.loading));
    final users = await _store.getUsers();
    final history = await _store.getHistory();
    final feedback = await _store.getFeedback();
    final articles = await _store.getArticles();
    emit(AdminState(
      status: AdminStatus.loaded,
      users: users,
      history: history,
      feedback: feedback,
      articles: articles,
    ));
  }

  Future<void> deleteUser(String email) async {
    await _store.deleteUser(email);
    await load();
  }
}
