import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/bmi/bmi_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../core/broca_calculator.dart';
import '../data/app_content.dart';
import '../data/editorial_articles.dart';
import '../models/models.dart';

/// Kalkulator BMI dengan hasil langsung di halaman (bukan pindah ke route lain).
/// Navbar tetap berada di ShellScreen ketika halaman ini digulir.
class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  static const _navy = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _pale = Color(0xFFEDF3FF);

  final _height = TextEditingController();
  final _weight = TextEditingController();
  String _gender = 'L';
  BmiResult? _currentResult;

  @override
  void initState() {
    super.initState();
    // Preview Broca diperbarui langsung saat tinggi/berat diubah.
    _height.addListener(_refreshPreview);
    _weight.addListener(_refreshPreview);
    final user = context.read<AuthBloc>().state.user;
    if (user != null && (user.gender == 'L' || user.gender == 'P')) {
      _gender = user.gender;
    }
    if (user != null) context.read<ProfileCubit>().load(user.email);
  }

  void _refreshPreview() {
    if (mounted) setState(() {});
  }

  double? _readNumber(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));




  @override
  void dispose() {
    _height.removeListener(_refreshPreview);
    _weight.removeListener(_refreshPreview);
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    context.read<BmiBloc>().add(BmiCalculateRequested(
      heightText: _height.text.trim(),
      weightText: _weight.text.trim(),
      gender: _gender,
      userEmail: context.read<AuthBloc>().state.user?.email,
    ));
  }

  String _decimal(double n) => n.toStringAsFixed(1).replaceAll('.', ',');

  Widget _fieldLabel(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(color: _navy, fontSize: 13, fontWeight: FontWeight.w700)),
  );

  Widget _input(TextEditingController controller, String example, String unit) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSubmitted: (_) => _calculate(),
      style: const TextStyle(color: _navy, fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: example,
        hintStyle: const TextStyle(color: _navy, fontWeight: FontWeight.w600, fontSize: 15),
        suffixText: unit,
        suffixStyle: const TextStyle(color: _muted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _blue, width: 1.4)),
      ),
    );
  }

  Widget _card({required Widget child, Color color = Colors.white}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(19),
      border: color == Colors.white ? Border.all(color: _border) : null,
    ),
    child: child,
  );

  Color _categoryColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF8EC1FF);
    if (bmi < 25) return const Color(0xFF57DCAE);
    if (bmi < 30) return const Color(0xFFFFD775);
    return const Color(0xFFFF9EA6);
  }

  String _categoryText(String category) {
    if (category == 'Kurus') return 'Berat badan kurang';
    if (category == 'Kelebihan Berat Badan') return 'Berat badan lebih';
    return category;
  }

  String _interpretation(BmiResult item) {
    if (item.bmi < 18.5) return 'BMI berada di bawah rentang referensi dewasa. Pastikan kebutuhan energi dan gizimu tercukupi.';
    if (item.bmi < 25) return 'BMI berada dalam rentang referensi normal untuk dewasa. Pertahankan pola makan dan aktivitas sehat!';
    if (item.bmi < 30) return 'BMI berada di atas rentang referensi normal. Pertimbangkan kebiasaan makan dan aktivitas yang sesuai.';
    return 'BMI berada pada kategori obesitas. Diskusikan kebutuhan kesehatan pribadi dengan tenaga kesehatan.';
  }

  Widget _resultCard(BmiResult item) {
    final badgeColor = _categoryColor(item.bmi);
    return _card(
      color: _pale,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Hasil Perhitungan', style: TextStyle(color: _navy, fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 13),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 1,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_decimal(item.bmi), style: const TextStyle(fontSize: 43, fontWeight: FontWeight.w900, color: _blue, height: 1.12)),
              const Text('Indeks Massa Tubuh', style: TextStyle(color: _muted, fontSize: 10.5)),
            ]),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(color: badgeColor.withOpacity(.23), borderRadius: BorderRadius.circular(22)),
                child: Text(_categoryText(item.category), style: const TextStyle(color: Color(0xFF086A55), fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 6),
              Text(_interpretation(item), style: const TextStyle(fontSize: 11, height: 1.5, color: _muted)),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(children: const [
            Expanded(flex: 17, child: ColoredBox(color: Color(0xFF8EC1FF), child: SizedBox(height: 10))),
            Expanded(flex: 17, child: ColoredBox(color: Color(0xFF57DCAE), child: SizedBox(height: 10))),
            Expanded(flex: 11, child: ColoredBox(color: Color(0xFFFFD775), child: SizedBox(height: 10))),
            Expanded(flex: 20, child: ColoredBox(color: Color(0xFFFF9EA6), child: SizedBox(height: 10))),
          ]),
        ),
        const SizedBox(height: 5),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('17,0', style: TextStyle(color: _muted, fontSize: 9)),
          Text('18,5', style: TextStyle(color: _muted, fontSize: 9)),
          Text('25,0', style: TextStyle(color: _muted, fontSize: 9)),
          Text('30,0', style: TextStyle(color: _muted, fontSize: 9)),
          Text('40,0+', style: TextStyle(color: _muted, fontSize: 9)),
        ]),
        const SizedBox(height: 12),
        Text('Tinggi Badan: ${item.heightCm.toStringAsFixed(0)} cm  ·  Berat Badan: ${_decimal(item.weightKg)} kg',
          style: const TextStyle(color: _muted, fontSize: 10.5)),
        Text('BMI: ${_decimal(item.bmi)}  ·  Kategori: ${_categoryText(item.category)}',
          style: const TextStyle(color: _muted, fontSize: 10.5)),
        const SizedBox(height: 7),
        const Text('Nilai BMI memakai tinggi dan berat. Pilihan Pria/Wanita mengubah estimasi Broca di bawah.',
          style: TextStyle(color: _muted, fontSize: 10.5, height: 1.4)),
      ]),
    );
  }

  /// Kartu hasil mengikuti PILIHAN tombol saat ini, bukan item.gender yang
  /// berasal dari riwayat sebelumnya. Tekan Hitung BMI untuk menyimpan.
  Widget _brocaCard(BmiResult item) {
    final isMale = _gender == 'L';
    final typedHeight = _readNumber(_height.text);
    final typedWeight = _readNumber(_weight.text);
    final heightCm = typedHeight ?? item.heightCm;
    final weightKg = typedWeight ?? item.weightKg;
    final idealWeight = BrocaCalculator.estimate(
      heightCm: heightCm,
      gender: _gender,
    );

    if (idealWeight == null) {
      return _card(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimasi Berat Badan Ideal',
                style: TextStyle(color: _navy, fontSize: 14, fontWeight: FontWeight.w800)),
            SizedBox(height: 9),
            Text('Rumus Broca tidak ditampilkan untuk tinggi badan 100 cm atau kurang. Hasil BMI tetap tersedia.',
                style: TextStyle(color: _muted, fontSize: 11, height: 1.5)),
          ],
        ),
      );
    }

    final difference = (weightKg - idealWeight).abs();
    final changedSinceSaved = item.gender != _gender ||
        (heightCm - item.heightCm).abs() > 0.001 ||
        (weightKg - item.weightKg).abs() > 0.001;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.monitor_weight_outlined, color: _blue, size: 23),
            SizedBox(width: 9),
            Expanded(child: Text('Estimasi Berat Badan Ideal',
                style: TextStyle(color: _navy, fontSize: 14, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(color: _pale, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimasi sesuai pilihan',
                      style: TextStyle(color: _muted, fontSize: 11)),
                  const SizedBox(height: 5),
                  Text(isMale ? 'Pria' : 'Wanita',
                      style: const TextStyle(color: _navy, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              )),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${_decimal(idealWeight)} kg',
                    style: const TextStyle(color: _blue, fontSize: 26, fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
          const Divider(height: 22, color: _border),
          Row(children: [
            const Expanded(child: Text('Berat badan saat ini',
                style: TextStyle(color: _muted, fontSize: 11))),
            Text('${_decimal(weightKg)} kg',
                style: const TextStyle(color: _navy, fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 7),
          Row(children: [
            const Expanded(child: Text('Selisih dari estimasi ideal',
                style: TextStyle(color: _muted, fontSize: 11))),
            Text('${_decimal(difference)} kg',
                style: const TextStyle(color: _navy, fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          if (changedSinceSaved) ...[
            const SizedBox(height: 9),
            const Text('Pratinjau sudah berubah. Tekan Hitung BMI agar pilihan dan hasil terbaru tersimpan.',
                style: TextStyle(color: _blue, fontSize: 10.5, height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _reference() {
    const values = [
      ('Berat badan kurang', '< 18,5', Color(0xFF8EC1FF)),
      ('Normal', '18,5–24,9', Color(0xFF57DCAE)),
      ('Berat badan lebih', '25–29,9', Color(0xFFFFD775)),
      ('Obesitas', '≥ 30', Color(0xFFFF9EA6)),
    ];
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Kategori BMI (Referensi)', style: TextStyle(color: _navy, fontSize: 13, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      ...values.map((entry) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: entry.$3, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(child: Text(entry.$1, style: const TextStyle(color: _navy, fontSize: 12))),
          Text(entry.$2, style: const TextStyle(color: _muted, fontSize: 11)),
        ]),
      )),
    ]));
  }

  Widget _tips(BmiResult item) {
    // Isi rekomendasi mengikuti kategori hasil perhitungan, bukan satu contoh statis.
    final food = foodSuggestion(item.category);
    final vitamins = vitaminSuggestion(item.category);
    final articles = [editorialArticles[3], editorialArticles[1], editorialArticles[6]];
    return _card(color: _pale, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Rekomendasi untukmu', style: TextStyle(color: _navy, fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 325;
        final first = _advice(Icons.restaurant_outlined, 'Saran makanan', food);
        final second = _advice(Icons.medication_outlined, 'Saran vitamin', vitamins);
        return narrow
          ? Column(children: [first, const SizedBox(height: 8), second])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: first), const SizedBox(width: 8), Expanded(child: second)]);
      }),
      const SizedBox(height: 13),
      const Text('Artikel untuk dibaca', style: TextStyle(color: _navy, fontSize: 13, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      ...articles.map((entry) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () => context.push('/articles/${entry.article.id}', extra: entry.article),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(13)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.menu_book_outlined, color: _blue, size: 20),
                  const SizedBox(width: 9),
                  Expanded(child: Text(entry.article.title,
                    style: const TextStyle(color: _navy, fontWeight: FontWeight.w700, fontSize: 12))),
                  const Icon(Icons.chevron_right, color: _blue, size: 18),
                ]),
                const SizedBox(height: 4),
                Text('Artikel · ${entry.readTime}', style: const TextStyle(color: _muted, fontSize: 10)),
                const SizedBox(height: 6),
                Text(entry.article.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 10.5, height: 1.5)),
              ]),
            ),
          ),
        ),
      )),
      TextButton(onPressed: () => context.push('/recommendations'),
        child: const Text('Lihat semua rekomendasi', style: TextStyle(color: _blue, fontWeight: FontWeight.w700))),
    ]));
  }

  Widget _advice(IconData icon, String title, String message) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: _blue, size: 22),
      const SizedBox(height: 7),
      Text(title, style: const TextStyle(color: _navy, fontWeight: FontWeight.w800, fontSize: 12)),
      const SizedBox(height: 9),
      Text(message, style: const TextStyle(color: _muted, fontSize: 10.5, height: 1.5)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthBloc>().state.user?.email;
    final profile = context.watch<ProfileCubit>().state;
    final history = profile.history.where((r) => r.userEmail == email).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return BlocConsumer<BmiBloc, BmiState>(
      listener: (context, state) {
        if (state.status == BmiStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Perhitungan gagal.')));
        }
        if (state.status == BmiStatus.success && state.result != null) {
          setState(() => _currentResult = state.result);
          if (email != null) context.read<ProfileCubit>().load(email);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hasil BMI berhasil disimpan ke riwayat.')));
        }
      },
      builder: (context, state) {
        final saved = history.isEmpty ? null : history.first;
        final lastResult = _currentResult ?? saved;
        // Hasil BMI lama tidak boleh dianggap sebagai hasil input baru yang
        // belum dihitung. Pilihan gender saja tidak membatalkan hasil BMI.
        final heightInput = _height.text.trim();
        final weightInput = _weight.text.trim();
        final parsedHeight = _readNumber(heightInput);
        final parsedWeight = _readNumber(weightInput);
        final heightEdited = lastResult != null && heightInput.isNotEmpty &&
            (parsedHeight == null ||
                (parsedHeight - lastResult.heightCm).abs() > 0.001);
        final weightEdited = lastResult != null && weightInput.isNotEmpty &&
            (parsedWeight == null ||
                (parsedWeight - lastResult.weightKg).abs() > 0.001);
        final result = heightEdited || weightEdited ? null : lastResult;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 630),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
              children: [
                const Text('Hitung indeks massa tubuhmu', style: TextStyle(color: _muted, fontSize: 13)),
                const SizedBox(height: 6),
                const Text('Kalkulator BMI', style: TextStyle(color: _navy, fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 21),
                _fieldLabel('Jenis Kelamin'),
                Row(children: [
                  Expanded(child: _genderButton('L', 'Pria')),
                  const SizedBox(width: 10),
                  Expanded(child: _genderButton('P', 'Wanita')),
                ]),
                const SizedBox(height: 17),
                _fieldLabel('Tinggi Badan (cm)'),
                _input(_height, 'Contoh: 170', 'cm'),
                const SizedBox(height: 6),
                const Text('Masukkan tinggi badan antara 50 - 250 cm', style: TextStyle(color: _muted, fontSize: 10.5)),
                const SizedBox(height: 15),
                _fieldLabel('Berat Badan (kg)'),
                _input(_weight, 'Contoh: 65', 'kg'),
                const SizedBox(height: 6),
                const Text('Masukkan berat badan antara 10 - 300 kg', style: TextStyle(color: _muted, fontSize: 10.5)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 49,
                  child: FilledButton(
                    onPressed: state.status == BmiStatus.loading ? null : _calculate,
                    style: FilledButton.styleFrom(backgroundColor: _blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(state.status == BmiStatus.loading ? 'Menghitung...' : 'Hitung BMI',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
                if (result != null) ...[
                  const SizedBox(height: 20),
                  _resultCard(result),
                  const SizedBox(height: 16),
                  _brocaCard(result),
                  const SizedBox(height: 17),
                ] else ...[
                  const SizedBox(height: 20),
                  _card(color: _pale, child: const Text('Hasil perhitungan BMI akan muncul di sini setelah kamu mengisi tinggi dan berat badan.',
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.5))),
                  const SizedBox(height: 17),
                ],
                _reference(),
                if (result != null) ...[
                  const SizedBox(height: 18),
                  _tips(result),
                ],
                const SizedBox(height: 12),
                const Text('BMI adalah indikator awal untuk orang dewasa, bukan diagnosis medis. Konsultasikan hasil dengan tenaga kesehatan jika diperlukan.',
                  style: TextStyle(color: _muted, fontSize: 10.5, height: 1.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _genderButton(String value, String text) {
    final active = _gender == value;
    return InkWell(
      onTap: () {
        if (_gender != value) setState(() => _gender = value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _pale : Colors.white,
          border: Border.all(color: active ? _blue : _border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: TextStyle(color: active ? _blue : _muted, fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }
}
