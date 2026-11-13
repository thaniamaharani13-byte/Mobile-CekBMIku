part of 'admin_cubit.dart';

enum AdminStatus { initial, loading, loaded, failure }

class AdminState extends Equatable {
  const AdminState({
    this.status = AdminStatus.initial,
    this.users = const [],
    this.history = const [],
    this.feedback = const [],
    this.articles = const [],
  });

  final AdminStatus status;
  final List<AppUser> users;
  final List<BmiResult> history;
  final List<FeedbackItem> feedback;
  final List<ArticleItem> articles;

  @override
  List<Object?> get props => [status, users, history, feedback, articles];
}
