import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/local_store.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(this._store) : super(const ArticleState());

  final LocalStore _store;

  Future<void> load() async {
    emit(const ArticleState(status: ArticleStatus.loading));
    final articles = await _store.getArticles();
    final favorites = await _store.getFavoriteArticleIds();
    emit(ArticleState(
      status: ArticleStatus.loaded,
      articles: articles,
      favoriteIds: favorites,
    ));
  }

  Future<void> setFavorite(String articleId, bool favorite) async {
    final updated = Set<String>.from(state.favoriteIds);
    if (favorite) {
      updated.add(articleId);
    } else {
      updated.remove(articleId);
    }
    await _store.saveFavoriteArticleIds(updated);
    emit(state.copyWith(favoriteIds: updated));
  }

  ArticleItem? findById(String id) {
    for (final article in state.articles) {
      if (article.id == id) return article;
    }
    return null;
  }
}
