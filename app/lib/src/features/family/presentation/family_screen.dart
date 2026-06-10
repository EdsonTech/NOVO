import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/widgets/maju_widgets.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      ('MS', MajuColors.blue500, 'Maria Silva', 'Administradora'),
      ('JS', MajuColors.orange500, 'João Silva', 'Cônjuge'),
      ('AS', MajuColors.green500, 'Ana Silva', 'Filha · 12 anos'),
      ('PS', MajuColors.amber500, 'Pedro Silva', 'Filho · 8 anos'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Família')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
        children: [
          MajuList(
            children: [
              for (final (ini, color, name, role) in members)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: color,
                        child: Text(ini, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(role, style: const TextStyle(fontSize: 12, color: MajuColors.ink3)),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Convidar membro'),
          ),
          const SectionTitle('Conselho Familiar · Junho'),
          MajuCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Recomendação da IA', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
                SizedBox(height: 6),
                Text(
                  'A família poupou 12% acima da meta. Sugerimos reforçar o fundo "Casa Própria" com o excedente.',
                  style: TextStyle(fontSize: 13, color: MajuColors.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
