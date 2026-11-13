import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../models/models.dart';

/// Riwayat BMI dengan grafik yang membaca pemeriksaan pengguna yang sebenarnya.
class BmiHistoryScreen extends StatefulWidget {
  const BmiHistoryScreen({super.key});

  @override
  State<BmiHistoryScreen> createState() => _BmiHistoryScreenState();
}

class _BmiHistoryScreenState extends State<BmiHistoryScreen> {
  static const navy = Color(0xFF192F52);
  static const blue = Color(0xFF2962EF);
  static const muted = Color(0xFF788BAB);
  static const border = Color(0xFFDDE7F5);

  String _period = '6';
  String _metric = 'bmi';
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthBloc>().state.user?.email;
    if (email != null) context.read<ProfileCubit>().load(email);
  }

  String _number(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

  List<BmiResult> _filtered(List<BmiResult> history) {
    final sorted = List<BmiResult>.of(history)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (_period == 'all') return sorted;
    final months = int.parse(_period);
    final now = DateTime.now();
    final from = DateTime(now.year, now.month - months + 1, 1);
    return sorted.where((r) => !r.createdAt.isBefore(from) && !r.createdAt.isAfter(now)).toList();
  }

  Widget _historyTile(BmiResult r) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => context.push('/result', extra: r),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), border: Border.all(color: border)),
            child: Row(children: [
              SizedBox(
                width: 64,
                child: Column(children: [
                  Text('${r.createdAt.day}'.padLeft(2, '0'),
                    style: const TextStyle(color: blue, fontSize: 25, fontWeight: FontWeight.w800, height: 1.05)),
                  const SizedBox(height: 4),
                  Text('${months[r.createdAt.month - 1]} ${r.createdAt.year}',
                    style: const TextStyle(color: muted, fontSize: 10)),
                ]),
              ),
              Container(width: 1, height: 54, color: border, margin: const EdgeInsets.symmetric(horizontal: 11)),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('BMI: ${_number(r.bmi)}', style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 5),
                Text('Tinggi: ${r.heightCm.toStringAsFixed(0)} cm  |  Berat: ${_number(r.weightKg)} kg',
                  style: const TextStyle(color: muted, fontSize: 10.5)),
                const SizedBox(height: 5),
                Text('Kategori: ${_categoryLabel(r.category)}', style: const TextStyle(color: navy, fontSize: 10.5)),
              ])),
              const Icon(Icons.chevron_right, color: blue, size: 21),
            ]),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String value) {
    if (value == 'Kelebihan Berat Badan') return 'Berat badan lebih';
    if (value == 'Kurus') return 'Berat badan kurang';
    return value;
  }

  Widget _selector({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> options,
    required ValueChanged<String?> onChanged,
  }) => Expanded(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: muted)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 19, color: blue),
        style: const TextStyle(color: navy, fontSize: 11.5),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: blue)),
        ),
        items: options,
        onChanged: onChanged,
      ),
    ]),
  );

  Widget _chartCard(List<BmiResult> selected) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(19)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Grafik Perkembangan', style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.show_chart, size: 16, color: blue),
          const SizedBox(width: 6),
          Text(_metric == 'bmi' ? 'Nilai BMI' : 'Berat badan (kg)', style: const TextStyle(color: blue, fontSize: 11)),
        ]),
        const SizedBox(height: 7),
        SizedBox(
          height: 185,
          width: double.infinity,
          child: selected.isEmpty
            ? const Center(child: Text('Belum ada pemeriksaan dalam periode ini.',
                textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)))
            : CustomPaint(
                painter: _HistoryLineChart(data: selected, useBmi: _metric == 'bmi'),
                child: const SizedBox.expand(),
              ),
        ),
        if (selected.length == 1)
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Text('Tambahkan pemeriksaan lagi untuk melihat perubahan.', style: TextStyle(fontSize: 10, color: muted)),
          ),
        const SizedBox(height: 13),
        Row(children: [
          _selector(
            label: 'Periode', value: _period,
            options: const [
              DropdownMenuItem(value: '3', child: Text('3 Bulan Terakhir')),
              DropdownMenuItem(value: '6', child: Text('6 Bulan Terakhir')),
              DropdownMenuItem(value: '12', child: Text('12 Bulan Terakhir')),
              DropdownMenuItem(value: 'all', child: Text('Semua Data')),
            ],
            onChanged: (v) { if (v != null) setState(() => _period = v); },
          ),
          const SizedBox(width: 12),
          _selector(
            label: 'Tampilkan', value: _metric,
            options: const [
              DropdownMenuItem(value: 'bmi', child: Text('Nilai BMI')),
              DropdownMenuItem(value: 'weight', child: Text('Berat Badan')),
            ],
            onChanged: (v) { if (v != null) setState(() => _metric = v); },
          ),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthBloc>().state.user?.email;
    final profile = context.watch<ProfileCubit>().state;
    final all = profile.history.where((item) => item.userEmail == email).toList();
    final selected = _filtered(all);
    final displayed = List<BmiResult>.of(all)..sort((a, b) => _newestFirst
      ? b.createdAt.compareTo(a.createdAt)
      : a.createdAt.compareTo(b.createdAt));

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 630),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          children: [
            const Text('Perjalanan sehatmu', style: TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 25)),
            const SizedBox(height: 4),
            const Text('Pantau perubahan BMI dari waktu ke waktu.', style: TextStyle(color: muted, fontSize: 12.5)),
            const SizedBox(height: 20),
            _chartCard(selected),
            const SizedBox(height: 21),
            Row(children: [
              const Expanded(child: Text('Riwayat Pemeriksaan', style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w800))),
              PopupMenuButton<bool>(
                tooltip: 'Urutkan riwayat',
                onSelected: (value) => setState(() => _newestFirst = value),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: true, child: Text('Terbaru dahulu')),
                  PopupMenuItem(value: false, child: Text('Terlama dahulu')),
                ],
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.sort, color: blue, size: 16),
                  SizedBox(width: 5),
                  Text('Urutkan', style: TextStyle(color: blue, fontSize: 11)),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            if (displayed.isEmpty)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(17)),
                child: Column(children: [
                  const Icon(Icons.assignment_outlined, size: 36, color: blue),
                  const SizedBox(height: 9),
                  const Text('Belum ada riwayat pemeriksaan', style: TextStyle(color: navy, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  const Text('Mulai menghitung BMI agar perkembanganmu tercatat.', textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 11.5)),
                  const SizedBox(height: 13),
                  TextButton(onPressed: () => context.go('/calculator'), child: const Text('Mulai Cek BMI')),
                ]),
              )
            else ...displayed.map(_historyTile),
            const SizedBox(height: 12),
            const Text('BMI adalah indikator awal, bukan diagnosis medis.',
              style: TextStyle(color: muted, fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}

class _HistoryLineChart extends CustomPainter {
  _HistoryLineChart({required this.data, required this.useBmi});
  final List<BmiResult> data;
  final bool useBmi;
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);

  @override
  void paint(Canvas canvas, Size size) {
    // Ambil pengukuran terakhir setiap bulan, hanya dari data pengguna.
    final byMonth = <int, BmiResult>{};
    for (final r in data) {
      final key = r.createdAt.year * 12 + r.createdAt.month;
      final existing = byMonth[key];
      if (existing == null || existing.createdAt.isBefore(r.createdAt)) byMonth[key] = r;
    }
    final monthly = byMonth.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final pointsData = monthly.length > 12 ? monthly.sublist(monthly.length - 12) : monthly;
    if (pointsData.isEmpty) return;
    final vals = pointsData.map((r) => useBmi ? r.bmi : r.weightKg).toList();
    double minVal = vals.reduce(math.min);
    double maxVal = vals.reduce(math.max);
    final padding = math.max(1.0, (maxVal - minVal) * .25);
    minVal = math.max(0, minVal - padding);
    maxVal += padding;
    if (maxVal - minVal < 0.01) maxVal = minVal + 2;

    const left = 32.0;
    const top = 5.0;
    const bottom = 30.0;
    const right = 9.0;
    final width = math.max(1.0, size.width - left - right);
    final height = math.max(1.0, size.height - top - bottom);
    final grid = Paint()..color = const Color(0xFFDDE7F5)..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = top + height * i / 3;
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), grid);
      _write(canvas, (maxVal - (maxVal - minVal) * i / 3).toStringAsFixed(0),
        Offset(0, y - 7), 10, _muted);
    }
    final plot = <Offset>[];
    for (var i = 0; i < pointsData.length; i++) {
      final x = left + (pointsData.length == 1 ? width / 2 : width * i / (pointsData.length - 1));
      final y = top + height * (1 - (vals[i] - minVal) / (maxVal - minVal));
      plot.add(Offset(x, y));
    }
    if (plot.length > 1) {
      final path = Path()..moveTo(plot.first.dx, plot.first.dy);
      for (final p in plot.skip(1)) path.lineTo(p.dx, p.dy);
      canvas.drawPath(path, Paint()..color = _blue..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    }
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    for (var i = 0; i < plot.length; i++) {
      canvas.drawCircle(plot[i], 3.8, Paint()..color = _blue);
      canvas.drawCircle(plot[i], 1.2, Paint()..color = Colors.white);
      final label = months[pointsData[i].createdAt.month - 1];
      // Hindari label tumpang tindih untuk data 7–12 bulan di HP kecil.
      if (plot.length <= 6 || i % 2 == 0 || i == plot.length - 1) {
        _write(canvas, label, Offset(plot[i].dx - 9, size.height - 19), 9.5, _muted);
      }
    }
  }

  void _write(Canvas canvas, String value, Offset point, double fontSize, Color color) {
    final painter = TextPainter(text: TextSpan(text: value, style: TextStyle(color: color, fontSize: fontSize)), textDirection: TextDirection.ltr)
      ..layout();
    painter.paint(canvas, point);
  }

  @override
  bool shouldRepaint(covariant _HistoryLineChart oldDelegate) => oldDelegate.useBmi != useBmi || oldDelegate.data != data;
}
