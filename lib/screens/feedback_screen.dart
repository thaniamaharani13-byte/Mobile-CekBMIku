import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/feedback/feedback_cubit.dart';
import '../widgets/common_widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    final user = context.read<AuthBloc>().state.user!;
    context.read<FeedbackCubit>().submit(user: user, message: _message.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Gagal mengirim masukan.')),
          );
        }
        if (state.status == FeedbackStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Masukan terkirim.')),
          );
          context.read<FeedbackCubit>().reset();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Masukan')),
        body: PageWidth(
          maxWidth: 650,
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const SectionTitle(
                'Kirim Masukan',
                subtitle: 'Validasi dan penyimpanan ditangani FeedbackCubit.',
              ),
              TextField(
                controller: _message,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Masukan kamu',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 18),
              BlocBuilder<FeedbackCubit, FeedbackState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed:
                        state.status == FeedbackStatus.loading ? null : _submit,
                    child: Text(
                      state.status == FeedbackStatus.loading
                          ? 'Mengirim...'
                          : 'Kirim Masukan',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
