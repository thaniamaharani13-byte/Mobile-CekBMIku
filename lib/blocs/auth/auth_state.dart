part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  guest,
  authenticated,
  adminAuthenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isAdmin => status == AuthStatus.adminAuthenticated;

  @override
  List<Object?> get props => [status, user, message];
}
