import 'package:flutter_test/flutter_test.dart';
import 'package:maju_app/src/features/credit/domain/credit_score.dart';

void main() {
  group('CreditScoreCalculator', () {
    test('high savings + low debt yields a strong score', () {
      final s = CreditScoreCalculator.compute(
        income: 545000, expense: 300000, debts: 0, goalsProgress: 0.8,
      );
      expect(s.value, greaterThan(700));
      expect(['Bom', 'Excelente'], contains(s.band));
    });

    test('heavy debt drags the score down', () {
      final high = CreditScoreCalculator.compute(income: 500000, expense: 300000, debts: 0);
      final low = CreditScoreCalculator.compute(income: 500000, expense: 300000, debts: 1500000);
      expect(low.value, lessThan(high.value));
    });

    test('score is clamped to 0..1000', () {
      final s = CreditScoreCalculator.compute(
        income: 1000000, expense: 0, debts: 0, goalsProgress: 1,
      );
      expect(s.value, inInclusiveRange(0, 1000));
    });

    test('zero income returns the 400 baseline', () {
      expect(CreditScoreCalculator.compute(income: 0, expense: 0, debts: 0).value, 400);
    });

    test('eligibility tracks the score thresholds', () {
      final strong = CreditScoreCalculator.eligibility(const CreditScore(820));
      expect(strong.first.eligible, isTrue); // microcrédito
      final weak = CreditScoreCalculator.eligibility(const CreditScore(450));
      expect(weak.every((e) => !e.eligible), isTrue);
    });
  });
}
