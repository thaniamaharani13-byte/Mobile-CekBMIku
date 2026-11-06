import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../services/notification_store.dart';

/// Halaman notifikasi berdasarkan desain "Notifikasi" dan "Notifikasi Kosong".
/// Data pemberitahuan contoh disimpan lokal per akun. Hapus semua bersifat
/// permanen untuk list tersebut (tidak muncul lagi setiap buka halaman).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _ink = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _wash = Color(0xFFEEF3FF);

  NotificationStore? _store;
  List<AppNotice> _notices = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final email = context.read<AuthBloc>().state.user?.email;
    // Route guard prevents anonymous access. Fallback remains local-only.
    _store = NotificationStore(email ?? 'guest');
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _store!.load();
      if (!mounted) return;
      setState(() {
        _notices = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _update(List<AppNotice> items) async {
    setState(() => _notices = items);
    await _store?.save(items);
  }

  Future<void> _markRead(AppNotice item) async {
    if (!item.unread) return;
    await _update(_notices.map((n) => n.id == item.id ? n.copyWith(unread: false) : n).toList());
  }

  Future<void> _remove(String id) async => _update(_notices.where((n) => n.id != id).toList());

  Future<void> _removeAll() async => _update([]);

  static String _date(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _time(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm WIB';
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'target': return Icons.flag_outlined;
      case 'bmi': return Icons.monitor_heart_outlined;
      case 'heart': return Icons.favorite_border;
      default: return Icons.notifications_none_outlined;
    }
  }

  bool _isSameDate(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month && first.day == second.day;

  Widget _noticeCard(AppNotice item) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    decoration: BoxDecoration(
      border: Border.all(color: _border), borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _markRead(item),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 13, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 37, height: 37,
              decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(13)),
              child: Icon(_iconFor(item.icon), color: _blue, size: 22),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Text(item.title,
                      style: const TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 12.7, height: 1.4))),
                    if (item.unread) ...[
                      const SizedBox(width: 5),
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: CircleAvatar(radius: 3.5, backgroundColor: _blue),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 7),
                  Text(item.message,
                    style: const TextStyle(color: _muted, fontSize: 11.0, height: 1.43)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: Text(_time(item.createdAt),
                      style: const TextStyle(color: _muted, fontSize: 10))),
                    InkWell(
                      onTap: () => _remove(item.id),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.delete_outline, size: 15, color: Color(0xFFE8404F)),
                          SizedBox(width: 4),
                          Text('Hapus', style: TextStyle(fontSize: 11, color: Color(0xFFE8404F))),
                        ]),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _group(String title, String date, List<AppNotice> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Text(title,
          style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w800))),
        Text(date, style: const TextStyle(color: _muted, fontSize: 10.5)),
      ]),
      const SizedBox(height: 11),
      ...items.map(_noticeCard),
      const SizedBox(height: 6),
    ]);
  }

  Widget _empty() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 89, height: 89,
          decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(27)),
          child: const Icon(Icons.notifications_none_outlined, color: _blue, size: 42),
        ),
        const SizedBox(height: 19),
        const Text('Tidak ada notifikasi',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: 20)),
        const SizedBox(height: 9),
        const Text('Semua notifikasi telah dihapus. Pengingat dan kabar sehat berikutnya akan muncul di sini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12.2, height: 1.5)),
      ]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final items = [..._notices]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final unread = items.where((n) => n.unread).length;
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayItems = items.where((n) => _isSameDate(n.createdAt, today)).toList();
    final yesterdayItems = items.where((n) => _isSameDate(n.createdAt, yesterday)).toList();
    final older = items.where((n) => !_isSameDate(n.createdAt, today) && !_isSameDate(n.createdAt, yesterday)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
          icon: const Icon(Icons.arrow_back, color: _blue, size: 21),
          tooltip: 'Kembali ke Beranda',
        ),
        titleSpacing: 0,
        title: const Text('Notifikasi',
          style: TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 630),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 7, 24, 20),
              child: Text('Contoh notifikasi aplikasi. Pengujian pengingat Android masih berlangsung.',
                style: TextStyle(color: _muted, fontSize: 13)),
            ),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(children: [
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: _wash, borderRadius: BorderRadius.circular(18)),
                      child: Text('$unread belum dibaca',
                        style: const TextStyle(color: _blue, fontSize: 11)),
                    )
                  else
                    Text('${items.length} notifikasi',
                      style: const TextStyle(color: _muted, fontSize: 11)),
                  const Spacer(),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: _removeAll,
                      child: const Text('Hapus semua',
                        style: TextStyle(color: Color(0xFFE8404F), fontSize: 12)),
                    ),
                ]),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Expanded(child: _empty())
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 3, 24, 25),
                    children: [
                      _group('Hari ini', _date(today), todayItems),
                      _group('Kemarin', _date(yesterday), yesterdayItems),
                      if (older.isNotEmpty) _group('Sebelumnya', '', older),
                      const SizedBox(height: 4),
                      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        CircleAvatar(radius: 2.8, backgroundColor: _blue),
                        SizedBox(width: 5),
                        Flexible(child: Text('Tanda biru berarti notifikasi belum dibaca.',
                          style: TextStyle(color: _muted, fontSize: 10))),
                      ]),
                    ],
                  ),
                ),
            ],
          ]),
        ),
      ),
    );
  }
}
