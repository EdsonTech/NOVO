import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/cash_flow.dart';
import 'finances_providers.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(debtsProvider);
    final total = debts.fold<num>(0, (t, d) => d.balance + t);
    const monthly = 150000; // suggested payment
    final months = (total / monthly).ceil();

    return Scaffold(
      appBar: AppBar(title: const Text('Dívidas')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          MajuList(children: [for (final d in debts) _row(d)]),
          const SectionTitle('Plano de Liquidação'),
          MajuCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Método avalanche',
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Pagando ${Money.kz(monthly)}/mês, fica livre de dívidas em '
                  '$months meses e poupa em juros.',
                  style: const TextStyle(fontSize: 13, color: MajuColors.ink2),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: const LinearProgressIndicator(
                    value: 0.38,
                    minHeight: 9,
                    backgroundColor: MajuColors.line,
                    valueColor: AlwaysStoppedAnimation(MajuColors.green500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(Debt d) => MajuListRow(
        icon: switch (d.kind) {
          'Cartão' => Icons.credit_card,
          'Informal' => Icons.handshake_outlined,
          _ => Icons.account_balance,
        },
        iconColor: MajuColors.orange500,
        iconBg: MajuColors.orange100,
        title: d.title,
        subtitle: 'Saldo ${Money.kz(d.balance)}',
        trailing: d.installments > 0 ? '${d.installments}x' : 'rotativo',
        amountColor: MajuColors.red500,
      );
}
