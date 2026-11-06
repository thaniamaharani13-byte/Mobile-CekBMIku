import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/register/register_cubit.dart';

/// Halaman pendaftaran mengikuti desain CekBMIku.
/// Umur dan jenis kelamin dilengkapi belakangan melalui Edit Profil.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _navy = Color(0xFF1C3155);
  static const _blue = Color(0xFF2962EC);
  static const _outline = Color(0xFFDDE6F3);
  static const _muted = Color(0xFF9EACC3);

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () => _showDocumentNotAvailable('Syarat dan Ketentuan');
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => _showDocumentNotAvailable('Kebijakan Privasi');
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _showDocumentNotAvailable(String title) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(
          'Dokumen $title belum tersedia dalam versi prototipe ini. '
          'Tambahkan dokumen resmi sebelum aplikasi dipublikasikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Centang persetujuan sebelum mendaftar.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          confirmPassword: _confirm.text,
        );
  }

  Widget _label(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          title,
          style: const TextStyle(
            color: _navy,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      );

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder makeBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _muted, fontSize: 13),
      prefixIcon: Icon(icon, size: 19, color: const Color(0xFF899BB8)),
      prefixIconConstraints: const BoxConstraints(minHeight: 42, minWidth: 42),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minHeight: 42, minWidth: 42),
      border: makeBorder(_outline),
      enabledBorder: makeBorder(_outline),
      focusedBorder: makeBorder(_blue, width: 1.4),
      errorBorder: makeBorder(const Color(0xFFDA4E63)),
      focusedErrorBorder: makeBorder(const Color(0xFFDA4E63), width: 1.4),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      constraints: const BoxConstraints(minHeight: 44),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback toggle,
    required String? Function(String?) validator,
    TextInputAction action = TextInputAction.next,
  }) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _label(label),
          TextFormField(
            controller: controller,
            obscureText: hidden,
            textInputAction: action,
            onFieldSubmitted: action == TextInputAction.done
                ? (_) => _submit()
                : null,
            style: const TextStyle(fontSize: 13, color: _navy),
            decoration: _decoration(
              hint: '••••••••',
              icon: Icons.lock_reset_outlined,
              suffix: IconButton(
                tooltip: hidden ? 'Tampilkan password' : 'Sembunyikan password',
                onPressed: toggle,
                icon: Icon(
                  hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF8799B6),
                  size: 19,
                ),
              ),
            ),
            validator: validator,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Pendaftaran gagal.')),
          );
        }
        if (state.status == RegisterStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Pendaftaran berhasil.')),
          );
          context.read<RegisterCubit>().reset();
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Menjaga proporsi mockup sekaligus tetap scrollable saat keyboard terbuka.
              final topSpace = (constraints.maxHeight * 0.15).clamp(35.0, 150.0);
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: topSpace),
                          Center(
                            child: Image.asset(
                              'assets/images/cekbmiku_logo_mark.png',
                              width: 105,
                              height: 97,
                              fit: BoxFit.contain,
                              semanticLabel: 'Logo CekBMIku',
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'CekBMIku',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 31),
                          AutofillGroup(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _label('Nama Lengkap'),
                                  TextFormField(
                                    controller: _name,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.name],
                                    style: const TextStyle(fontSize: 13, color: _navy),
                                    decoration: _decoration(
                                      hint: 'Masukan nama lengkap',
                                      icon: Icons.person_outline_rounded,
                                    ),
                                    validator: (value) => (value == null || value.trim().isEmpty)
                                        ? 'Nama lengkap wajib diisi.'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _label('Email'),
                                  TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email],
                                    style: const TextStyle(fontSize: 13, color: _navy),
                                    decoration: _decoration(
                                      hint: 'admin@cekbmiku.id',
                                      icon: Icons.notifications_none_outlined,
                                    ),
                                    validator: (value) {
                                      final email = value?.trim() ?? '';
                                      if (email.isEmpty) return 'Email wajib diisi.';
                                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                                        return 'Format email tidak valid.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _passwordField(
                                    label: 'Password',
                                    controller: _password,
                                    hidden: _hidePassword,
                                    toggle: () => setState(() => _hidePassword = !_hidePassword),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Password wajib diisi.';
                                      if (value.length < 6) return 'Password minimal 6 karakter.';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _passwordField(
                                    label: 'Konfirmasi Password',
                                    controller: _confirm,
                                    hidden: _hideConfirm,
                                    toggle: () => setState(() => _hideConfirm = !_hideConfirm),
                                    action: TextInputAction.done,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi.';
                                      if (value != _password.text) return 'Konfirmasi password tidak cocok.';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                          value: _agreed,
                                          activeColor: _blue,
                                          side: const BorderSide(color: _blue, width: 1.6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) => setState(() => _agreed = value ?? false),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(() => _agreed = !_agreed),
                                          child: Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                color: Color(0xFF8293AF),
                                                fontSize: 11,
                                                height: 1.55,
                                              ),
                                              children: [
                                                const TextSpan(text: 'Saya setuju dengan '),
                                                TextSpan(
                                                  text: 'Syarat dan Ketentuan',
                                                  style: const TextStyle(color: _blue),
                                                  recognizer: _termsTap,
                                                ),
                                                const TextSpan(text: ' dan '),
                                                TextSpan(
                                                  text: 'Kebijakan Privasi',
                                                  style: const TextStyle(color: _blue),
                                                  recognizer: _privacyTap,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  BlocBuilder<RegisterCubit, RegisterState>(
                                    builder: (context, state) {
                                      final loading = state.status == RegisterStatus.loading;
                                      return SizedBox(
                                        height: 48,
                                        child: FilledButton(
                                          onPressed: loading ? null : _submit,
                                          style: FilledButton.styleFrom(
                                            backgroundColor: _blue,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: _blue.withOpacity(0.6),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                          ),
                                          child: loading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text(
                                                  'Daftar',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 27),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8798B4),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: _blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
