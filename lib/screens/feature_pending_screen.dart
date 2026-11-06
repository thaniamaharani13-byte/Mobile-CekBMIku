import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Halaman informasi untuk fitur yang belum dikerjakan pada minggu ke-10.
/// Tidak ada simulasi angka BMI, riwayat, atau progres palsu.
class FeaturePendingScreen extends StatelessWidget {
  const FeaturePendingScreen({super.key, required this.feature, required this.description});

  final String feature;
  final String description;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2962EF);
    const ink = Color(0xFF192F52);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3FF),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(Icons.construction_outlined, size: 46, color: blue),
              ),
              const SizedBox(height: 20),
              Text(feature, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 21, color: ink, fontWeight: FontWeight.w800)),
              const SizedBox(height: 9),
              const Text('Dalam Pengembangan',
                style: TextStyle(fontSize: 14, color: blue, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(description, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, height: 1.55, color: Color(0xFF788BAB))),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/home'),
                  style: FilledButton.styleFrom(backgroundColor: blue,
                    minimumSize: const Size.fromHeight(48)),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Progres implementasi aplikasi: Minggu ke-10',
                style: TextStyle(fontSize: 11, color: Color(0xFF788BAB))),
            ],
          ),
        ),
      ),
    );
  }
}
