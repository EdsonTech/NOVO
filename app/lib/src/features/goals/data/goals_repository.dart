import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/goal.dart';

/// Contract for goals/sonhos persistence. Same swap pattern as finances.
abstract class GoalsRepository {
  Future<List<Goal>> fetch();
  Future<Goal> add(Goal goal);
}

/// ---- Supabase implementation (table `goals`) -------------------------------
class SupabaseGoalsRepository implements GoalsRepository {
  SupabaseGoalsRepository(this._db);
  final SupabaseClient _db;

  @override
  Future<List<Goal>> fetch() async {
    final rows = await _db.from('goals').select().order('created_at');
    return rows.map(Goal.fromMap).toList();
  }

  @override
  Future<Goal> add(Goal goal) async {
    final row = await _db.from('goals').insert(goal.toMap()).select().single();
    return Goal.fromMap(row);
  }
}

/// ---- In-memory implementation (offline/mock) -------------------------------
class InMemoryGoalsRepository implements GoalsRepository {
  final List<Goal> _items = [
    const Goal(id: '1', title: 'Casa Própria', icon: 'home', target: 8000000, saved: 2600000),
    const Goal(id: '2', title: 'Viatura', icon: 'car', target: 4500000, saved: 1800000),
    const Goal(id: '3', title: 'Universidade', icon: 'school', target: 3000000, saved: 900000),
    const Goal(id: '4', title: 'Viagem', icon: 'globe', target: 1200000, saved: 350000),
  ];

  @override
  Future<List<Goal>> fetch() async => List.unmodifiable(_items);

  @override
  Future<Goal> add(Goal goal) async {
    final created = Goal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: goal.title,
      icon: goal.icon,
      target: goal.target,
      saved: goal.saved,
      deadline: goal.deadline,
    );
    _items.add(created);
    return created;
  }
}
