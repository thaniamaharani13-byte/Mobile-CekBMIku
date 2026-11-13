import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../models/models.dart';
import '../services/goal_store.dart';

/// UI Target BMIku / ProgressBMIku berdasarkan dua desain.
/// Navbar tetap di ShellScreen, terpisah dari scroll di halaman ini.
class TargetBmiScreen extends StatefulWidget {
  const TargetBmiScreen({super.key, this.showProgress = false});

  final bool showProgress;

  @override
  State<TargetBmiScreen> createState() => _TargetBmiScreenState();
}

class _TargetBmiScreenState extends State<TargetBmiScreen> {
  static const navy = Color(0xFF192F52);
  static const blue = Color(0xFF2962EF);
  static const muted = Color(0xFF788BAB);
  static const border = Color(0xFFDDE7F5);
  static const wash = Color(0xFFEDF3FF);

  final GoalStore _store = GoalStore();
  final TextEditingController _valueController = TextEditingController();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _deadlineDate;
  BmiGoal? _goal;
  bool _loading = true;
  bool _saving = false;

  String? get _email => context.read<AuthBloc>().state.user?.email;

  @override
  void initState() {
    super.initState();
    final email = _email;
    if (email == null) {
      _loading = false;
      return;
    }
    context.read<ProfileCubit>().load(email);
    _loadTarget(email);
  }

