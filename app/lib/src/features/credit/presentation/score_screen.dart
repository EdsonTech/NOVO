import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/credit_score.dart';
import 'credit_providers.dart';

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(creditScoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Score MAJU')),
      body: score.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (s) => ListView(
          padding: const EdgeInsets.all(18),
          children: [
            MajuCard(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _gauge(s),
                  const SizedBox(height: 16),
                  Text('Score Familiar · ${s.band}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: MajuColors.green500)),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const MajuCard(
              child: Text(
                'O seu histórico de poupança consistente e baixo endividamento elevam o '
                'score. Mantenha as metas em dia para subir de escalão.',
                style: TextStyle(fontSize: 13, color: MajuColors.ink2),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push(Routes.eligibility),
              child: const Text('Ver Elegibilidade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gauge(CreditScore s) => SizedBox(
        width: 170,
        height: 170,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 170,
              height: 170,
              child: CircularProgressIndicator(
                value: s.fraction,
                strokeWidth: 13,
                strokeCap: StrokeCap.round,
                backgroundColor: MajuColors.line,
                valueColor: const AlwaysStoppedAnimation(MajuColors.green500),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${s.value}',
                    style: const TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 44, color: MajuColors.blue800, height: 1)),
                const Text('de 1000', style: TextStyle(color: MajuColors.ink3, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      );
}
