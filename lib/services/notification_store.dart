import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


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

  String get _key => 'notifications_week10_${Uri.encodeComponent(email.toLowerCase())}';

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
    // Hanya contoh notifikasi dalam aplikasi (minggu ke-10).
    // Pengingat terjadwal di OS masih memerlukan pengujian perangkat.
    final now = DateTime.now();
    final notices = <AppNotice>[
      AppNotice(
        id: 'w10-info',
        title: 'Selamat datang di CekBMIku',
        message: 'Halaman notifikasi versi awal sudah bisa diakses. Fitur pemeriksaan BMI masih dikembangkan.',
        createdAt: now,
        icon: 'bell', unread: true,
      ),
      AppNotice(
        id: 'w10-tip',
        title: 'Tips hidup sehat',
        message: 'Mulai dari kebiasaan kecil: minum air cukup dan bergerak secara teratur.',
        createdAt: now.subtract(const Duration(hours: 3)),
        icon: 'heart', unread: false,
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