  Future<void> _loadTarget(String email) async {
    try {
      final loaded = await _store.getTarget(email);
      if (!mounted) return;
      setState(() {
        // Data target versi lama tetap dibaca, termasuk tanggal tersimpannya.
        _goal = loaded;
        _loading = false;
        if (loaded != null) {
          _startDate = _dayOnly(loaded.startDate);
          _deadlineDate = _dayOnly(loaded.deadline);
          if (loaded.kind == GoalKind.weight) {
            _valueController.text = _num(loaded.value, 1);
          }
        }
      });
    } catch (error) {
      // Gagal memuat data tidak boleh membuat halaman terus loading.
      debugPrint('CEKBMI TARGET: gagal membaca target: $error');
      if (!mounted) return;
      setState(() => _loading = false);
      _message('Target sebelumnya belum bisa dimuat. Silakan isi kembali.');
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  String _num(double value, [int decimals = 1]) =>
      value.toStringAsFixed(decimals).replaceAll('.', ',');

  String _dateLabel(DateTime date) {
    const months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _message(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  // Kalender Flutter menggunakan tanggal lokal tanpa jam agar perbandingan
  // tanggal mulai dan batas target konsisten di emulator Android.
  DateTime _dayOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime _laterOf(DateTime first, DateTime second) =>
      first.isAfter(second) ? first : second;

  // Satu fungsi kalender dipakai oleh kedua field. Semua batas dinormalisasi
  // dan initialDate selalu berada di antara firstDate dan lastDate; ini
  // menghindari assertion showDatePicker saat membaca tanggal lama.
  Future<DateTime?> _openTargetCalendar({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String title,
  }) async {
    final first = _dayOnly(firstDate);
    final last = _dayOnly(lastDate);
    if (first.isAfter(last)) {
      if (mounted) _message('Rentang tanggal tidak valid. Pilih tanggal mulai lagi.');
      return null;
    }
    final requested = _dayOnly(initialDate);
    final safeInitial = requested.isBefore(first)
        ? first
        : (requested.isAfter(last) ? last : requested);
    try {
      final chosen = await showDatePicker(
        context: context,
        initialDate: safeInitial,
        firstDate: first,
        lastDate: last,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        helpText: title,
        cancelText: 'Batal',
        confirmText: 'Pilih',
      );
      return chosen == null ? null : _dayOnly(chosen);
    } catch (error) {
      debugPrint('CEKBMI TARGET: kalender gagal dibuka: $error');
      if (mounted) _message('Kalender tidak bisa dibuka. Silakan coba lagi.');
      return null;
    }
  }

  Future<void> _selectStartDate() async {
    final today = _dayOnly(DateTime.now());
    final picked = await _openTargetCalendar(
      initialDate: _startDate,
      firstDate: DateTime(today.year - 5, 1, 1),
      lastDate: DateTime(today.year + 10, 12, 31),
      title: 'Pilih Tanggal Mulai',
    );
    if (!mounted || picked == null) return;
    setState(() {
      _startDate = picked;
      // Jika tenggat yang lama tidak lagi valid, minta pengguna memilih lagi.
      if (_deadlineDate != null && !_deadlineDate!.isAfter(picked)) {
        _deadlineDate = null;
      }
    });
  }

  Future<void> _selectDeadline() async {
    final today = _dayOnly(DateTime.now());
    // Tambahkan satu hari kalender, bukan 24 jam, untuk aman saat perubahan
    // offset zona waktu/daylight saving pada sebagian perangkat.
    final dayAfterStart = DateTime(
      _startDate.year, _startDate.month, _startDate.day + 1);
    final earliest = _laterOf(dayAfterStart, today);
    // Perluas batas akhir bila pengguna memilih tanggal mulai jauh ke depan.
    final latest = _laterOf(
      DateTime(today.year + 20, 12, 31),
      DateTime(earliest.year + 10, 12, 31),
    );
    final picked = await _openTargetCalendar(
      initialDate: _deadlineDate ??
          DateTime(_startDate.year, _startDate.month + 3, _startDate.day),
      firstDate: earliest,
      lastDate: latest,
      title: 'Pilih Batas Pencapaian Target',
    );
    if (!mounted || picked == null) return;
    setState(() => _deadlineDate = picked);
  }

  Future<void> _save(List<BmiResult> history) async {
    final number = double.tryParse(_valueController.text.trim().replaceAll(',', '.'));
    if (number == null || number < 10 || number > 300) {
      _message('Masukkan target berat badan antara 10–300 kg.');
      return;
    }
    if (_deadlineDate == null) {
      _message('Pilih batas pencapaian target terlebih dahulu.');
      return;
    }
    final today = DateTime.now();
    final dayStart = DateTime(today.year, today.month, today.day);
    if (!_deadlineDate!.isAfter(_startDate)) {
      _message('Batas pencapaian harus setelah tanggal mulai.');
      return;
    }
    if (_deadlineDate!.isBefore(dayStart)) {
      _message('Batas pencapaian tidak boleh berada di masa lalu.');
      return;
    }
    final email = _email;
    if (email == null) return;
    final sorted = [...history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latest = sorted.isEmpty ? null : sorted.first;
    // Titik awal progres diambil dari pemeriksaan paling awal yang berada
    // di dalam periode yang dipilih. Bila belum ada, tunggu pemeriksaan baru.
    final periodHistory = sorted.where((r) =>
        !r.createdAt.isBefore(_startDate) &&
        r.createdAt.isBefore(DateTime(_deadlineDate!.year,
            _deadlineDate!.month, _deadlineDate!.day + 1))).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final baseline = periodHistory.isEmpty ? null : periodHistory.first;
    final now = DateTime.now();
    final newGoal = BmiGoal(
      kind: GoalKind.weight,
      value: number,
      createdAt: now,
      startDate: _startDate,
      deadline: _deadlineDate!,
      baselineValue: baseline?.weightKg,
      heightAtCreation: baseline?.heightCm ?? latest?.heightCm,
    );
    setState(() => _saving = true);
    try {
      await _store.saveTarget(email, newGoal);
      if (!mounted) return;
      setState(() => _goal = newGoal);
      _message('Target berhasil disimpan di perangkat.');
    } catch (_) {
      if (mounted) _message('Target gagal disimpan. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _panel(Widget child, {Color color = Colors.white, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(19),
        border: color == Colors.white ? Border.all(color: border) : null,
      ),
      child: child,
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: wash, borderRadius: BorderRadius.circular(13)),
      child: Row(children: [
        _tab('Target BMI', !widget.showProgress, '/target'),
        _tab('ProgressBMIku', widget.showProgress, '/progress'),
      ]),
    );
  }

  Widget _tab(String label, bool active, String location) => Expanded(
    child: Material(
      color: active ? blue : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: active ? null : () => context.go(location),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              color: active ? Colors.white : muted),
          ),
        ),
      ),
    ),
  );

