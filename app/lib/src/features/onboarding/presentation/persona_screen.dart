import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import 'onboarding_scaffold.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  static const _options = [
    'Mulher', 'Homem', 'Casal', 'Mãe Solteira',
    'Empreendedora', 'Funcionária Pública', 'Trabalhadora Independente',
  ];
  String _selected = 'Empreendedora';

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      kicker: 'PASSO 1 DE 3',
      title: 'Quem é você?',
      subtitle: 'Vamos personalizar a sua jornada financeira.',
      onNext: () => context.push(Routes.family),
      body: Wrap(
        spacing: 9,
        runSpacing: 9,
        children: [
          for (final o in _options)
            SelectChip(
              label: o,
              selected: _selected == o,
              onTap: () => setState(() => _selected = o),
            ),
        ],
      ),
    );
  }
}
