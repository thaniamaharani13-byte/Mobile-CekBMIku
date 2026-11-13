import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BMI formula example', () {
    const heightCm = 170.0;
    const weightKg = 65.0;
    final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
    expect(bmi.toStringAsFixed(1), '22.5');
  });
}
