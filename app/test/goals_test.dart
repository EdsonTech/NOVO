import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju_app/src/features/goals/data/goals_repository.dart';
import 'package:maju_app/src/features/goals/domain/goal.dart';
import 'package:maju_app/src/features/goals/presentation/goals_providers.dart';

void main() {
  test('Goal computes progress and remaining', () {
    const g = Goal(id: '1', title: 'Casa', icon: 'home', target: 8000000, saved: 2000000);
    expect(g.progress, closeTo(0.25, 0.001));
    expect(g.remaining, 6000000);
  });

  test('progress is clamped to 1 when over-saved', () {
    const g = Goal(id: '1', title: 'Viagem', icon: 'globe', target: 1000, saved: 5000);
    expect(g.progress, 1.0);
    expect(g.remaining, 0);
  });

  test('InMemory goals repository adds a goal', () async {
    final repo = InMemoryGoalsRepository();
    final before = (await repo.fetch()).length;
    await repo.add(const Goal(id: '', title: 'Moto', icon: 'car', target: 900000, saved: 0));
    expect((await repo.fetch()).length, before + 1);
  });

  test('offline mode selects the in-memory goals repository', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(goalsRepositoryProvider), isA<InMemoryGoalsRepository>());
  });
}