  Widget _sectionTitle(String text) => Text(text,
    style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 16));

  Widget _targetForm(List<BmiResult> history) {
    return _panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Target Berat Badan (kg)',
        style: TextStyle(color: muted, fontSize: 11.5, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      TextField(
        controller: _valueController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Contoh: 60',
          hintStyle: const TextStyle(color: blue, fontSize: 13),
          suffixText: 'kg',
          suffixStyle: const TextStyle(color: blue, fontSize: 12),
          filled: true,
          fillColor: wash,
          contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: blue)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: blue, width: 1.6)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      const SizedBox(height: 15),
      _datePickerField('Tanggal Mulai', _dateLabel(_startDate), _selectStartDate),
      const SizedBox(height: 13),
      _datePickerField('Batas Pencapaian Target',
        _deadlineDate == null ? 'Pilih tanggal target' : _dateLabel(_deadlineDate!),
        _selectDeadline),
      const SizedBox(height: 8),
      const Text('Periode pemantauan dimulai dari Tanggal Mulai hingga Batas Pencapaian Target.',
        style: TextStyle(color: muted, fontSize: 10.5, height: 1.4)),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          onPressed: _saving ? null : () => _save(history),
          style: FilledButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(_saving ? 'Menyimpan...' : 'Simpan Target',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        ),
      ),
    ]));
  }

  Widget _datePickerField(String label, String value, VoidCallback onTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: muted, fontSize: 11.5,
          fontWeight: FontWeight.w600)),
      const SizedBox(height: 7),
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 17, color: blue),
              const SizedBox(width: 9),
              Expanded(child: Text(value, style: const TextStyle(color: navy, fontSize: 12.5))),
              const Icon(Icons.keyboard_arrow_down, size: 20, color: blue),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _kv(String label, String value, {bool strong = true}) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: muted, fontSize: 11.5))),
      Flexible(child: Text(value, textAlign: TextAlign.right,
        style: TextStyle(color: navy, fontSize: 12, fontWeight: strong ? FontWeight.w800 : FontWeight.w500))),
    ]),
  );

  Widget _miniStat(String label, String value, {bool colored = false}) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
      decoration: BoxDecoration(
        color: colored ? blue : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: [
        Text(label, textAlign: TextAlign.center, maxLines: 2,
          style: TextStyle(color: colored ? const Color(0xFFDBE6FF) : muted, fontSize: 10)),
        const SizedBox(height: 4),
        FittedBox(fit: BoxFit.scaleDown,
          child: Text(value, style: TextStyle(color: colored ? Colors.white : navy,
            fontWeight: FontWeight.w800, fontSize: 18))),
      ]),
    ),
  );

  Widget _motivation(String message) => _panel(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Pesan Motivasi', style: TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 12)),
      const SizedBox(height: 10),
      Text(message, style: const TextStyle(color: muted, height: 1.55, fontSize: 11.5)),
    ],
  ));

  Widget _targetTab(List<BmiResult> history) {
    final goal = _goal;
    final records = goal == null ? <BmiResult>[] : GoalStore.recordsInPeriod(history, goal);
    final current = goal == null ? null : GoalStore.currentValue(records, goal.kind);
    final difference = current == null || goal == null ? null : (current - goal.value).abs();
    final progress = GoalStore.progressForTarget(history, goal);
    final isWeight = goal?.kind == GoalKind.weight;
    final unit = isWeight ? ' kg' : '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      const Text('Atur Target BMI', style: TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 22)),
      const SizedBox(height: 5),
      const Text('Tentukan target berat badan yang ingin kamu capai.',
        style: TextStyle(color: muted, fontSize: 12, height: 1.55)),
      const SizedBox(height: 19),
      _targetForm(history),
      const SizedBox(height: 18),
      _panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('ProgressBMIku', style: TextStyle(color: muted, fontSize: 11.5))),
          TextButton(onPressed: () => context.go('/progress'),
            child: const Text('Lihat Riwayat', style: TextStyle(color: blue, fontWeight: FontWeight.w800, fontSize: 12))),
        ]),
        const Text('Pantau perkembangan menuju target kamu', style: TextStyle(color: muted, fontSize: 11.5)),
        const SizedBox(height: 18),
        Row(children: [
          _metricText('Nilai Terkini', current == null ? '—' : '${_num(current)}$unit'),
          _metricText('Target', goal == null ? '—' : '${_num(goal.value)}$unit'),
          _metricText('Selisih', difference == null ? '—' : '${_num(difference)}$unit'),
        ]),
        const SizedBox(height: 17),
        Row(children: [
          const Text('Progress', style: TextStyle(color: muted, fontSize: 11)),
          const Spacer(),
          Text(goal == null || GoalStore.baselineForTarget(history, goal) == null ? '—' : '${(progress * 100).round()}%',
            style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(value: progress, minHeight: 7, backgroundColor: const Color(0xFFDEE7F8), color: blue)),
        const SizedBox(height: 13),
        Text(_status(goal, history, progress),
          style: const TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 11.5)),
        const SizedBox(height: 10),
        Text(goal == null ? 'Simpan target untuk memulai progres.' :
          current == null ? 'Hitung BMI pertama kali agar progres dapat dipantau.' :
          'Selisih menuju targetmu ${_num(difference!)}$unit. Tetap semangat!',
          style: const TextStyle(color: muted, fontSize: 11, height: 1.5)),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 9),
          Text('Terakhir diperiksa: ${_dateLabel(_sorted(history).first.createdAt)}',
            style: const TextStyle(color: muted, fontSize: 10.5)),
        ],
      ])),
      const SizedBox(height: 18),
      _motivation('Setiap langkah kecil tetap membawamu lebih dekat ke tujuan. Ayo terus konsisten!'),
    ]);
  }

  Widget _metricText(String label, String value) => Expanded(child: Column(children: [
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: navy, fontSize: 10)),
    const SizedBox(height: 6),
    FittedBox(fit: BoxFit.scaleDown,
      child: Text(value, style: const TextStyle(color: navy, fontSize: 19, fontWeight: FontWeight.w800))),
  ]));

  List<BmiResult> _sorted(List<BmiResult> history) =>
      [...history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  String _status(BmiGoal? goal, List<BmiResult> history, double progress) {
    if (goal == null) return 'Belum Ada Target';
    final records = GoalStore.recordsInPeriod(history, goal);
    if (records.isEmpty || GoalStore.baselineForTarget(history, goal) == null) return 'Menunggu Pemeriksaan';
    final current = GoalStore.currentValue(records, goal.kind)!;
    final change = goal.value - GoalStore.baselineForTarget(history, goal)!;
    if (change.abs() < 0.01 || (change < 0 && current <= goal.value) ||
        (change > 0 && current >= goal.value)) return 'Target Tercapai!';
    if (progress >= 0.8) return 'Hampir Tercapai';
    if (progress >= 0.4) return 'Terus Maju';
    return 'Masih Banyak';
  }

  Widget _progressRing(double progress, {required bool hasData}) {
    return SizedBox(
      width: 166, height: 166,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox.expand(child: CircularProgressIndicator(
          value: hasData ? progress : 0,
          strokeWidth: 4,
          backgroundColor: const Color(0xFFCCDAF3),
          color: blue,
          strokeCap: StrokeCap.round,
        )),
        Padding(padding: const EdgeInsets.all(9), child: SizedBox.expand(
          child: CircularProgressIndicator(
            value: hasData ? progress : 0,
            strokeWidth: 3,
            backgroundColor: const Color(0xFFDAE5FA),
            color: blue,
            strokeCap: StrokeCap.round,
          ),
        )),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(hasData ? '${(progress * 100).round()}%' : '—',
            style: const TextStyle(color: blue, fontSize: 37, fontWeight: FontWeight.w800)),
          const Text('Progress', style: TextStyle(color: muted, fontSize: 11.5)),
        ]),
      ]),
    );
  }

  Widget _progressTab(List<BmiResult> history) {
    final goal = _goal;
    final progress = GoalStore.progressForTarget(history, goal);
    final periodHistory = goal == null ? <BmiResult>[] : GoalStore.recordsInPeriod(history, goal);
    final current = goal == null ? null : GoalStore.currentValue(periodHistory, goal.kind);
    final delta = current == null || goal == null ? null : (goal.value - current).abs();
    final unit = goal?.kind == GoalKind.weight ? ' kg' : '';
    final bmi = goal?.targetBmi;
    final hasData = GoalStore.baselineForTarget(history, goal) != null;
    return Column(children: [
      const SizedBox(height: 20),
      _panel(Column(children: [
        const Text('Progress Menuju Target', style: TextStyle(color: muted, fontSize: 12)),
        const SizedBox(height: 2),
        const Text('Pantau perkembangan target kamu', style: TextStyle(color: blue, fontSize: 11)),
        const SizedBox(height: 9),
        Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(30)),
          child: Text(_status(goal, history, progress),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10.5))),
        const SizedBox(height: 24),
        _progressRing(progress, hasData: hasData),
        const SizedBox(height: 25),
        Row(children: [
          _miniStat('Saat Ini', current == null ? '—' : '${_num(current)}$unit'),
          const SizedBox(width: 7),
          _miniStat('Target', goal == null ? '—' : '${_num(goal.value)}$unit'),
          const SizedBox(width: 7),
          _miniStat('Selisih', delta == null ? '—' : '${_num(delta)}$unit', colored: true),
        ]),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft,
          child: Text(goal == null
              ? 'Belum ada target. Buka tab Target BMI untuk menyimpannya.'
              : current == null
                ? 'Belum ada data pemeriksaan. Hitung BMI untuk memulai.'
                : 'Target ${goal.kind == GoalKind.weight ? 'berat badan' : 'BMI'} masih tersisa ${_num(delta!)}$unit.',
            style: const TextStyle(color: muted, fontSize: 11.5, height: 1.5))),
      ]), color: wash, padding: const EdgeInsets.all(20)),
      const SizedBox(height: 18),
      _panel(Column(children: [
        Row(children: [
          const Expanded(child: Text('Informasi Target', style: TextStyle(color: muted, fontSize: 11.5))),
          TextButton(onPressed: () => context.go('/target'),
            child: const Text('Ubah Target', style: TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 12))),
        ]),
        const SizedBox(height: 3),
        _kv('Jenis Target', goal == null ? '—' : (goal.kind == GoalKind.weight ? 'Berat Badan' : 'BMI')),
        _kv('Target ${goal?.kind == GoalKind.weight ? 'Berat Badan' : 'BMI'}', goal == null ? '—' : '${_num(goal.value)}$unit'),
        _kv('Target BMI', bmi == null ? '—' : _num(bmi)),
        _kv('Tanggal Mulai', goal == null ? '—' : _dateLabel(goal.startDate)),
        _kv('Batas Pencapaian', goal == null ? '—' : _dateLabel(goal.deadline)),
      ])),
      const SizedBox(height: 18),
      _panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Grafik Perkembangan'),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.show_chart, color: blue, size: 17),
          const SizedBox(width: 6),
          const Text('Nilai BMI', style: TextStyle(color: blue, fontSize: 11)),
          if (bmi != null) ...[
            const SizedBox(width: 8),
            Expanded(child: Text('— Target BMI (${_num(bmi)})', maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: blue, fontSize: 10.5))),
          ],
        ]),
        const SizedBox(height: 8),
        SizedBox(height: 191, width: double.infinity,
          child: periodHistory.isEmpty
            ? const Center(child: Text('Belum ada pemeriksaan pada periode target.',
                textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 11.5)))
            : CustomPaint(painter: _TargetLinePainter(periodHistory, bmi), child: const SizedBox.expand())),
        if (periodHistory.length == 1) const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text('Tambahkan pemeriksaan BMI untuk melihat garis perkembangan.',
            style: TextStyle(color: muted, fontSize: 10.5)),
        ),
      ])),
      const SizedBox(height: 18),
      _motivation('Terus jaga pola makan dan rutin berolahraga agar targetmu segera tercapai!'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ProfileCubit>().state.history;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 630),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: blue))
            : ListView(
                padding: const EdgeInsets.fromLTRB(24, 7, 24, 32),
                children: [
                  _tabs(),
                  if (widget.showProgress) _progressTab(history) else _targetTab(history),
                ],
              ),
      ),
    );
  }
}

