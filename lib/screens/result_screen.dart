import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../data/app_content.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final BmiResult? result;

  @override
  Widget build(BuildContext context) {
    final item = result;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hasil BMI')),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('Kembali ke Home'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil BMI')),
      body: PageWidth(
        maxWidth: 760,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('BMI Kamu'),
                  const SizedBox(height: 8),
                  Text(
                    item.bmi.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pink,
                    ),
                  ),
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(categorySubtitle(item.category)),
                  const Divider(height: 32),
                  Text(
                    'Estimasi berat ideal: ${item.idealWeight.toStringAsFixed(1)} kg',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _InfoCard(title: 'Saran Makanan', text: foodSuggestion(item.category)),
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Vitamin & Kebiasaan',
              text: vitaminSuggestion(item.category),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/calculator'),
              child: const Text('Hitung Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
