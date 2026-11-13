import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Target tersimpan per akun dan hanya di perangkat ini (prototipe offline).
/// Hasil BMI/berat berasal dari pemeriksaan aktual, bukan angka contoh UI.
enum GoalKind { weight, bmi }

class BmiGoal {
  BmiGoal({
    required this.kind,
    required this.value,
    required this.createdAt,
    DateTime? startDate,
    required this.deadline,
    this.baselineValue,
    this.heightAtCreation,
  }) : startDate = startDate ?? DateTime(createdAt.year, createdAt.month, createdAt.day);

  final GoalKind kind;
  final double value;
  final DateTime createdAt;
  /// Awal periode pemantauan yang dipilih pengguna, berbeda dari waktu data disimpan.
  final DateTime startDate;
  final DateTime deadline;
  /// Berat atau BMI pada saat target pertama kali disimpan.
  final double? baselineValue;
  /// Tinggi dari pemeriksaan terbaru saat target dibuat (dalam cm).
  final double? heightAtCreation;

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'value': value,
        'createdAt': createdAt.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'deadline': deadline.toIso8601String(),
        'baselineValue': baselineValue,
        'heightAtCreation': heightAtCreation,
      };

  factory BmiGoal.fromJson(Map<String, dynamic> json) {
    return BmiGoal(
      kind: json['kind'] == 'weight' ? GoalKind.weight : GoalKind.bmi,
      value: (json['value'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      // Target lama tetap bisa dibuka meskipun belum memiliki startDate.
      startDate: json['startDate'] == null
          ? null
          : DateTime.tryParse(json['startDate'].toString()),
      deadline: DateTime.parse(json['deadline'] as String),
      baselineValue: (json['baselineValue'] as num?)?.toDouble(),
      heightAtCreation: (json['heightAtCreation'] as num?)?.toDouble(),
    );
  }

  double? get targetBmi {
    if (kind == GoalKind.bmi) return value;
    final height = heightAtCreation;
    if (height == null || height <= 0) return null;
    final metres = height / 100;
    return value / (metres * metres);
  }
}

class GoalStore {
  String _key(String email, String suffix) =>
      'cekbmiku_${email.trim().toLowerCase()}_$suffix';

  Future<BmiGoal?> getTarget(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(email, 'goal_record'));
    if (raw != null) {
      try {
        return BmiGoal.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
      } catch (_) {
        return null;
      }
    }
    // Kompatibilitas dengan target BMI sederhana dari versi sebelumnya.
    final previous = prefs.getDouble(_key(email, 'goal_bmi'));
    if (previous == null) return null;
    final now = DateTime.now();
    return BmiGoal(
      kind: GoalKind.bmi,
      value: previous,
      createdAt: now,
      deadline: now.add(const Duration(days: 90)),
    );
  }

  Future<void> saveTarget(String email, BmiGoal target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(email, 'goal_record'), jsonEncode(target.toJson()));
    final bmi = target.targetBmi;
    if (bmi == null) {
      await prefs.remove(_key(email, 'goal_bmi'));
    } else {
      await prefs.setDouble(_key(email, 'goal_bmi'), bmi);
    }
  }

  /// API lama masih dipakai Beranda dan fitur pendukung.
  Future<double?> getGoal(String email) async {
    final target = await getTarget(email);
    return target?.targetBmi;
  }

  /// Mempertahankan kompatibilitas untuk kode pemanggil versi lama.
  Future<void> setGoal(String email, double bmi) async {
    final now = DateTime.now();
    await saveTarget(email, BmiGoal(
      kind: GoalKind.bmi,
      value: bmi,
      createdAt: now,
      deadline: now.add(const Duration(days: 90)),
    ));
  }

  Future<bool> getReminder(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(email, 'reminder_enabled')) ?? false;
  }

  Future<void> setReminder(String email, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(email, 'reminder_enabled'), enabled);
  }

  static double? currentValue(List<BmiResult> history, GoalKind kind) {
    if (history.isEmpty) return null;
    final latest = [...history]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return kind == GoalKind.weight ? latest.first.weightKg : latest.first.bmi;
  }

  /// Pemeriksaan yang berada pada rentang tanggal mulai sampai batas target.
  /// Batas akhir bersifat inklusif (hingga pukul 23:59 pada hari target).
  static List<BmiResult> recordsInPeriod(List<BmiResult> history, BmiGoal goal) {
    final exclusiveEnd = DateTime(goal.deadline.year, goal.deadline.month, goal.deadline.day + 1);
    return history.where((item) =>
        !item.createdAt.isBefore(goal.startDate) &&
        item.createdAt.isBefore(exclusiveEnd)).toList();
  }

  /// Pengukuran paling awal dalam periode menjadi titik awal progres.
  /// Jika target baru disimpan dan sudah ada pengukuran pada periode itu,
  /// baselineValue menyimpan nilainya sehingga tidak berubah saat ada data baru.
  static double? baselineForTarget(List<BmiResult> history, BmiGoal? target) {
    if (target == null) return null;
    final withinPeriod = recordsInPeriod(history, target);
    if (withinPeriod.isEmpty) return null;
    if (target.baselineValue != null) return target.baselineValue;
    withinPeriod.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return target.kind == GoalKind.weight
        ? withinPeriod.first.weightKg : withinPeriod.first.bmi;
  }

  /// Progres 0–1, dihitung dari pemeriksaan dalam periode target, bukan
  /// dari selisih hari. Butuh setidaknya satu titik awal dan satu perubahan.
  static double progressForTarget(List<BmiResult> history, BmiGoal? target) {
    if (target == null) return 0;
    final withinPeriod = recordsInPeriod(history, target);
    if (withinPeriod.isEmpty) return 0;
    final start = baselineForTarget(history, target);
    if (start == null) return 0;
    final current = currentValue(withinPeriod, target.kind)!;
    final distance = target.value - start;
    if (distance.abs() < 0.0001) return 1;
    return ((current - start) / distance).clamp(0.0, 1.0).toDouble();
  }

  /// Perhitungan progres lama tetap tersedia untuk halaman lama.
  static double progress(List<BmiResult> items, double? target) {
    if (target == null || items.length < 2) return 0;
    final sorted = [...items]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final start = sorted.first.bmi;
    final now = sorted.last.bmi;
    final distance = target - start;
    if (distance.abs() < 0.001) return 1;
    return ((now - start) / distance).clamp(0.0, 1.0).toDouble();
  }
}
