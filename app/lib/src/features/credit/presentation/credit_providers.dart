import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../finances/presentation/finances_providers.dart';
import '../../goals/presentation/goals_providers.dart';
import '../domain/credit_score.dart';

/// Computes the MAJU score from live finances, debts and goals progress.
final creditScoreProvider = Provider<AsyncValue<CreditScore>>((ref) {
  final summary = ref.watch(financeSummaryProvider);
  final debts = ref.watch(debtsProvider);
  final goals = ref.watch(goalsProvider);

  return summary.whenData((s) {
    final totalDebt = debts.fold<num>(0, (t, d) => t + d.balance);
    final goalsProgress = goals.maybeWhen(
      data: (list) => list.isEmpty
          ? 0.0
          : list.map((g) => g.progress).reduce((a, b) => a + b) / list.length,
      orElse: () => 0.0,
    );
    return CreditScoreCalculator.compute(
      income: s.income,
      expense: s.expense,
      debts: totalDebt,
      goalsProgress: goalsProgress,
    );
  });
});

final eligibilityProvider = Provider<AsyncValue<List<Eligibility>>>((ref) {
  return ref.watch(creditScoreProvider).whenData(CreditScoreCalculator.eligibility);
});
