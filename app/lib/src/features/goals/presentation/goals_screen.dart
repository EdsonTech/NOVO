import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/goal.dart';
import 'goals_providers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sonhos')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MajuColors.orange500,
        foregroundColor: Colors.white,
        onPressed: () => context.push(Routes.createGoal),
        icon: const Icon(Icons.add),
        label: const Text('Nova meta'),
      ),
      body: goals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 90),
          children: [
            _challengeBanner(context),
            const SizedBox(height: 4),
            SectionTitle(
              'Sonhos Familiares',
              trailing: GestureDetector(
                onTap: () => context.push(Routes.simulator),
                child: const Text('Simulador',
                    style: TextStyle(color: MajuColors.blue700, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
            for (final g in list) ...[_goalCard(g), const SizedBox(height: 12)],
          ],
        ),
      ),
    );
  }

  Widget _challengeBanner(BuildContext context) => MajuCard(
        onTap: () => context.push(Routes.challenge),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [MajuColors.orange500, MajuColors.orange600]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.emoji_events_outlined, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Desafio 1 Milhão',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
                    Text('Plano inteligente para chegar a 1.000.000 Kz',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      );

  Widget _goalCard(Goal g) => MajuCard(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: MajuColors.orange100, borderRadius: BorderRadius.circular(12)),
                  child: Icon(goalIcon(g.icon), color: MajuColors.orange500),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${Money.kz(g.saved)} de ${Money.kz(g.target)}',
                          style: const TextStyle(fontSize: 12, color: MajuColors.ink3)),
                    ],
                  ),
                ),
                Text('${(g.progress * 100).round()}%',
                    style: const TextStyle(color: MajuColors.orange500, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: g.progress,
                minHeight: 9,
                backgroundColor: MajuColors.line,
                valueColor: const AlwaysStoppedAnimation(MajuColors.orange500),
              ),
            ),
          ],
        ),
      );
}
