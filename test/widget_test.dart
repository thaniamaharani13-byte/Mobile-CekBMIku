import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cekbmiku/screens/feature_pending_screen.dart';
import 'package:cekbmiku/data/editorial_articles.dart';
import 'package:cekbmiku/data/lifestyle_tips.dart';

void main() {
  test('Materi contoh sesuai cakupan progres minggu ke-10', () {
    expect(editorialArticles.length, 3);
    expect(LifestyleTips.food.length, 2);
    expect(LifestyleTips.activity.length, 2);
    expect(LifestyleTips.lifestyle.length, 2);
  });

  testWidgets('Fitur lanjutan menampilkan status belum selesai', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: FeaturePendingScreen(
          feature: 'Kalkulator BMI',
          description: 'Masih direncanakan pada tahap berikutnya.',
        ),
      ),
    ));
    expect(find.text('Dalam Pengembangan'), findsOneWidget);
    expect(find.text('Kalkulator BMI'), findsOneWidget);
  });
}
