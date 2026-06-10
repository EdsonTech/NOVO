import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/transaction.dart';

/// Contract the UI depends on. Swap the implementation (Supabase today, the
/// Spring Boot API tomorrow) without touching the presentation layer.
abstract class FinancesRepository {
  Future<List<Transaction>> fetch();
  Future<Transaction> add(Transaction tx);
  Future<void> delete(String id);
}

/// ---- Supabase implementation (managed PostgreSQL, table `transactions`) ----
class SupabaseFinancesRepository implements FinancesRepository {
  SupabaseFinancesRepository(this._db);
  final SupabaseClient _db;

  @override
  Future<List<Transaction>> fetch() async {
    final rows = await _db
        .from('transactions')
        .select()
        .order('date', ascending: false);
    return rows.map(Transaction.fromMap).toList();
  }

  @override
  Future<Transaction> add(Transaction tx) async {
    final row = await _db.from('transactions').insert(tx.toMap()).select().single();
    return Transaction.fromMap(row);
  }

  @override
  Future<void> delete(String id) =>
      _db.from('transactions').delete().eq('id', id);
}

/// ---- In-memory implementation (offline/mock mode) --------------------------
/// Lets the team build & demo the UI with no backend wired up.
class InMemoryFinancesRepository implements FinancesRepository {
  final List<Transaction> _items = [
    Transaction(id: '1', type: TxType.income, title: 'Salário', category: 'Salário', amount: 350000, date: DateTime(2026, 6, 1)),
    Transaction(id: '2', type: TxType.income, title: 'Negócio', category: 'Negócio', amount: 120000, date: DateTime(2026, 6, 3)),
    Transaction(id: '3', type: TxType.income, title: 'Freelance', category: 'Freelance', amount: 45000, date: DateTime(2026, 6, 5)),
    Transaction(id: '4', type: TxType.income, title: 'Comissões', category: 'Comissões', amount: 30000, date: DateTime(2026, 6, 8)),
    Transaction(id: '5', type: TxType.expense, title: 'Alimentação', category: 'Alimentação', amount: 95000, date: DateTime(2026, 6, 2)),
    Transaction(id: '6', type: TxType.expense, title: 'Transporte', category: 'Transporte', amount: 40000, date: DateTime(2026, 6, 4)),
    Transaction(id: '7', type: TxType.expense, title: 'Habitação', category: 'Habitação', amount: 80000, date: DateTime(2026, 6, 5)),
    Transaction(id: '8', type: TxType.expense, title: 'Educação', category: 'Educação', amount: 60000, date: DateTime(2026, 6, 6)),
    Transaction(id: '9', type: TxType.expense, title: 'Saúde', category: 'Saúde', amount: 25000, date: DateTime(2026, 6, 7)),
  ];

  @override
  Future<List<Transaction>> fetch() async => List.unmodifiable(_items);

  @override
  Future<Transaction> add(Transaction tx) async {
    final created = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: tx.type,
      title: tx.title,
      category: tx.category,
      amount: tx.amount,
      date: tx.date,
    );
    _items.insert(0, created);
    return created;
  }

  @override
  Future<void> delete(String id) async =>
      _items.removeWhere((t) => t.id == id);
}
