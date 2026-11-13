part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {
  const AuthAppStarted();
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({
    required this.identity,
    required this.password,
    this.rememberMe = false,
  });

  final String identity;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [identity, password, rememberMe];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthUserUpdated extends AuthEvent {
  const AuthUserUpdated(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}
