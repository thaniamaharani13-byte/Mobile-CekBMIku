import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../cubits/article/article_cubit.dart';
import '../data/editorial_articles.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({
    super.key,
    required this.articleId,
    this.initialArticle,
  });

  final String articleId;
  final ArticleItem? initialArticle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        final article = initialArticle ?? _findArticle(state.articles, articleId);

        if (article == null &&
            (state.status == ArticleStatus.initial ||
                state.status == ArticleStatus.loading)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (article == null) {
          return const ArticleNotFoundScreen();
        }

        final isFavorite = state.isFavorite(article.id);

        return Scaffold(
          appBar: AppBar(title: const Text('Detail Artikel')),
          body: PageWidth(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    article.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                ),
                const SizedBox(height: 8),
                Chip(label: Text(article.category)),
                const SizedBox(height: 14),
                Text(
                  article.description,
                  style: const TextStyle(height: 1.6),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => context.pop(!isFavorite),
                  icon: Icon(
                    isFavorite
                        ? Icons.heart_broken_outlined
                        : Icons.favorite_outline,
                  ),
                  label: Text(
                    isFavorite
                        ? 'Hapus Favorit & Kembali'
                        : 'Tandai Favorit & Kembali',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ArticleItem? _findArticle(List<ArticleItem> articles, String id) {
    for (final article in articles) {
      if (article.id == id) return article;
    }
    for (final entry in editorialArticles) {
      if (entry.article.id == id) return entry.article;
    }
    return null;
  }
}

class ArticleNotFoundScreen extends StatelessWidget {
  const ArticleNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Artikel')),
      body: Center(
        child: FilledButton(
          onPressed: () => context.go('/articles'),
          child: const Text('Artikel tidak ditemukan — kembali'),
        ),
      ),
    );
  }
}
