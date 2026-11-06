import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/models.dart';
import '../screens/article_detail_screen.dart';
import '../screens/article_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/lifestyle_recommendations_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';
import '../screens/bmi_reminder_screen.dart';
import '../screens/shell_screen.dart';
import '../screens/feature_pending_screen.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthBloc authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/calculator',
            builder: (context, state) => const FeaturePendingScreen(feature: 'Kalkulator BMI', description: 'Perhitungan BMI, validasi input, dan penyimpanan hasil akan dikerjakan pada tahap berikutnya.'),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const FeaturePendingScreen(feature: 'Riwayat Pemeriksaan & Grafik', description: 'Riwayat dan grafik perkembangan belum diaktifkan pada progres minggu ke-10.'),
          ),
          GoRoute(
            path: '/progress',
            builder: (context, state) => const FeaturePendingScreen(feature: 'ProgressBMIku', description: 'Perhitungan progres dan grafik terhadap target menjadi rencana pengembangan berikutnya.'),
          ),
          GoRoute(
            path: '/target',
            builder: (context, state) => const FeaturePendingScreen(feature: 'Target BMI', description: 'Pengaturan target BMI atau berat badan dan periode penyelesaiannya masih direncanakan.'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'feedback',
                builder: (context, state) => const FeaturePendingScreen(
                  feature: 'Umpan Balik',
                  description: 'Fitur umpan balik akan dikembangkan pada tahap berikutnya.'),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const BmiReminderScreen(),
      ),
      // Halaman detail berdiri sendiri, tanpa logo header dan navbar utama.
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/articles',
        builder: (context, state) => const ArticleScreen(),
        routes: [
          GoRoute(
            path: ':articleId',
            builder: (context, state) {
              final id = state.pathParameters['articleId']!;
              final article = state.extra is ArticleItem ? state.extra as ArticleItem : null;
              return ArticleDetailScreen(articleId: id, initialArticle: article);
            },
          ),
        ],
      ),
      // Halaman rekomendasi adalah detail full-screen, tanpa header dan
      // bottom navigation milik ShellScreen (sesuai tiga desain UI).
      GoRoute(
        path: '/recommendations',
        builder: (context, state) => const LifestyleRecommendationsScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const FeaturePendingScreen(
          feature: 'Hasil Pemeriksaan BMI',
          description: 'Fitur hasil pemeriksaan masih dalam tahap pengembangan.'),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const FeaturePendingScreen(
          feature: 'Website Admin',
          description: 'Website Admin dengan Laravel dan MySQL merupakan tahap selanjutnya.'),
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final auth = authBloc.state;
    final location = state.uri.path;
    final isPublic = location == '/login' || location == '/register';

    // While checking a saved session, don't allow navigation into app pages.
    if (auth.status == AuthStatus.initial || auth.status == AuthStatus.loading) {
      return isPublic ? null : '/login';
    }

    // Guest and failed login must never access Home, BMI, Profile, or Admin.
    if (!auth.isAuthenticated && !auth.isAdmin) {
      if (isPublic) return null;
      return '/login?redirect=${Uri.encodeComponent(state.uri.toString())}';
    }

    // Admin is restricted to the admin dashboard.
    if (auth.isAdmin) {
      return location == '/admin' ? null : '/admin';
    }

    // Regular users can only open standard user pages.
    if (location == '/admin') return '/home';
    if (isPublic) {
      final requested = state.uri.queryParameters['redirect'];
      if (requested != null &&
          requested.startsWith('/') &&
          !requested.startsWith('//') &&
          requested != '/login' &&
          !requested.startsWith('/login?') &&
          requested != '/register' &&
          !requested.startsWith('/register?') &&
          !requested.startsWith('/admin')) {
        return requested;
      }
      return '/home';
    }
    return null;
  }
}
