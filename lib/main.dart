import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'core/app_theme.dart';
import 'cubits/article/article_cubit.dart';
import 'cubits/profile/profile_cubit.dart';
import 'cubits/register/register_cubit.dart';
import 'router/app_router.dart';
import 'services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sembunyikan status bar (jam/sinyal/baterai) dan navigation bar OS.
  // Android 16 / target API 36 dapat mengabaikan permintaan immersive ini.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final store = LocalStore();
  await store.seed();

  final authBloc = AuthBloc(store)..add(const AuthAppStarted());
  final appRouter = AppRouter(authBloc);

  runApp(
    CekBmikuApp(
      store: store,
      authBloc: authBloc,
      appRouter: appRouter,
    ),
  );
}

/// UI aplikasi: mode layar penuh berlaku pada semua route (Login, Daftar,
/// Beranda, kalkulator, profil, dan sebagainya).
/// Pada Android yang mendukung, bilah sistem akan kembali disembunyikan
/// setelah keyboard ditutup (Android memberi jeda sekitar satu detik).
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final keyboardVisible = WidgetsBinding.instance.platformDispatcher.views
        .any((view) => view.viewInsets.bottom > 0);
    if (keyboardVisible) {
      _restoreBarsTimer?.cancel();
    } else if (_wasKeyboardVisible) {
      // OS dapat menampilkan kembali bilahnya saat keyboard muncul.
      // Tunggu >= 1 detik sejak keyboard ditutup sebelum mengaktifkan ulang.
      _restoreBarsTimer?.cancel();
      _restoreBarsTimer = Timer(const Duration(milliseconds: 1200), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    }
    _wasKeyboardVisible = keyboardVisible;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.authBloc),
        BlocProvider(create: (_) => RegisterCubit(widget.store)),
        BlocProvider(create: (_) => ProfileCubit(widget.store)),
        BlocProvider(create: (_) => ArticleCubit(widget.store)..load()),
      ],
      child: MaterialApp.router(
        title: 'CekBMIku',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: widget.appRouter.router,
      ),
    );
  }
}
