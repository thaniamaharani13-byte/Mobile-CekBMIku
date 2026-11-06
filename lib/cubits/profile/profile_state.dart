part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, updated, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.history = const [],
    this.message,
  });

  final ProfileStatus status;
  final AppUser? user;
  final List<BmiResult> history;
  final String? message;

  @override
  List<Object?> get props => [status, user, history, message];
}
