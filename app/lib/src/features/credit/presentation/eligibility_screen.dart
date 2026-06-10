import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/credit_score.dart';
import 'credit_providers.dart';

class EligibilityScreen extends ConsumerWidget {
  const EligibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibility = ref.watch(eligibilityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Elegibilidade')),
      body: eligibility.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(18),
          children: [
            MajuList(children: [for (final e in items) _row(e)]),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: items.first.eligible
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido de microcrédito submetido!')),
                      )
                  : null,
              child: const Text('Solicitar Microcrédito'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Eligibility e) => MajuListRow(
        icon: switch (e.title) {
          'Microcrédito' => Icons.credit_card,
          'Seguro Familiar' => Icons.shield_outlined,
          _ => Icons.trending_up,
        },
        iconColor: e.eligible ? MajuColors.green500 : MajuColors.ink3,
        iconBg: e.eligible ? MajuColors.green100 : MajuColors.line,
        title: e.title,
        subtitle: e.detail,
        trailing: e.eligible ? 'Elegível' : '—',
        amountColor: e.eligible ? MajuColors.green500 : MajuColors.ink3,
      );
}
