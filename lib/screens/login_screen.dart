import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';

/// Login is the public entry gate. AuthBloc + GoRouter handle navigation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _navy = Color(0xFF1C3155);
  static const _primaryBlue = Color(0xFF2962EC);
  static const _border = Color(0xFFDDE6F3);
  static const _hint = Color(0xFF9EACC3);

  final _formKey = GlobalKey<FormState>();
  final _identity = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            identity: _identity.text.trim(),
            password: _password.text,
            rememberMe: _rememberMe,
          ),
        );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF8E9FBC), size: 20),
      suffixIcon: suffixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 38),
      suffixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 38),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      isDense: true,
      border: border(_border),
      enabledBorder: border(_border),
      focusedBorder: border(_primaryBlue, width: 1.4),
      errorBorder: border(const Color(0xFFDF4D60)),
      focusedErrorBorder: border(const Color(0xFFDF4D60), width: 1.4),
      constraints: const BoxConstraints(minHeight: 44),
    );
  }

  Widget _label(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AuthStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message ?? 'Login gagal.')),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topSpace =
                  (constraints.maxHeight * 0.23).clamp(56.0, 205.0);

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: topSpace),
                          Center(
                            child: Image.asset(
                              'assets/images/cekbmiku_logo_mark.png',
                              width: 123,
                              height: 112,
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
                          const SizedBox(height: 34),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _label('Email'),
                                TextFormField(
                                  controller: _identity,
                                  style: const TextStyle(fontSize: 13, color: _navy),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.username],
                                  decoration: _fieldDecoration(
                                    hint: 'admin@cekbmiku.id',
                                    icon: Icons.notifications_none_outlined,
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                          ? 'Email wajib diisi.'
                                          : null,
                                ),
                                const SizedBox(height: 15),
                                _label('Password'),
                                TextFormField(
                                  controller: _password,
                                  style: const TextStyle(fontSize: 13, color: _navy),
                                  obscureText: _hidePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: _fieldDecoration(
                                    hint: '••••••••',
                                    icon: Icons.lock_outline_rounded,
                                    suffixIcon: IconButton(
                                      tooltip: _hidePassword
                                          ? 'Tampilkan password'
                                          : 'Sembunyikan password',
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 19,
                                        color: const Color(0xFF8598B7),
                                      ),
                                      onPressed: () => setState(
                                        () => _hidePassword = !_hidePassword,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'Password wajib diisi.'
                                          : null,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        side: const BorderSide(
                                          color: _primaryBlue,
                                          width: 1.6,
                                        ),
                                        activeColor: _primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (value) => setState(
                                          () => _rememberMe = value ?? false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => setState(
                                        () => _rememberMe = !_rememberMe,
                                      ),
                                      child: const Text(
                                        'Ingat saya',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8091AD),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                BlocBuilder<AuthBloc, AuthState>(
                                  buildWhen: (previous, current) =>
                                      previous.status != current.status,
                                  builder: (context, state) {
                                    final loading =
                                        state.status == AuthStatus.loading;
                                    return SizedBox(
                                      height: 47,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: _primaryBlue,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor:
                                              _primaryBlue.withOpacity(0.65),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: loading ? null : _submit,
                                        child: loading
                                            ? const SizedBox(
                                                width: 19,
                                                height: 19,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Masuk',
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
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum punya akun? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8798B4),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/register'),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: _primaryBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
