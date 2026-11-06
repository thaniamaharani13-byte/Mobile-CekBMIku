import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/article/article_cubit.dart';
import '../data/editorial_articles.dart';
import '../models/models.dart';

/// Halaman "Semua Artikel" mandiri tanpa navbar bawah, sesuai desain UI.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  static const _ink = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _wash = Color(0xFFEEF3FF);

  Future<void> _openDetail(BuildContext context, ArticleItem article) async {
    final result = await context.push<bool>(
      '/articles/${article.id}', extra: article,
    );
    if (result != null && context.mounted) {
      await context.read<ArticleCubit>().setFavorite(article.id, result);
    }
  }

  Widget _articleCard(BuildContext context, EditorialEntry entry, bool favorite) {
    final article = entry.article;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => _openDetail(context, article),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  article.image, width: 87, height: 99, fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    width: 87, height: 99, color: _wash,
                    child: const Icon(Icons.menu_book_outlined, color: _blue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(20)),
                        child: Text(article.category,
                          style: const TextStyle(color: _blue, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                      if (favorite) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.favorite, color: Color(0xFFE85A85), size: 14),
                      ],
                    ]),
                    const SizedBox(height: 5),
                    Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _ink, fontSize: 12.4, height: 1.32, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 10.4, height: 1.38)),
                    const SizedBox(height: 7),
                    Text('${entry.published} · ${entry.readTime}',
                      style: const TextStyle(color: _muted, fontSize: 9.7)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select((ArticleCubit cubit) => cubit.state.favoriteIds);
    final previewArticles = editorialArticles.take(3).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
          icon: const Icon(Icons.arrow_back, color: _blue, size: 21),
          tooltip: 'Kembali ke Beranda',
        ),
        titleSpacing: 0,
        title: const Text('Semua Artikel',
          style: TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 630),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 30),
            children: [
              const Text('Bacaan untuk hidup lebih sehat',
                style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 5),
              const Text('Kenali tubuhmu lewat tips BMI, nutrisi, dan aktivitas fisik sehari-hari.',
                style: TextStyle(color: _muted, fontSize: 11.6, height: 1.45)),
              const SizedBox(height: 22),
              Text('${previewArticles.length} artikel contoh (konten belum final)',
                style: const TextStyle(color: _muted, fontSize: 11.5)),
              const SizedBox(height: 11),
              ...previewArticles.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _articleCard(context, entry, favoriteIds.contains(entry.article.id)),
              )),
              const SizedBox(height: 6),
              const Center(child: Text('Artikel lain sedang disiapkan untuk tahap berikutnya.',
                style: TextStyle(color: _muted, fontSize: 10.5))),
            ],
          ),
        ),
      ),
    );
  }
}
