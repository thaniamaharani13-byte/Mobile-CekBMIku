import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Pengingat lokal Android/iOS, satu jadwal per akun pada perangkat ini.
/// Tidak memerlukan server, tetapi tetap bergantung pada izin dan kebijakan OS.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 8,
    this.minute = 0,
    this.weekday,
  });
  final bool enabled;
  final int hour;
  final int minute;
  final int? weekday;

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute, int? weekday}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        weekday: weekday ?? this.weekday,
      );

  Map<String, Object?> toJson() => {
        'enabled': enabled,
        'hour': hour,
        'minute': minute,
        'weekday': weekday,
      };

  factory ReminderSettings.fromJson(Map<String, dynamic> value) =>
      ReminderSettings(
        enabled: value['enabled'] == true,
        hour: (value['hour'] as num?)?.toInt() ?? 8,
        minute: (value['minute'] as num?)?.toInt() ?? 0,
        weekday: (value['weekday'] as num?)?.toInt(),
      );
}

class BmiReminderService {
  BmiReminderService._();
  static final instance = BmiReminderService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  String _key(String email) =>
      'bmi_reminder_v1_${Uri.encodeComponent(email.toLowerCase())}';

  int _notificationId(String email) {
    // ID stabil lintas peluncuran aplikasi, dengan ruang terpisah tiap akun.
    var hash = 17;
    for (final char in email.toLowerCase().codeUnits) {
      hash = (hash * 31 + char) & 0x7fffffff;
    }
    return 1000 + (hash % 1000000000);
  }

  Future<ReminderSettings> load(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(email));
    if (raw == null) return const ReminderSettings();
    try {
      return ReminderSettings.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return const ReminderSettings();
    }
  }

  Future<void> save(String email, ReminderSettings value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(email), jsonEncode(value.toJson()));
  }

  Future<void> initialize() async {
    if (_initialized) return;
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError('Pengingat terjadwal didukung pada Android dan iOS.');
    }
    tz.initializeTimeZones();
    // Memakai zona waktu perangkat agar 08:00 berarti jam lokal perangkat.
    final name = await FlutterTimezone.getLocalTimezone();
    try {
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // Jangan salah menjadwalkan di UTC jika zona perangkat tidak dikenali.
      throw StateError('Zona waktu perangkat tidak dikenali: $name');
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> hasPermission() async {
    await initialize();
    if (Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
    final permission = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();
    return permission?.isEnabled ?? false;
  }

  Future<bool> requestPermission() async {
    await initialize();
    if (Platform.isAndroid) {
      final allowed = await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return allowed ?? await hasPermission();
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  DateTime nextReminder(ReminderSettings settings) {
    final now = DateTime.now();
    final weekday = settings.weekday ?? now.weekday;
    final daysUntil = (weekday - now.weekday + 7) % 7;
    var date = DateTime(
      now.year, now.month, now.day + daysUntil, settings.hour, settings.minute);
    if (!date.isAfter(now)) {
      date = DateTime(
        now.year, now.month, now.day + daysUntil + 7,
        settings.hour, settings.minute,
      );
    }
    return date;
  }

  Future<void> schedule(String email, ReminderSettings settings) async {
    await initialize();
    if (!await hasPermission()) {
      throw StateError('Izin notifikasi Android belum diberikan.');
    }
    final next = nextReminder(settings);
    final when = tz.TZDateTime(
      tz.local, next.year, next.month, next.day, next.hour, next.minute);
    final id = _notificationId(email);
    await _plugin.cancel(id);
    await _plugin.zonedSchedule(
      id,
      'Waktunya cek BMI mingguan',
      'Yuk, ukur berat badan dan cek BMI untuk memantau perkembanganmu.',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'cekbmiku_weekly_bmi',
          'Pengingat BMI Mingguan',
          channelDescription: 'Pengingat pemeriksaan BMI setiap 7 hari',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Tidak meminta izin exact alarm khusus; OS dapat sedikit menggeser jam.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancel(String email) async {
    await initialize();
    await _plugin.cancel(_notificationId(email));
  }
}
