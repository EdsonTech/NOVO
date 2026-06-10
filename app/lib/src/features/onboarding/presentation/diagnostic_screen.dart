import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import '../../../core/widgets/maju_widgets.dart';
import 'onboarding_scaffold.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  final _income = {'Salário': true, 'Negócio': true, 'Outros': false};
  final _expenses = <String, bool>{
    'Alimentação': true, 'Escola': true, 'Transporte': true, 'Energia': true,
    'Água': true, 'Internet': true, 'Saúde': true,
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      kicker: 'PASSO 3 DE 3',
      title: 'Diagnóstico Financeiro',
      subtitle: 'Receitas e despesas para começar.',
      ctaLabel: 'Concluir',
      onNext: () => context.go(Routes.home),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Receita mensal', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final e in _income.entries)
                SelectChip(
                  label: e.key,
                  selected: e.value,
                  onTap: () => setState(() => _income[e.key] = !e.value),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '545.000', suffixText: 'Kz'),
          ),
          const SectionTitle('Despesas principais'),
          for (final e in _expenses.entries) _categoryRow(e.key, e.value),
        ],
      ),
    );
  }

  Widget _categoryRow(String name, bool on) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _expenses[name] = !on),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: on ? MajuColors.orange100 : MajuColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: on ? MajuColors.orange500 : MajuColors.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Icon(
                on ? Icons.check_circle : Icons.circle_outlined,
                color: on ? MajuColors.orange500 : MajuColors.ink3,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
