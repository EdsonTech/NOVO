import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/asset.dart';
import 'patrimony_providers.dart';

class PatrimonyScreen extends ConsumerWidget {
  const PatrimonyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsProvider);
    final summary = ref.watch(patrimonySummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Activos')),
      body: assets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
          children: [
            summary.maybeWhen(
              data: (s) => HeroBalanceCard(
                label: 'Património Líquido',
                value: Money.kz(s.net),
                left: (label: 'Activos', value: Money.kz(s.assets)),
                right: (label: 'Passivos', value: Money.kz(s.liabilities)),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SectionTitle('Activos & Passivos'),
            MajuList(children: [for (final a in list) _row(a)]),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => context.push(Routes.patrimonyEvolution),
              icon: const Icon(Icons.show_chart),
              label: const Text('Evolução Patrimonial'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Asset a) => MajuListRow(
        icon: assetIcon(a.category),
        iconColor: a.isLiability ? MajuColors.red500 : MajuColors.green500,
        iconBg: a.isLiability ? MajuColors.red100 : MajuColors.green100,
        title: a.title,
        subtitle: a.isLiability ? 'Passivo' : 'Activo',
        trailing: '${a.isLiability ? '-' : ''}${Money.kz(a.value)}',
        amountColor: a.isLiability ? MajuColors.red500 : MajuColors.ink,
      );
}
