import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/goals_repository.dart';
import '../domain/goal.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  if (Env.hasBackend) {
    return SupabaseGoalsRepository(Supabase.instance.client);
  }
  return InMemoryGoalsRepository();
});

final goalsProvider = FutureProvider<List<Goal>>((ref) {
  return ref.watch(goalsRepositoryProvider).fetch();
});

final addGoalProvider = Provider<Future<void> Function(Goal)>((ref) {
  return (goal) async {
    await ref.read(goalsRepositoryProvider).add(goal);
    ref.invalidate(goalsProvider);
  };
});

/// Maps the stored logical icon name to a Material icon.
IconData goalIcon(String name) => switch (name) {
      'home' => Icons.home_outlined,
      'car' => Icons.directions_car_outlined,
      'school' => Icons.school_outlined,
      'globe' => Icons.public,
      'store' => Icons.storefront_outlined,
      _ => Icons.flag_outlined,
    };
