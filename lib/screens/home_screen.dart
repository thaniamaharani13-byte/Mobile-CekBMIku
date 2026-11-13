import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/article/article_cubit.dart';
import '../data/editorial_articles.dart';
import '../cubits/profile/profile_cubit.dart';
import '../models/models.dart';
import '../services/goal_store.dart';

/// Beranda baru berdasarkan desain CekBMIku.
/// Data BMI selalu diambil dari riwayat pengguna yang sedang login.
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

  final _goalStore = GoalStore();
  double? _goal;
  BmiGoal? _targetRecord;

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthBloc>().state.user?.email;
    if (email != null) {
      context.read<ProfileCubit>().load(email);
      _readGoal(email);
    }
  }

  Future<void> _readGoal(String email) async {
    final goal = await _goalStore.getTarget(email);
    if (mounted) setState(() {
      _targetRecord = goal;
      _goal = goal?.targetBmi;
    });
  }

  Future<void> _openTarget() async {
    await context.push('/target');
    if (!mounted) return;
    final email = context.read<AuthBloc>().state.user?.email;
    if (email != null) await _readGoal(email);
  }

  String _date(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _decimal(double value) => value.toStringAsFixed(1).replaceAll('.', ',');

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

  Widget _latest(BmiResult? latest) {
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: () => context.push('/history'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
        decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(19)),
        child: Row(
          children: [
            Container(
              width: 49, height: 49,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.monitor_heart_outlined, color: _blue, size: 27),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latest == null ? 'BMI Terakhir' : 'BMI Terakhir · ${_date(latest.createdAt)}',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    latest == null ? '–' : _decimal(latest.bmi),
                    style: const TextStyle(color: _blue, fontWeight: FontWeight.w800, fontSize: 28, height: 1.05),
                  ),
                  Container(width: 42, height: 2.5, color: _blue, margin: const EdgeInsets.only(top: 2)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(latest?.category ?? 'Belum ada data',
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 11)),
                  const SizedBox(height: 5),
                  Text(latest == null ? 'Mulai cek BMI' : 'Pemeriksaan terakhir',
                      style: const TextStyle(color: _blue, fontSize: 10.5)),
                ],
              ),
            ),
          ],
        ),
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
                    Text('Hitung indeks massa tubuh (BMI) dengan cepat dan mudah.',
                        style: TextStyle(color: _muted, fontSize: 10.5, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 9),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(11)),
                child: const Text('Mulai Cek BMI', style: TextStyle(color: _blue, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progress(List<BmiResult> history) {
    final fraction = GoalStore.progressForTarget(history, _targetRecord);
    final percent = (fraction * 100).round();
    return InkWell(
      onTap: () => context.push('/progress'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.track_changes_outlined, color: _blue, size: 27),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Progres Menuju Target',
                        style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 15))),
                      Text('$percent%', style: const TextStyle(fontSize: 11, color: _blue)),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right, color: _blue, size: 18),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(value: fraction, minHeight: 7,
                      color: _blue, backgroundColor: const Color(0xFFDFE8F8)),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    _targetRecord == null ? 'Tetapkan target untuk memulai progresmu.'
                      : GoalStore.baselineForTarget(history, _targetRecord) == null || !GoalStore.recordsInPeriod(history, _targetRecord!).any((r) => r.createdAt.isAfter(_targetRecord!.startDate))
                        ? 'Lakukan pemeriksaan berikutnya untuk melihat progres.'
                      : 'Target ${_targetRecord!.kind == GoalKind.weight ? 'berat' : 'BMI'} ${_decimal(_targetRecord!.value)} · pantau progresmu.',
                    style: const TextStyle(color: _muted, fontSize: 10.5, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openArticle(ArticleItem article) async {
    final favorite = await context.push<bool>('/articles/${article.id}', extra: article);
    if (favorite != null && mounted) {
      await context.read<ArticleCubit>().setFavorite(article.id, favorite);
    }
  }

  Widget _articles(ArticleState state) {
    final first = editorialArticles[0].article;
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
    final profile = context.watch<ProfileCubit>().state;
    final articles = context.watch<ArticleCubit>().state;
    final history = [...profile.history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latest = history.isNotEmpty ? history.first : null;

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
            const SizedBox(height: 21),
            _latest(latest),
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
                _tile(icon: Icons.track_changes_outlined, label: 'Target BMI', action: _openTarget),
                _tile(icon: Icons.trending_up, label: 'ProgresBMIku', action: () => context.push('/progress')),
                _tile(icon: Icons.notifications_none_outlined, label: 'Pengingat', action: () => context.push('/reminders')),
                _tile(icon: Icons.person_outline, label: 'Profil', action: () => context.push('/profile')),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _progress(history),
            const SizedBox(height: 23),
            Row(
              children: [
                const Expanded(child: Text('Artikel Terbaru',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 16))),
                TextButton(
                  onPressed: () => context.push('/articles'),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 3)),
                  child: const Text('Lihat Semua ›', style: TextStyle(color: _blue, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            _articles(articles),
          ],
        ),
      ),
    );
  }
}
