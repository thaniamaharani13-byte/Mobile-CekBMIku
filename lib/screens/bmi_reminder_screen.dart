import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../services/bmi_reminder_service.dart';

/// Dua status Pengingat BMI + dialog prapermintaan izin notifikasi.
class BmiReminderScreen extends StatefulWidget {
  const BmiReminderScreen({super.key});

  @override
  State<BmiReminderScreen> createState() => _BmiReminderScreenState();
}

class _BmiReminderScreenState extends State<BmiReminderScreen>
    with WidgetsBindingObserver {
  static const _blue = Color(0xFF2962EF);
  static const _ink = Color(0xFF192F52);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _pale = Color(0xFFEDF3FF);
  final _service = BmiReminderService.instance;
  ReminderSettings _settings = const ReminderSettings();
  bool _permissionGranted = false;
  bool _loading = true;
  bool _busy = false;
  String? _loadError;

  String get _email => context.read<AuthBloc>().state.user?.email ?? 'guest';
  bool get _active => _settings.enabled && _permissionGranted;
  String get _time => '${_settings.hour.toString().padLeft(2, '0')}:${_settings.minute.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_busy) _load();
  }

  Future<void> _load() async {
    try {
      final saved = await _service.load(_email);
      final granted = await _service.hasPermission();
      if (!mounted) return;
      setState(() {
        _settings = saved;
        _permissionGranted = granted;
        _loadError = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Layanan pengingat tidak tersedia pada perangkat ini: $e';
        _permissionGranted = false;
        _loading = false;
      });
    }
  }

  Future<bool> _showPermissionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88, height: 88,
                decoration: const BoxDecoration(color: _pale, shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none_outlined,
                    color: _blue, size: 47),
              ),
              const SizedBox(height: 20),
              const Text('Izinkan Notifikasi', textAlign: TextAlign.center,
                style: TextStyle(color: _ink, fontSize: 23,
                  fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text('Aplikasi memerlukan izin notifikasi untuk mengirim '
                  'pengingat pemeriksaan BMI setiap 7 hari sekali.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _ink, fontSize: 13.2, height: 1.5)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 50,
                child: FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: FilledButton.styleFrom(backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  child: const Text('Izinkan', style: TextStyle(
                    fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  style: OutlinedButton.styleFrom(foregroundColor: _blue,
                    side: const BorderSide(color: _blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  child: const Text('Nanti', style: TextStyle(
                    fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Jika tidak muncul, kamu juga bisa mengaktifkan '
                  'notifikasi melalui Pengaturan Android.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 11.2, height: 1.5)),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _setEnabled(bool enable) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (!enable) {
        await _service.cancel(_email);
        final next = _settings.copyWith(enabled: false);
        await _service.save(_email, next);
        if (!mounted) return;
        setState(() => _settings = next);
        return;
      }

      var granted = await _service.hasPermission();
      // Tampilkan popup sesuai desain sebelum mengaktifkan untuk pertama kali.
      if (!_settings.enabled || !granted) {
        if (!await _showPermissionDialog()) return;
      }
      if (!granted) {
        // Dialog izin Android/iOS yang sebenarnya mengikuti popup CekBMIku.
        granted = await _service.requestPermission();
      }
      if (!mounted) return;
      if (!granted) {
        setState(() => _permissionGranted = false);
        _message('Notifikasi belum diizinkan. Aktifkan melalui pengaturan perangkat.');
        return;
      }
      final now = DateTime.now();
      final next = _settings.copyWith(
        enabled: true,
        weekday: _settings.weekday ?? now.weekday,
      );
      // Jangan tampilkan “aktif” jika penjadwalan gagal.
      await _service.schedule(_email, next);
      await _service.save(_email, next);
      if (!mounted) return;
      setState(() {
        _permissionGranted = true;
        _settings = next;
      });
      _message('Pengingat mingguan berhasil dijadwalkan.');
    } catch (e) {
      _message('Pengingat belum bisa diaktifkan: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseTime() async {
    if (_busy) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _settings.hour, minute: _settings.minute),
      helpText: 'Pilih waktu pengingat BMI',
    );
    if (picked == null) return;
    final next = _settings.copyWith(hour: picked.hour, minute: picked.minute);
    setState(() => _busy = true);
    try {
      if (_active) await _service.schedule(_email, next);
      await _service.save(_email, next);
      if (!mounted) return;
      setState(() => _settings = next);
    } catch (e) {
      _message('Waktu belum berhasil diperbarui: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul',
      'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Widget _panel({required Widget child, Color? background}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: background ?? Colors.white,
      border: background == null ? Border.all(color: _border) : null,
      borderRadius: BorderRadius.circular(18),
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: _blue, size: 22),
        ),
        titleSpacing: 0,
        title: const Text('Pengingat BMI', style: TextStyle(
          color: _ink, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: _pale, borderRadius: BorderRadius.circular(12)),
                      child: const Text('Fitur pengingat versi uji coba minggu ke-10. Jadwal dan izin notifikasi perlu diuji pada perangkat Android.',
                        style: TextStyle(color: _muted, fontSize: 11.5, height: 1.4)),
                    ),
                    const SizedBox(height: 17),
                    const Text('Jaga rutinitas sehatmu', style: TextStyle(
                      color: _ink, fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 7),
                    const Text('Ingatkan diri untuk memeriksa BMI setiap minggu.',
                      style: TextStyle(color: _muted, fontSize: 13.3)),
                    const SizedBox(height: 20),
                    _panel(child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notifications_active_outlined,
                          color: _blue, size: 24),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Aktifkan Pengingat', style: TextStyle(
                              color: _ink, fontSize: 14, fontWeight: FontWeight.w800)),
                            SizedBox(height: 6),
                            Text('Ingatkan saya untuk memeriksa BMI setiap 7 hari sekali.',
                              style: TextStyle(color: _muted, fontSize: 12.3, height: 1.4)),
                          ],
                        )),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: _active,
                          activeTrackColor: _blue,
                          onChanged: _busy ? null : _setEnabled,
                        ),
                      ],
                    )),
                    const SizedBox(height: 20),
                    _panel(child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time_outlined,
                          color: _blue, size: 23),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Waktu Notifikasi', style: TextStyle(
                              color: _ink, fontWeight: FontWeight.w800, fontSize: 14)),
                            const SizedBox(height: 8),
                            const Text('Pilih waktu yang tepat untuk mengingatkan kamu.',
                              style: TextStyle(color: _muted, fontSize: 12.2)),
                            const SizedBox(height: 14),
                            InkWell(
                              onTap: _busy ? null : _chooseTime,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: _border),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(children: [
                                  Expanded(child: Text(_time, style:
                                    const TextStyle(color: _ink, fontSize: 14))),
                                  const Icon(Icons.keyboard_arrow_down, color: _blue),
                                ]),
                              ),
                            ),
                          ],
                        )),
                      ],
                    )),
                    const SizedBox(height: 20),
                    if (_active) ...[
                      _panel(
                        background: _pale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              Icon(Icons.event_available_outlined, color: _blue),
                              SizedBox(width: 10),
                              Text('Pengingat Aktif', style: TextStyle(
                                color: _ink, fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 8),
                            const Text('Kamu akan mendapatkan notifikasi setiap 7 hari '
                                'sekali pada tanggal dan waktu yang telah dipilih.',
                              style: TextStyle(color: _muted, fontSize: 12.4, height: 1.5)),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13)),
                              child: Row(children: [
                                const Icon(Icons.calendar_month_outlined,
                                  color: _blue, size: 24),
                                const SizedBox(width: 9),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Jadwal Berikutnya', style: TextStyle(
                                      color: _muted, fontSize: 10.5)),
                                    Text(_date(_service.nextReminder(_settings)),
                                      style: const TextStyle(color: _ink, fontSize: 16,
                                        fontWeight: FontWeight.w800)),
                                  ],
                                )),
                                Column(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(_time, style: const TextStyle(color: _blue,
                                      fontSize: 20, fontWeight: FontWeight.w800)),
                                    const Text('Waktu lokal', style: TextStyle(
                                      color: _muted, fontSize: 10)),
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _panel(child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tips', style: TextStyle(color: _ink,
                            fontWeight: FontWeight.w800)),
                          SizedBox(height: 12),
                          Text('Periksa BMI secara rutin untuk memantau perkembangan '
                              'dan menjaga kesehatan tubuh.',
                            style: TextStyle(color: _muted, fontSize: 12.3,
                              height: 1.5)),
                        ],
                      )),
                    ] else ...[
                      _panel(
                        background: _pale,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.info_outline, color: _blue),
                              SizedBox(width: 10),
                              Text('Jadwal Pengingat', style: TextStyle(
                                color: _ink, fontWeight: FontWeight.w800)),
                            ]),
                            SizedBox(height: 9),
                            Text('Pengingat akan dikirim setiap 7 hari sekali pada '
                                'waktu yang kamu pilih selama fitur ini aktif.',
                              style: TextStyle(color: _muted, fontSize: 12.3,
                                height: 1.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _panel(child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notifications_none_outlined, color: _blue),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_permissionGranted
                                  ? 'Pengingat Belum Aktif'
                                  : 'Notifikasi Belum Diizinkan', style: TextStyle(
                                color: _ink, fontSize: 12.5, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Text(_permissionGranted
                                  ? 'Aktifkan pengingat untuk mulai menerima notifikasi.'
                                  : 'Izinkan notifikasi agar pengingat dapat ditampilkan.',
                                style: TextStyle(color: _muted, fontSize: 11.8)),
                            ],
                          )),
                        ],
                      )),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _busy ? null : () => _setEnabled(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: _blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                          child: const Text('Aktifkan Notifikasi',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                    if (_loadError != null) ...[
                      const SizedBox(height: 12),
                      Text(_loadError!, style: const TextStyle(
                        color: Colors.red, fontSize: 11)),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
