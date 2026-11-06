part of 'article_cubit.dart';

enum ArticleStatus { initial, loading, loaded, failure }

class ArticleState extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.articles = const [],
    this.favoriteIds = const <String>{},
  });

  final ArticleStatus status;
  final List<ArticleItem> articles;
  final Set<String> favoriteIds;

  bool isFavorite(String id) => favoriteIds.contains(id);

  ArticleState copyWith({
    ArticleStatus? status,
    List<ArticleItem>? articles,
    Set<String>? favoriteIds,
  }) {
    return ArticleState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [status, articles, favoriteIds];
}
