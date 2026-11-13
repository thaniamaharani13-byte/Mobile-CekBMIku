import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'goal_store.dart';
import 'local_store.dart';

/// Notifikasi lokal untuk prototipe. Tidak menggunakan push notification OS.
class AppNotice {
  const AppNotice({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.icon,
    this.unread = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String icon;
  final bool unread;

  AppNotice copyWith({bool? unread}) => AppNotice(
        id: id,
        title: title,
        message: message,
        createdAt: createdAt,
        icon: icon,
        unread: unread ?? this.unread,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'icon': icon,
        'unread': unread,
      };

  factory AppNotice.fromJson(Map<String, dynamic> json) => AppNotice(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        icon: json['icon'] as String? ?? 'bell',
        unread: json['unread'] as bool? ?? false,
      );
}

class NotificationStore {
  NotificationStore(this.email);

  final String email;

  String get _key => 'notifications_v1_${Uri.encodeComponent(email.toLowerCase())}';

  Future<List<AppNotice>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        return (jsonDecode(raw) as List)
            .map((e) => AppNotice.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        // If locally stored demo data is corrupted, show an empty list rather
        // than crashing the page. A valid deletion ([]) remains deleted.
        return [];
      }
    }
    // Demo notices are created once, with any available real BMI and target
    // data rather than hardcoded fictional values from the mockup.
    final history = await LocalStore().historyFor(email);
    final goal = await GoalStore().getGoal(email);
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final last = history.isEmpty ? null : ([...history]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))).first;
    final notices = <AppNotice>[
      AppNotice(
        id: 'weekly', title: 'Waktunya cek BMI mingguan',
        message: 'Yuk, ukur berat badan dan cek BMI untuk memantau perkembanganmu.',
        createdAt: DateTime(now.year, now.month, now.day, 8),
        icon: 'bell', unread: true,
      ),
      AppNotice(
        id: 'motivation', title: 'Tetap semangat menuju target!',
        message: goal == null
            ? 'Tetapkan target BMI-mu dan lanjutkan kebiasaan sehat, ya.'
            : 'Target BMI ${goal.toStringAsFixed(1).replaceAll('.', ',')} sudah tersimpan. Lanjutkan kebiasaan sehatmu, ya.',
        createdAt: DateTime(now.year, now.month, now.day, 7, 30),
        icon: 'target', unread: true,
      ),
      AppNotice(
        id: 'history',
        title: last == null ? 'Mulai catat hasil BMI-mu' : 'Hasil pemeriksaan tersimpan',
        message: last == null
            ? 'Cek BMI pertamamu untuk mulai melihat riwayat perkembangan.'
            : 'BMI terakhir ${last.bmi.toStringAsFixed(1).replaceAll('.', ',')}, kategori ${last.category}. Lihat detailnya di Riwayat.',
        createdAt: DateTime(yesterday.year, yesterday.month, yesterday.day, 9, 15),
        icon: 'bmi',
      ),
      AppNotice(
        id: 'movement', title: 'Saatnya bergerak sejenak',
        message: 'Luangkan 30 menit untuk berjalan kaki. Langkah kecil, manfaat besar!',
        createdAt: DateTime(yesterday.year, yesterday.month, yesterday.day, 7),
        icon: 'heart',
      ),
    ];
    await save(notices);
    return notices;
  }

  Future<void> save(List<AppNotice> notices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(notices.map((n) => n.toJson()).toList()));
  }
}
