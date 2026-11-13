part of 'feedback_cubit.dart';

enum FeedbackStatus { initial, loading, success, failure }

class FeedbackState extends Equatable {
  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.message,
  });

  final FeedbackStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
