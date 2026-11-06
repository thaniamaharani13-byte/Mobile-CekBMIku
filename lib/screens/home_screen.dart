import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/article/article_cubit.dart';
import '../data/editorial_articles.dart';
import '../cubits/profile/profile_cubit.dart';
import '../models/models.dart';

/// Beranda baru berdasarkan desain CekBMIku.
/// Versi minggu ke-10: metrik BMI/target sengaja belum diaktifkan.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _ink = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _wash = Color(0xFFEDF3FF);

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthBloc>().state.user?.email;
    if (email != null) {
      context.read<ProfileCubit>().load(email);
    }
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback action,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: action,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _blue, size: 23),
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 10.3,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _latest() {
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: () => context.push('/history'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
        decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(19)),
        child: const Row(children: [
          Icon(Icons.monitor_heart_outlined, color: _blue, size: 35),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BMI Terakhir', style: TextStyle(color: _muted, fontSize: 12)),
            SizedBox(height: 5),
            Text('Belum tersedia', style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 17)),
            SizedBox(height: 4),
            Text('Fitur pemeriksaan dalam pengembangan',
              style: TextStyle(color: _muted, fontSize: 10.5)),
          ])),
          Icon(Icons.chevron_right, color: _blue),
        ]),
      ),
    );
  }

  Widget _callToAction() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => context.push('/calculator'),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.balance_outlined, color: _blue, size: 26),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Cek BMI Sekarang', style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Kalkulator BMI akan tersedia pada tahap berikutnya.',
                        style: TextStyle(color: _muted, fontSize: 10.5, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 9),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(11)),
                child: const Text('Segera hadir', style: TextStyle(color: _blue, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progress() {
    return InkWell(
      onTap: () => context.push('/progress'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(16)),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.track_changes_outlined, color: _blue, size: 26),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Progres Menuju Target',
              style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 15)),
            SizedBox(height: 9),
            LinearProgressIndicator(value: 0, minHeight: 7,
              color: _blue, backgroundColor: Color(0xFFDFE8F8)),
            SizedBox(height: 10),
            Text('Target dan ProgressBMIku direncanakan pada tahap berikutnya.',
              style: TextStyle(color: _muted, fontSize: 11)),
          ])),
          Icon(Icons.chevron_right, color: _blue),
        ]),
      ),
    );
  }

  Future<void> _openArticle(ArticleItem article) async {
    final favorite = await context.push<bool>('/articles/${article.id}', extra: article);
    if (favorite != null && mounted) {
      await context.read<ArticleCubit>().setFavorite(article.id, favorite);
    }
  }

  Widget _articles() {
    final first = editorialArticles[0].article;
    final second = editorialArticles[1].article;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _openArticle(first),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(first.image, height: 119, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 13, 13, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tag('Nutrisi'),
                          const Text('12 Jan 2026 · 4 menit baca', style: TextStyle(color: _muted, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(first.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(first.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, height: 1.4, fontSize: 10.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _openArticle(second),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(second.image, width: 69, height: 69, fit: BoxFit.cover),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tag('Olahraga'),
                      const SizedBox(height: 5),
                      Text(second.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _ink, fontSize: 11.8, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      Text(second.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 10.2, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(color: _blue, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 630),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 15, 24, 28),
          children: [
            const Text('Halo, Sobat Sehat!', style: TextStyle(color: _muted, fontSize: 13)),
            const SizedBox(height: 5),
            const Text('Langkah kecil, lebih sehat.',
              style: TextStyle(color: _ink, fontSize: 23, fontWeight: FontWeight.w800, height: 1.15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(10)),
              child: const Text('Prototipe minggu ke-10 · fitur utama BMI masih dikembangkan',
                style: TextStyle(color: _blue, fontSize: 11)),
            ),
            const SizedBox(height: 16),
            _latest(),
            const SizedBox(height: 19),
            _callToAction(),
            const SizedBox(height: 20),
            const Text('Fitur Cepat', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 11),
            LayoutBuilder(
              builder: (context, constraints) {
                // Dua kolom pada HP sangat sempit; empat di ukuran biasa.
                // Tinggi item tetap menghindari RenderFlex overflow.
                final columns = constraints.maxWidth < 315 ? 2 : 4;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 11,
                  crossAxisSpacing: 8,
                  mainAxisExtent: columns == 4 ? 98 : 102,
                  children: [
                _tile(icon: Icons.calculate_outlined, label: 'Kalkulator\nBMI', action: () => context.push('/calculator')),
                _tile(icon: Icons.description_outlined, label: 'Rekomendasi\nGaya Hidup', action: () => context.push('/recommendations')),
                _tile(icon: Icons.assignment_outlined, label: 'Riwayat', action: () => context.push('/history')),
                _tile(icon: Icons.bar_chart_outlined, label: 'Grafik\nPerkembangan', action: () => context.push('/progress')),
                _tile(icon: Icons.track_changes_outlined, label: 'Target BMI', action: () => context.push('/target')),
                _tile(icon: Icons.trending_up, label: 'ProgresBMIku', action: () => context.push('/progress')),
                _tile(icon: Icons.notifications_none_outlined, label: 'Pengingat', action: () => context.push('/reminders')),
                _tile(icon: Icons.person_outline, label: 'Profil', action: () => context.push('/profile')),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _progress(),
            const SizedBox(height: 23),
            Row(
              children: [
                const Expanded(child: Text('Artikel Terbaru · Draft',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 16))),
                TextButton(
                  onPressed: () => context.push('/articles'),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 3)),
                  child: const Text('Lihat Semua ›', style: TextStyle(color: _blue, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            _articles(),
          ],
        ),
      ),
    );
  }
}
