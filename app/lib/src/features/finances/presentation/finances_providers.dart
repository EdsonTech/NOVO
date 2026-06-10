import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/finances_repository.dart';
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