class _TargetLinePainter extends CustomPainter {
  _TargetLinePainter(this.history, this.targetBmi);

  final List<BmiResult> history;
  final double? targetBmi;
  static const blue = Color(0xFF2962EF);
  static const muted = Color(0xFF788BAB);
  static const grid = Color(0xFFDEE7F3);

  @override
  void paint(Canvas canvas, Size size) {
    final data = [...history]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final shown = data.length <= 7 ? data : data.sublist(data.length - 7);
    if (shown.isEmpty) return;
    final values = shown.map((e) => e.bmi).toList();
    final allValues = [...values, if (targetBmi != null) targetBmi!];
    double min = allValues.reduce(math.min);
    double max = allValues.reduce(math.max);
    final span = math.max(4.0, max - min);
    min -= span * 0.25;
    max += span * 0.25;

    const left = 31.0;
    const top = 7.0;
    const bottom = 28.0;
    final width = math.max(1.0, size.width - left - 6);
    final height = math.max(1.0, size.height - top - bottom);
    double y(double v) => top + height * (1 - (v - min) / (max - min));

    for (var i = 0; i < 4; i++) {
      final gridY = top + height * i / 3;
      canvas.drawLine(Offset(left, gridY), Offset(size.width - 6, gridY),
        Paint()..color = grid..strokeWidth = 1);
      _text(canvas, (max - (max - min) * i / 3).toStringAsFixed(0),
        Offset(1, gridY - 7), 10, muted);
    }
    if (targetBmi != null) {
      final yTarget = y(targetBmi!);
      final pen = Paint()..color = blue..strokeWidth = 1.5;
      for (double x = left; x < size.width - 6; x += 8) {
        canvas.drawLine(Offset(x, yTarget), Offset(math.min(x + 4, size.width - 6), yTarget), pen);
      }
    }

    final coords = <Offset>[];
    for (var i = 0; i < shown.length; i++) {
      final x = left + (shown.length == 1 ? width / 2 : width * i / (shown.length - 1));
      coords.add(Offset(x, y(shown[i].bmi)));
    }
    final pen = Paint()..color = blue..strokeWidth = 2.5..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(coords.first.dx, coords.first.dy);
    for (var i = 1; i < coords.length; i++) {
      path.lineTo(coords[i].dx, coords[i].dy);
    }
    canvas.drawPath(path, pen);
    for (var i = 0; i < coords.length; i++) {
      canvas.drawCircle(coords[i], 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(coords[i], 2.5, Paint()..color = blue);
      final d = shown[i].createdAt;
      const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
      final label = '${d.day} ${months[d.month - 1]}';
      final tp = TextPainter(text: TextSpan(text: label,
          style: const TextStyle(color: muted, fontSize: 9)),
        textDirection: TextDirection.ltr, maxLines: 1)..layout();
      tp.paint(canvas, Offset((coords[i].dx - tp.width / 2).clamp(0, size.width - tp.width).toDouble(), size.height - 18));
    }
  }

  void _text(Canvas canvas, String value, Offset location, double size, Color color) {
    final painter = TextPainter(text: TextSpan(text: value,
        style: TextStyle(color: color, fontSize: size)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, location);
  }

  @override
  bool shouldRepaint(covariant _TargetLinePainter oldDelegate) =>
      oldDelegate.targetBmi != targetBmi || oldDelegate.history != history;
}
