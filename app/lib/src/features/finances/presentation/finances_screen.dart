import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/transaction.dart';
import 'finances_providers.dart';

class FinancesScreen extends ConsumerWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsProvider);
    final summary = ref.watch(financeSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Finanças')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MajuColors.orange500,
        foregroundColor: Colors.white,
        onPressed: () => context.push('${Routes.addTransaction}?type=income'),
        icon: const Icon(Icons.add),
        label: const Text('Movimento'),
      ),
      body: txs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 90),
          children: [
            summary.maybeWhen(
              data: (s) => HeroBalanceCard(
                label: 'Resultado do mês',
                value: Money.kz(s.balance),
                left: (label: 'Entradas', value: Money.kz(s.income)),
                right: (label: 'Saídas', value: Money.kz(s.expense)),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SectionTitle('Movimentos'),
            MajuList(
              children: [
                for (final t in list) _row(t),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Transaction t) {
    final income = t.type == TxType.income;
    return MajuListRow(
      icon: income ? Icons.south_west : Icons.north_east,
      iconColor: income ? MajuColors.green500 : MajuColors.red500,
      iconBg: income ? MajuColors.green100 : MajuColors.red100,
      title: t.title,
      subtitle: t.category,
      trailing: '${income ? '+' : '-'}${Money.kz(t.amount)}',
      amountColor: income ? MajuColors.green500 : MajuColors.red500,
    );
  }
}
