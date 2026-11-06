import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/lifestyle_tips.dart';

/// Tiga tab rekomendasi sesuai Figma: Makanan, Aktivitas Fisik, Gaya Hidup.
/// Semua gambar tersimpan sebagai asset lokal dari screenshot UI milik pengguna.
/// Tidak ada bottom navigation pada halaman detail ini (seperti pada desain).
class LifestyleRecommendationsScreen extends StatefulWidget {
  const LifestyleRecommendationsScreen({super.key});

  @override
  State<LifestyleRecommendationsScreen> createState() =>
      _LifestyleRecommendationsScreenState();
}

class _LifestyleRecommendationsScreenState
    extends State<LifestyleRecommendationsScreen> {
  static const _ink = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _soft = Color(0xFFF7F9FD);
  static const _summaryBg = Color(0xFFEDF3FF);

  int _selected = 0;

  Widget _bmiSummary() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(color: _summaryBg,
      borderRadius: BorderRadius.circular(16)),
    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Rekomendasi Gaya Hidup · Versi Awal',
        style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 13)),
      SizedBox(height: 7),
      Text('Konten contoh belum dipersonalisasi berdasarkan kategori BMI. Integrasi data dilakukan pada tahap berikutnya.',
        style: TextStyle(color: _muted, fontSize: 11.2, height: 1.4)),
    ]),
  );

  Widget _tabs() {
    const labels = ['Makanan', 'Aktivitas Fisik', 'Gaya Hidup'];
    return Row(
      children: List.generate(labels.length, (index) {
        final active = _selected == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 6),
            child: Semantics(
              button: true,
              selected: active,
              child: Material(
                color: active ? _blue : _soft,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _selected = index),
                  child: SizedBox(
                    height: 39,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(labels[index],
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 11.7,
                                color: active ? Colors.white : _muted,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _tip(LifestyleTip tip) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        constraints: const BoxConstraints(minHeight: 113),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: _border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                tip.asset,
                width: 72,
                height: 91,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 91,
                  color: _summaryBg,
                  child: const Icon(Icons.image_outlined, color: _blue),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tip.title,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 12.1,
                          height: 1.23,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 7),
                    Text(tip.description,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 10.6,
                          height: 1.42,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    const footers = [
      'Pilih makanan beragam dan sesuaikan porsinya dengan kebutuhan tubuh.',
      'Mulai perlahan sesuai kemampuan. Berhenti jika nyeri atau pusing; konsultasikan kondisi khusus dengan tenaga kesehatan.',
      'Saran umum untuk kebiasaan sehari-hari, bukan pengganti nasihat medis. Sesuaikan dengan kebutuhan dan kondisi pribadi.',
    ];
    final tips = switch (_selected) {
      0 => LifestyleTips.food.take(2).toList(),
      1 => LifestyleTips.activity.take(2).toList(),
      _ => LifestyleTips.lifestyle.take(2).toList(),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 65,
        leadingWidth: 51,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _blue, size: 23),
          tooltip: 'Kembali',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        titleSpacing: 0,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('Rekomendasi Gaya Hidup',
              style: TextStyle(
                  color: _ink, fontSize: 20, fontWeight: FontWeight.w800)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 630),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _bmiSummary(),
                const SizedBox(height: 16),
                _tabs(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    key: ValueKey<int>(_selected),
                    padding: const EdgeInsets.only(bottom: 18),
                    itemCount: tips.length + 1,
                    separatorBuilder: (_, index) =>
                        SizedBox(height: index == tips.length - 1 ? 16 : 12),
                    itemBuilder: (context, index) {
                      if (index == tips.length) {
                        return Text(
                          footers[_selected],
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10.4,
                            height: 1.5,
                          ),
                        );
                      }
                      return _tip(tips[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
