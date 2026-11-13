import 'package:flutter_test/flutter_test.dart';
import 'package:cekbmiku/core/broca_calculator.dart';

void main() {
  group('Rumus Broca berdasarkan pilihan tombol', () {
    test('Pria 170 cm: kurangi 10% => 63 kg', () {
      expect(BrocaCalculator.estimate(heightCm: 170, gender: 'L'), 63.0);
    });
    test('Wanita 170 cm: kurangi 15% => 59,5 kg', () {
      expect(BrocaCalculator.estimate(heightCm: 170, gender: 'P'), 59.5);
    });
    test('Hasil pria dan wanita tidak sama untuk tinggi yang sama', () {
      final pria = BrocaCalculator.estimate(heightCm: 160, gender: 'L');
      final wanita = BrocaCalculator.estimate(heightCm: 160, gender: 'P');
      expect(pria, 54.0);
      expect(wanita, 51.0);
      expect(pria, isNot(wanita));
    });
    test('Broca tidak tersedia untuk tinggi <= 100 cm', () {
      expect(BrocaCalculator.estimate(heightCm: 100, gender: 'L'), isNull);
      expect(BrocaCalculator.estimate(heightCm: 90, gender: 'P'), isNull);
    });
  });
}
