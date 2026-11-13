import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/bmi/bmi_bloc.dart';
import 'core/app_theme.dart';
import 'cubits/admin/admin_cubit.dart';
import 'cubits/article/article_cubit.dart';
import 'cubits/feedback/feedback_cubit.dart';
import 'cubits/profile/profile_cubit.dart';
import 'cubits/register/register_cubit.dart';
import 'router/app_router.dart';
import 'services/local_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Render aplikasi lebih dulu. Menunggu plugin/penyimpanan sebelum runApp()
  // dapat menyebabkan emulator hanya menampilkan wallpaper/layar kosong.
  final store = LocalStore();
  final authBloc = AuthBloc(store);
  final appRouter = AppRouter(authBloc);

  debugPrint('CEKBMI STARTUP: runApp dipanggil');
  runApp(
    CekBmikuApp(
      store: store,
      authBloc: authBloc,
      appRouter: appRouter,
    ),
  );
}

/// Struktur aplikasi dan semua route tetap seperti sebelumnya.
/// Pada beberapa emulator Android 15/16, immersiveSticky sewaktu startup
/// dapat mengganggu peluncuran jendela aplikasi. Gunakan edgeToEdge yang aman.
class CekBmikuApp extends StatefulWidget {
  const CekBmikuApp({
    super.key,
    required this.store,
    required this.authBloc,
    required this.appRouter,
  });

  final LocalStore store;
  final AuthBloc authBloc;
  final AppRouter appRouter;

  @override
  State<CekBmikuApp> createState() => _CekBmikuAppState();
}

class _CekBmikuAppState extends State<CekBmikuApp>
    with WidgetsBindingObserver {
  Timer? _restoreBarsTimer;
  bool _wasKeyboardVisible = false;
  late Future<void> _startup;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startup = _initializeApp();

    // Pengaturan sistem tidak boleh menahan tampilnya frame pertama.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_applySafeSystemUi());
    });
  }

  Future<void> _initializeApp() async {
    debugPrint('CEKBMI STARTUP: menyiapkan data lokal');
    try {
      await widget.store.seed().timeout(const Duration(seconds: 25));
      debugPrint('CEKBMI STARTUP: data lokal siap');
      widget.authBloc.add(const AuthAppStarted());
      debugPrint('CEKBMI STARTUP: autentikasi dimulai');
    } catch (error, stackTrace) {
      debugPrint('CEKBMI STARTUP ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _applySafeSystemUi() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (error) {
      debugPrint('CEKBMI: konfigurasi bilah sistem dilewati: $error');
    }
  }

  @override
  void didChangeMetrics() {
    final keyboardVisible = WidgetsBinding.instance.platformDispatcher.views
        .any((view) => view.viewInsets.bottom > 0);
    if (keyboardVisible) {
      _restoreBarsTimer?.cancel();
    } else if (_wasKeyboardVisible) {
      _restoreBarsTimer?.cancel();
      _restoreBarsTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) unawaited(_applySafeSystemUi());
      });
    }
    _wasKeyboardVisible = keyboardVisible;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_applySafeSystemUi());
    }
  }

  @override
  void dispose() {
    _restoreBarsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startup,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2962EF)),
                    SizedBox(height: 16),
                    Text('Menyiapkan CekBMIku...'),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 44, color: Color(0xFF2962EF)),
                      const SizedBox(height: 16),
                      const Text('CekBMIku belum dapat memuat data lokal.',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: () {
                          setState(() => _startup = _initializeApp());
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        debugPrint('CEKBMI STARTUP: membuka halaman aplikasi');
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: widget.authBloc),
            BlocProvider(create: (_) => RegisterCubit(widget.store)),
            BlocProvider(create: (_) => BmiBloc(widget.store)),
            BlocProvider(create: (_) => ProfileCubit(widget.store)),
            BlocProvider(create: (_) => ArticleCubit(widget.store)..load()),
            BlocProvider(create: (_) => FeedbackCubit(widget.store)),
            BlocProvider(create: (_) => AdminCubit(widget.store)),
          ],
          child: MaterialApp.router(
            title: 'CekBMIku',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: widget.appRouter.router,
          ),
        );
      },
    );
  }
}
