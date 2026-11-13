import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._store) : super(const AuthState()) {
    on<AuthAppStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  final LocalStore _store;

  Future<void> _onStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));
    if (await _store.hasRememberedAdmin()) {
      emit(const AuthState(status: AuthStatus.adminAuthenticated));
      return;
    }
    final user = await _store.currentUser();
    if (user == null) {
      emit(const AuthState(status: AuthStatus.guest));
    } else {
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    }
  }

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final identity = event.identity.trim();
    if (identity.isEmpty || event.password.isEmpty) {
      emit(const AuthState(
        status: AuthStatus.failure,
        message: 'Email/username dan password wajib diisi.',
      ));
      return;
    }

    emit(const AuthState(status: AuthStatus.loading));

    if (await _store.loginAdmin(
      identity,
      event.password,
      rememberMe: event.rememberMe,
    )) {
      emit(const AuthState(status: AuthStatus.adminAuthenticated));
      return;
    }

    final user = await _store.loginUser(
      identity,
      event.password,
      rememberMe: event.rememberMe,
    );
    if (user == null) {
      emit(const AuthState(
        status: AuthStatus.failure,
        message: 'Email/username atau password salah.',
      ));
      return;
    }

    emit(AuthState(status: AuthStatus.authenticated, user: user));
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _store.logout();
    emit(const AuthState(status: AuthStatus.guest));
  }

  void _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState(status: AuthStatus.authenticated, user: event.user));
  }
}
