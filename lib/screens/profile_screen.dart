import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../services/bmi_reminder_service.dart';
import '../widgets/common_widgets.dart';

/// Profil pengguna berdasarkan rancangan UI CekBMIku.
/// Bagian navbar dan header utama tetap dikelola ShellScreen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _ink = Color(0xFF192F52);
  static const _blue = Color(0xFF2962EF);
  static const _muted = Color(0xFF788BAB);
  static const _border = Color(0xFFDDE7F5);
  static const _pale = Color(0xFFEDF3FF);

  File? _avatarFile;
  DateTime? _joinedAt;
  bool _reminderEnabled = false;

  String? get _email => context.read<AuthBloc>().state.user?.email;
  String _avatarKey(String email) =>
      'cekbmiku_avatar_${Uri.encodeComponent(email.toLowerCase())}';

  @override
  void initState() {
    super.initState();
    final email = _email;
    if (email != null) {
      context.read<ProfileCubit>().load(email);
      _loadLocalProfile(email);
      _refreshReminder(email);
    }
  }

  Future<void> _loadLocalProfile(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_avatarKey(email));
    final joinText = prefs.getString('joined_date_${email.toLowerCase()}');
    final file = path == null ? null : File(path);
    final exists = file != null && await file.exists();
    if (!mounted) return;
    setState(() {
      _avatarFile = exists ? file : null;
      _joinedAt = joinText == null ? null : DateTime.tryParse(joinText);
    });
  }

  Future<void> _refreshReminder(String email) async {
    try {
      final saved = await BmiReminderService.instance.load(email);
      final allowed = await BmiReminderService.instance.hasPermission();
      if (mounted) setState(() => _reminderEnabled = saved.enabled && allowed);
    } catch (_) {
      if (mounted) setState(() => _reminderEnabled = false);
    }
  }

  Future<void> _openReminders() async {
    await context.push('/reminders');
    final email = _email;
    if (mounted && email != null) await _refreshReminder(email);
  }

  Future<void> _chooseAvatar() async {
    final email = _email;
    if (email == null) return;
    try {
      final selected = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 720,
        imageQuality: 75,
      );
      if (selected == null) return;
      final directory = await getApplicationDocumentsDirectory();
      final safeEmail = email.hashCode.abs().toString();
      final path = '${directory.path}/cekbmiku_avatar_$safeEmail.jpg';
      final image = await File(selected.path).copy(path);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarKey(email), image.path);
      if (!mounted) return;
      setState(() => _avatarFile = image);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Gagal mengambil foto. Periksa izin galeri perangkat.'),
      ));
    }
  }

  String _membershipLabel() {
    if (_joinedAt == null) return 'Sobat Sehat CekBMIku';
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return 'Sobat Sehat sejak ${months[_joinedAt!.month - 1]} ${_joinedAt!.year}';
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _pale,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: _blue, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(
                    color: _muted, fontSize: 11.7)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _blue, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = state.user ?? context.watch<AuthBloc>().state.user;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageWidth(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            children: [
              const Text('Kenali dirimu, atur langkah sehatmu', style:
                  TextStyle(color: _muted, fontSize: 13)),
              const SizedBox(height: 6),
              const Text('Profil', style: TextStyle(
                color: _ink, fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
                decoration: BoxDecoration(
                  color: _pale, borderRadius: BorderRadius.circular(19)),
                child: Column(
                  children: [
                    SizedBox(
                      width: 108, height: 108,
                      child: Stack(
                        children: [
                          Container(
                            width: 94, height: 94,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              image: DecorationImage(
                                image: _avatarFile == null
                                    ? const AssetImage('assets/images/profile.png')
                                    : FileImage(_avatarFile!) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6, bottom: 9,
                            child: GestureDetector(
                              onTap: _chooseAvatar,
                              child: Container(
                                width: 30, height: 30,
                                decoration: BoxDecoration(
                                  color: _blue, shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(Icons.camera_alt_outlined,
                                  color: Colors.white, size: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, textAlign: TextAlign.center,
                      style: const TextStyle(color: _ink, fontSize: 21,
                        fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(user.email, textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted, fontSize: 12.5)),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(40)),
                      child: Text(_membershipLabel(), style: const TextStyle(
                        color: _blue, fontSize: 10.5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Pengaturan Akun', style: TextStyle(
                color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _border),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(children: [
                  _settingsTile(
                    icon: Icons.manage_accounts_outlined,
                    title: 'Pengaturan Profil',
                    subtitle: 'Ubah nama dan data diri',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: _border),
                  ),
                  _settingsTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Pengaturan Notifikasi',
                    subtitle: _reminderEnabled
                        ? 'Pengingat hidup sehat aktif'
                        : 'Atur pengingat pemeriksaan BMI',
                    onTap: _openReminders,
                  ),
                ]),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(
                  const AuthLogoutRequested()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF3848),
                  backgroundColor: const Color(0xFFFFF2F3),
                  side: const BorderSide(color: Color(0xFFFFDBDE)),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                ),
                icon: const Icon(Icons.logout_outlined, size: 20),
                label: const Text('Keluar dari Akun', style: TextStyle(
                  fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 20),
              const Center(child: Text('CekBMIku · Versi 2.0.0',
                style: TextStyle(color: _muted, fontSize: 11))),
            ],
          ),
        );
      },
    );
  }
}
