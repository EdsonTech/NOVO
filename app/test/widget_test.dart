import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju_app/src/features/finances/data/finances_repository.dart';
import 'package:maju_app/src/features/finances/domain/transaction.dart';
import 'package:maju_app/src/features/finances/presentation/finances_providers.dart';

void main() {
  test('FinanceSummary computes balance from transactions', () {
    final txs = [
      Transaction(id: '1', type: TxType.income, title: 'Salário', category: 'Salário', amount: 350000, date: DateTime(2026)),
      Transaction(id: '2', type: TxType.expense, title: 'Renda', category: 'Habitação', amount: 80000, date: DateTime(2026)),
    ];
    final s = FinanceSummary.from(txs);
    expect(s.income, 350000);
    expect(s.expense, 80000);
    expect(s.balance, 270000);
  });

  test('InMemory repository adds and lists transactions', () async {
    final repo = InMemoryFinancesRepository();
    final before = (await repo.fetch()).length;
    await repo.add(Transaction(id: '', type: TxType.income, title: 'Bónus', category: 'Outros', amount: 10000, date: DateTime(2026)));
    expect((await repo.fetch()).length, before + 1);
  });

  test('offline mode selects the in-memory repository', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      container.read(financesRepositoryProvider),
      isA<InMemoryFinancesRepository>(),
    );
  });
}
