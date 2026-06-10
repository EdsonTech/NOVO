import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../../finances/presentation/finances_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(financeSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MAJU'),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: summary.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (s) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
          children: [
            const Text.rich(
              TextSpan(
                text: 'Olá, ',
                style: TextStyle(color: MajuColors.ink2, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Maria 👋',
                    style: TextStyle(color: MajuColors.blue800, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            HeroBalanceCard(
              label: 'Saldo Familiar',
              value: Money.kz(s.balance),
              left: (label: 'Receitas', value: Money.kz(s.income)),
              right: (label: 'Despesas', value: Money.kz(s.expense)),
            ),
            const SizedBox(height: 14),
            _quickActions(context),
            const SectionTitle('Indicadores'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: [
                const StatTile(icon: Icons.trending_up, label: 'Crescimento Mensal', value: '+12%', color: MajuColors.green500, bg: MajuColors.green100),
                StatTile(icon: Icons.savings_outlined, label: 'Poupança', value: Money.kzShort(s.balance), color: MajuColors.orange500, bg: MajuColors.orange100),
                const StatTile(icon: Icons.flag_outlined, label: 'Sonhos Ativos', value: '4', color: MajuColors.blue700, bg: MajuColors.blue100),
                const StatTile(icon: Icons.home_outlined, label: 'Património', value: '24,1 M', color: MajuColors.green500, bg: MajuColors.green100),
              ],
            ),
            const SectionTitle('Recomendação da IA'),
            MajuCard(
              onTap: () => context.push(Routes.aiChat),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: MajuColors.blue100, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.smart_toy_outlined, color: MajuColors.blue700),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Reduza 8% em transporte e atinja a meta da Viatura 2 meses antes.',
                      style: TextStyle(fontSize: 13, color: MajuColors.ink2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    final items = [
      (Icons.add, 'Receita', () => context.push('${Routes.addTransaction}?type=income')),
      (Icons.remove, 'Despesa', () => context.push('${Routes.addTransaction}?type=expense')),
      (Icons.flag_outlined, 'Meta', () => context.go(Routes.goals)),
      (Icons.storefront_outlined, 'Negócio', () => context.go(Routes.more)),
    ];
    return Row(
      children: [
        for (final (icon, label, onTap) in items)
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: MajuColors.card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x0F102A4F), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: Icon(icon, color: MajuColors.blue700),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MajuColors.ink2)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
