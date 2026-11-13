import 'package:flutter_test/flutter_test.dart';
import 'package:cekbmiku/models/models.dart';
import 'package:cekbmiku/services/goal_store.dart';

BmiResult reading(DateTime at, double weight) => BmiResult(
      id: at.toIso8601String(),
      userEmail: 'contoh@cekbmiku.id',
      heightCm: 170,
      weightKg: weight,
      bmi: weight / (1.7 * 1.7),
      idealWeight: 63,
      category: 'Normal',
      gender: 'L',
      createdAt: at,
    );

void main() {
  test('tanggal mulai dan batas target tetap tersimpan pada JSON', () {
    final goal = BmiGoal(
      kind: GoalKind.weight,
      value: 65,
      createdAt: DateTime(2026, 11, 9, 10),
      startDate: DateTime(2026, 11, 10),
      deadline: DateTime(2027, 2, 10),
    );
    final restored = BmiGoal.fromJson(goal.toJson());
    expect(restored.startDate, DateTime(2026, 11, 10));
    expect(restored.deadline, DateTime(2027, 2, 10));
  });

  test('target lama tanpa startDate tetap dapat dibaca', () {
    final goal = BmiGoal.fromJson({
      'kind': 'weight',
      'value': 65,
      'createdAt': '2026-11-09T10:00:00.000',
      'deadline': '2027-02-09T00:00:00.000',
    });
    expect(goal.startDate, DateTime(2026, 11, 9));
  });

  test('progres dihitung hanya dari tanggal mulai sampai batas target', () {
    final goal = BmiGoal(
      kind: GoalKind.weight,
      value: 65,
      createdAt: DateTime(2026, 11, 2),
      startDate: DateTime(2026, 11, 3),
      deadline: DateTime(2026, 11, 10),
      baselineValue: 70,
    );
    final readings = [
      reading(DateTime(2026, 11, 2), 80),
      reading(DateTime(2026, 11, 3, 9), 70),
      reading(DateTime(2026, 11, 7, 11), 68),
      reading(DateTime(2026, 11, 11), 60),
    ];
    expect(GoalStore.recordsInPeriod(readings, goal).length, 2);
    expect(GoalStore.progressForTarget(readings, goal), closeTo(0.4, 1e-6));
  });
}
