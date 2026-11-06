import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../cubits/profile/profile_cubit.dart';
import '../widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _age;
  String? _gender;

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthBloc>().state.user!;

    _name = TextEditingController(
      text: user.name,
    );

    _age = TextEditingController(
      text: user.age > 0 ? user.age.toString() : '',
    );

    _gender = (user.gender == 'L' || user.gender == 'P')
        ? user.gender
        : null;
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  void _save() {
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis kelamin terlebih dahulu.')),
      );
      return;
    }
    final current = context.read<AuthBloc>().state.user!;

    context.read<ProfileCubit>().updateProfile(
      current: current,
      name: _name.text,
      ageText: _age.text,
      gender: _gender!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message ?? 'Gagal menyimpan profil.',
              ),
            ),
          );
        }

        if (state.status == ProfileStatus.updated &&
            state.user != null) {
          context.read<AuthBloc>().add(
            AuthUserUpdated(state.user!),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message ?? 'Profil diperbarui.',
              ),
            ),
          );

          context.pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profil'),
        ),
        body: PageWidth(
          maxWidth: 600,
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur',
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'L',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'P',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading =
                      state.status == ProfileStatus.loading;

                  return FilledButton(
                    onPressed: isLoading ? null : _save,
                    child: Text(
                      isLoading
                          ? 'Menyimpan...'
                          : 'Simpan',
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