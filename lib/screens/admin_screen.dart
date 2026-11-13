import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../core/app_theme.dart';
import '../cubits/admin/admin_cubit.dart';
import '../widgets/common_widgets.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              // GoRouter redirects to /login when logout completes.
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state.status == AdminStatus.loading ||
              state.status == AdminStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return PageWidth(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SectionTitle('Ringkasan Data'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(label: 'Pengguna', value: state.users.length),
                    _StatCard(label: 'Riwayat BMI', value: state.history.length),
                    _StatCard(label: 'Masukan', value: state.feedback.length),
                    _StatCard(label: 'Artikel', value: state.articles.length),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionTitle('Pengguna'),
                if (state.users.isEmpty)
                  const Text('Belum ada pengguna.')
                else
                  ...state.users.map(
                    (user) => Card(
                      child: ListTile(
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => context
                              .read<AdminCubit>()
                              .deleteUser(user.email),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                const SectionTitle('Masukan Terbaru'),
                if (state.feedback.isEmpty)
                  const Text('Belum ada masukan.')
                else
                  ...state.feedback.take(5).map(
                        (item) => Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.chat_bubble_outline,
                              color: AppColors.pink,
                            ),
                            title: Text(item.userName),
                            subtitle: Text(item.message),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 6),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
