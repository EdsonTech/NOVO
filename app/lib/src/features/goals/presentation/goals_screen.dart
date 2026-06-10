import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';

class _Goal {
  const _Goal(this.icon, this.title, this.goal, this.saved);
  final IconData icon;
  final String title;
  final num goal;
  final num saved;
  double get progress => (saved / goal).clamp(0, 1).toDouble();
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  static const _goals = [
    _Goal(Icons.home_outlined, 'Casa Própria', 8000000, 2600000),
    _Goal(Icons.directions_car_outlined, 'Viatura', 4500000, 1800000),
    _Goal(Icons.school_outlined, 'Universidade', 3000000, 900000),
    _Goal(Icons.public, 'Viagem', 1200000, 350000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sonhos')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
        children: [
          MajuCard(
            onTap: () {},
            padding: const EdgeInsets.all(16),
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
                        Text('Desafio 1 Milhão', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
                        Text('Plano inteligente para chegar a 1.000.000 Kz', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionTitle('Sonhos Familiares'),
          for (final g in _goals) ...[
            _goalCard(g),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _goalCard(_Goal g) {
    return MajuCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: MajuColors.orange100, borderRadius: BorderRadius.circular(12)),
                child: Icon(g.icon, color: MajuColors.orange500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('${Money.kz(g.saved)} de ${Money.kz(g.goal)}', style: const TextStyle(fontSize: 12, color: MajuColors.ink3)),
                  ],
                ),
              ),
              Text('${(g.progress * 100).round()}%', style: const TextStyle(color: MajuColors.orange500, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
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
}
