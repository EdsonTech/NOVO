import 'package:flutter/material.dart';

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
            _row(Icons.emoji_events_outlined, 'Desafio 1 Milhão'),
            _row(Icons.storefront_outlined, 'Centro de Negócios'),
            _row(Icons.shopping_bag_outlined, 'Marketplace MAJU'),
          ]),
          const SectionTitle('Aprender & Crescer'),
          MajuList(children: [
            _row(Icons.school_outlined, 'Academia MAJU'),
            _row(Icons.smart_toy_outlined, 'MAJU IA'),
          ]),
          const SectionTitle('Património & Crédito'),
          MajuList(children: [
            _row(Icons.home_outlined, 'Meus Activos'),
            _row(Icons.star_outline, 'Score MAJU'),
          ]),
          const SectionTitle('Conta'),
          MajuList(children: [
            _row(Icons.settings_outlined, 'Configurações'),
          ]),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String title) =>
      MajuListRow(icon: icon, title: title, trailing: '›', onTap: () {});
}
