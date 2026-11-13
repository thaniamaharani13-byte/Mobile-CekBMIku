import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../data/app_content.dart';
import '../models/models.dart';
import '../services/goal_store.dart';
import '../widgets/bmi_chart.dart';
import '../widgets/common_widgets.dart';

enum HealthFeature { history, progress, target, reminders, notifications }

/// Halaman pendukung tautan pada Beranda: riwayat, grafik, target, dan lainnya.
class HealthFeatureScreen extends StatefulWidget {
  const HealthFeatureScreen({super.key, required this.feature});
  final HealthFeature feature;

  @override
  State<HealthFeatureScreen> createState() => _HealthFeatureScreenState();
}

class _HealthFeatureScreenState extends State<HealthFeatureScreen> {
  static const _navy = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);

  final _store = GoalStore();
  final _goalInput = TextEditingController();
  double? _goal;
  bool _reminder = false;
  bool _loading = true;

  String? get _email => context.read<AuthBloc>().state.user?.email;

  @override
  void initState() {
    super.initState();
    final email = _email;
    if (email != null) {
      context.read<ProfileCubit>().load(email);
      _load(email);
    } else {
      _loading = false;
    }
  }

  Future<void> _load(String email) async {
    final goal = await _store.getGoal(email);
    final reminder = await _store.getReminder(email);
    if (!mounted) return;
    setState(() {
      _goal = goal;
      _reminder = reminder;
      _loading = false;
      if (goal != null) _goalInput.text = goal.toStringAsFixed(1);
    });
  }

  @override
  void dispose() {
    _goalInput.dispose();
    super.dispose();
  }

  String _display(double n) => n.toStringAsFixed(1).replaceAll('.', ',');

  Future<void> _saveGoal() async {
    final newValue = double.tryParse(_goalInput.text.trim().replaceAll(',', '.'));
    if (newValue == null || newValue < 10 || newValue > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan target BMI antara 10 sampai 60.')),
      );
      return;
    }
    final email = _email;
    if (email == null) return;
    await _store.setGoal(email, newValue);
    if (!mounted) return;
    setState(() => _goal = newValue);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Target BMI tersimpan di perangkat.')),
    );
  }

  Future<void> _setReminder(bool enabled) async {
    final email = _email;
    if (email == null) return;
    await _store.setReminder(email, enabled);
    if (!mounted) return;
    setState(() => _reminder = enabled);
  }

  Widget _card(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _border),
    ),
    child: child,
  );

  Widget _intro(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: _navy, fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 7),
      Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12.5, height: 1.5)),
      const SizedBox(height: 19),
    ],
  );

  Widget _entry(BmiResult item) => _card(
    Row(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFEDF3FF), borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.monitor_heart_outlined, color: _blue),
      ),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('BMI ${_display(item.bmi)} · ${item.category}',
          style: const TextStyle(color: _navy, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${_display(item.weightKg)} kg · ${item.heightCm.toStringAsFixed(0)} cm',
          style: const TextStyle(color: _muted, fontSize: 11.5)),
        Text(formatDate(item.createdAt),
          style: const TextStyle(color: _muted, fontSize: 11)),
      ])),
    ]),
  );

  Widget _history(List<BmiResult> history) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _intro('Riwayat BMI', 'Pantau hasil pemeriksaan BMI yang sudah kamu simpan.'),
      if (history.isEmpty) _card(const Text('Belum ada riwayat. Mulai dengan menghitung BMI.',
        style: TextStyle(color: _muted)))
      else ...history.map(_entry),
      const SizedBox(height: 10),
      FilledButton(
        onPressed: () => context.push('/calculator'),
        style: FilledButton.styleFrom(backgroundColor: _blue),
        child: const Text('Hitung BMI Sekarang'),
      ),
    ],
  );

  Widget _progress(List<BmiResult> history) {
    final percent = (GoalStore.progress(history, _goal) * 100).round();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _intro('Grafik Perkembangan', 'Perkembangan BMI dari hasil perhitungan yang tersimpan.'),
      _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Tren BMI', style: TextStyle(color: _navy, fontWeight: FontWeight.w800)),
        const SizedBox(height: 9),
        BmiChart(items: history),
      ])),
      _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Progres Menuju Target', style: TextStyle(color: _navy, fontWeight: FontWeight.w800)),
          Text('$percent%', style: const TextStyle(color: _blue, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: percent / 100, minHeight: 7, backgroundColor: const Color(0xFFDFE8F8),
          color: _blue, borderRadius: BorderRadius.circular(12)),
        const SizedBox(height: 11),
        Text(_goal == null
          ? 'Tetapkan target BMI terlebih dahulu.'
          : history.length < 2
            ? 'Dibutuhkan minimal dua pengukuran untuk menghitung progres.'
            : 'Target BMI ${_display(_goal!)}. Progres dihitung dari perubahan BMI pertama hingga terbaru.',
          style: const TextStyle(fontSize: 11, color: _muted, height: 1.45)),
      ])),
      TextButton.icon(
        onPressed: () => context.push('/target').then((_) {
          if (mounted && _email != null) _load(_email!);
        }),
        icon: const Icon(Icons.track_changes), label: const Text('Atur Target BMI'),
      ),
    ]);
  }

  Widget _target() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _intro('Target BMI', 'Tentukan target BMI pribadimu agar perkembangan bisa dipantau.'),
    _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_goal != null) ...[
        Text('Target tersimpan: ${_display(_goal!)}',
          style: const TextStyle(color: _blue, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 15),
      ],
      const Text('Masukkan target BMI', style: TextStyle(color: _navy, fontWeight: FontWeight.w700)),
      const SizedBox(height: 9),
      TextField(
        controller: _goalInput,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(hintText: 'Contoh: 22,0', prefixIcon: Icon(Icons.track_changes)),
      ),
      const SizedBox(height: 15),
      SizedBox(width: double.infinity, child: FilledButton(
        onPressed: _saveGoal,
        style: FilledButton.styleFrom(backgroundColor: _blue),
        child: const Text('Simpan Target'),
      )),
    ])),
    const Text('Target ini merupakan alat pencatatan pribadi, bukan rekomendasi medis. Untuk target yang sesuai kondisi kesehatanmu, konsultasikan dengan tenaga kesehatan.',
      style: TextStyle(color: _muted, fontSize: 11.5, height: 1.5)),
  ]);

  Widget _reminders() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _intro('Pengingat', 'Simpan pilihan pengingat pemeriksaan BMI di aplikasi.'),
    _card(SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      value: _reminder,
      activeColor: _blue,
      onChanged: _setReminder,
      title: const Text('Aktifkan pengingat', style: TextStyle(color: _navy, fontWeight: FontWeight.w700)),
      subtitle: const Text('Preferensi tersimpan secara lokal di perangkat.'),
    )),
    const Text('Catatan: versi ini belum menjadwalkan notifikasi sistem atau push notification.',
      style: TextStyle(color: _muted, fontSize: 11.5, height: 1.5)),
  ]);

  Widget _notifications() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _intro('Notifikasi', 'Informasi terbaru tentang aktivitas CekBMIku.'),
    _card(const Row(children: [
      Icon(Icons.notifications_none, color: _blue),
      SizedBox(width: 12),
      Expanded(child: Text('Belum ada notifikasi baru.', style: TextStyle(color: _muted))),
    ])),
    if (_reminder) const Text('Pengaturan pengingat lokal sedang aktif.', style: TextStyle(color: _muted)),
  ]);

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().state;
    final history = [...profile.history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 630),
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              children: [
                switch (widget.feature) {
                  HealthFeature.history => _history(history),
                  HealthFeature.progress => _progress(history),
                  HealthFeature.target => _target(),
                  HealthFeature.reminders => _reminders(),
                  HealthFeature.notifications => _notifications(),
                },
              ],
            ),
      ),
    );
  }
}
