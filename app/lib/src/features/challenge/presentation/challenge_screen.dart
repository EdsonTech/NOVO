import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';

/// Desafio 1 Milhão — objetivo + plano inteligente + plano de crescimento.
class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  static const _goal = 1000000;
  static const _achieved = 420000;

  @override
  Widget build(BuildContext context) {
    final progress = _achieved / _goal;
    return Scaffold(
      appBar: AppBar(title: const Text('Desafio 1 Milhão')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [MajuColors.orange500, MajuColors.orange600]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meu Objetivo', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(Money.kz(_goal),
                    style: const TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 30, color: Colors.white)),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${Money.kz(_achieved)} alcançados · faltam ${Money.kz(_goal - _achieved)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SectionTitle('Plano Inteligente'),
          Row(
            children: [
              Expanded(child: _miniStat('Atual', '545k', MajuColors.blue700, MajuColors.blue100)),
              const SizedBox(width: 10),
              Expanded(child: _miniStat('Desejada', '850k', MajuColors.green500, MajuColors.green100)),
              const SizedBox(width: 10),
              Expanded(child: _miniStat('Gap', '305k', MajuColors.orange500, MajuColors.orange100)),
            ],
          ),
          const SizedBox(height: 12),
          const MajuCard(
            child: Text(
              'Aumentar a receita do negócio em 305.000 Kz/mês fecha o objetivo em 6 meses.',
              style: TextStyle(fontSize: 13, color: MajuColors.ink2),
            ),
          ),
          const SectionTitle('Plano de Crescimento'),
          MajuList(children: [
            _row(Icons.storefront_outlined, 'Expandir Negócio', '+150.000 Kz/mês potencial'),
            _row(Icons.shopping_cart_outlined, 'Vendas Online', '+90.000 Kz/mês'),
            _row(Icons.build_outlined, 'Serviços', '+65.000 Kz/mês'),
            _row(Icons.trending_up, 'Investimentos', '+40.000 Kz/mês'),
          ]),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color fg, Color bg) => MajuCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
              child: Icon(Icons.bolt, color: fg, size: 16),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 11, color: MajuColors.ink2)),
            Text(value, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      );

  Widget _row(IconData icon, String title, String sub) =>
      MajuListRow(icon: icon, iconColor: MajuColors.orange500, iconBg: MajuColors.orange100, title: title, subtitle: sub);
}
