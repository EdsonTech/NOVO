import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/maju_widgets.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mais')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
        children: [
          const SectionTitle('Desafios & Negócios'),
          MajuList(children: [
            _row(context, Icons.emoji_events_outlined, 'Desafio 1 Milhão', Routes.challenge),
            _row(context, Icons.storefront_outlined, 'Centro de Negócios', Routes.academy),
            _row(context, Icons.shopping_bag_outlined, 'Marketplace MAJU', Routes.academy),
          ]),
          const SectionTitle('Aprender & Crescer'),
          MajuList(children: [
            _row(context, Icons.school_outlined, 'Academia MAJU', Routes.academy),
            _row(context, Icons.smart_toy_outlined, 'MAJU IA', Routes.aiChat),
          ]),
          const SectionTitle('Património & Crédito'),
          MajuList(children: [
            _row(context, Icons.home_outlined, 'Meus Activos', Routes.patrimony),
            _row(context, Icons.star_outline, 'Score MAJU', Routes.score),
          ]),
          const SectionTitle('Conta'),
          MajuList(children: [
            _row(context, Icons.settings_outlined, 'Configurações', Routes.settings),
          ]),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String title, String route) =>
      MajuListRow(icon: icon, title: title, trailing: '›', onTap: () => context.push(route));
}
