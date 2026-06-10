import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/maju_widgets.dart';
import 'onboarding_scaffold.dart';

class FamilySituationScreen extends StatefulWidget {
  const FamilySituationScreen({super.key});

  @override
  State<FamilySituationScreen> createState() => _FamilySituationScreenState();
}

class _FamilySituationScreenState extends State<FamilySituationScreen> {
  static const _civil = ['Solteira', 'Casada', 'União de Facto', 'Divorciada'];
  static const _deps = ['0', '1', '2', '3+', 'Personalizado'];
  String _selectedCivil = 'Casada';
  String _selectedDeps = '2';

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 2,
      kicker: 'PASSO 2 DE 3',
      title: 'Situação Familiar',
      subtitle: 'Para adaptarmos metas e recomendações.',
      onNext: () => context.push(Routes.diagnostic),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final o in _civil)
                SelectChip(
                  label: o,
                  selected: _selectedCivil == o,
                  onTap: () => setState(() => _selectedCivil = o),
                ),
            ],
          ),
          const SectionTitle('Dependentes'),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final o in _deps)
                SelectChip(
                  label: o,
                  selected: _selectedDeps == o,
                  onTap: () => setState(() => _selectedDeps = o),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
