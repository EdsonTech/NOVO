import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/finances_repository.dart';
import '../domain/cash_flow.dart';
import '../domain/transaction.dart';

/// Picks the live (Supabase) or mock (in-memory) repository based on config.
final financesRepositoryProvider = Provider<FinancesRepository>((ref) {
  if (Env.hasBackend) {
    return SupabaseFinancesRepository(Supabase.instance.client);
  }
  return InMemoryFinancesRepository();
});

/// All transactions, loaded async.
final transactionsProvider = FutureProvider<List<Transaction>>((ref) {
  return ref.watch(financesRepositoryProvider).fetch();
});

/// Aggregated totals derived from [transactionsProvider].
final financeSummaryProvider = Provider<AsyncValue<FinanceSummary>>((ref) {
  return ref.watch(transactionsProvider).whenData(FinanceSummary.from);
});

class FinanceSummary {
  const FinanceSummary({required this.income, required this.expense});

  final num income;
  final num expense;
  num get balance => income - expense;

  factory FinanceSummary.from(List<Transaction> txs) {
    num inc = 0, exp = 0;
    for (final t in txs) {
      if (t.type == TxType.income) {
        inc += t.amount;
      } else {
        exp += t.amount;
      }
    }
    return FinanceSummary(income: inc, expense: exp);
  }
}

/// Adds a transaction then refreshes the list.
final addTransactionProvider =
    Provider<Future<void> Function(Transaction)>((ref) {
  return (tx) async {
    await ref.read(financesRepositoryProvider).add(tx);
    ref.invalidate(transactionsProvider);
  };
});

/// Six-month cash-flow series for the Fluxo de Caixa chart.
/// TODO(S5): derive from `transactions` grouped by month once history exists.
final cashflowProvider = Provider<List<MonthlyFlow>>((ref) {
  return const [
    MonthlyFlow(label: 'Jan', income: 420000, expense: 380000),
    MonthlyFlow(label: 'Fev', income: 480000, expense: 410000),
    MonthlyFlow(label: 'Mar', income: 510000, expense: 430000),
    MonthlyFlow(label: 'Abr', income: 540000, expense: 460000),
    MonthlyFlow(label: 'Mai', income: 500000, expense: 440000),
    MonthlyFlow(label: 'Jun', income: 545000, expense: 410000),
  ];
});

/// Active debts and a simple liquidation outlook.
final debtsProvider = Provider<List<Debt>>((ref) {
  return const [
    Debt(title: 'Empréstimo BAI', kind: 'Empréstimo', balance: 1200000, installments: 24),
    Debt(title: 'Cartão de Crédito', kind: 'Cartão', balance: 180000, installments: 0),
    Debt(title: 'Crédito Informal (Kixikila)', kind: 'Informal', balance: 90000, installments: 3),
  ];
});
