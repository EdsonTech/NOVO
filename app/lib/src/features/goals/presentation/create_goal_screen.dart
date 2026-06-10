import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../../onboarding/presentation/onboarding_scaffold.dart';
import '../domain/goal.dart';
import 'goals_providers.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  static const _types = [
    ('home', 'Casa'),
    ('car', 'Viatura'),
    ('school', 'Universidade'),
    ('globe', 'Viagem'),
    ('store', 'Negócio'),
  ];

  String _icon = 'home';
  final _target = TextEditingController(text: '8.000.000');
  int _months = 24;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  num get _monthly {
    final t = Money.parse(_target.text);
    return _months == 0 ? 0 : (t / _months).round();
  }

  Future<void> _save() async {
    final goal = Goal(
      id: '',
      title: _types.firstWhere((e) => e.$1 == _icon).$2,
      icon: _icon,
      target: Money.parse(_target.text),
      saved: 0,
      deadline: DateTime.now().add(Duration(days: _months * 30)),
    );
    await ref.read(addGoalProvider)(goal);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta criada com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Definir Meta')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final (icon, label) in _types)
                SelectChip(
                  label: label,
                  selected: _icon == icon,
                  onTap: () => setState(() => _icon = icon),
                ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _target,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Valor da meta', suffixText: 'Kz'),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(
            value: _months,
            decoration: const InputDecoration(labelText: 'Prazo'),
            items: const [
              DropdownMenuItem(value: 12, child: Text('12 meses')),
              DropdownMenuItem(value: 24, child: Text('24 meses')),
              DropdownMenuItem(value: 36, child: Text('36 meses')),
              DropdownMenuItem(value: 60, child: Text('60 meses')),
            ],
            onChanged: (v) => setState(() => _months = v!),
          ),
          const SizedBox(height: 16),
          MajuCard(
            child: Column(
              children: [
                const Text('Contribuição mensal sugerida',
                    style: TextStyle(fontSize: 12, color: MajuColors.ink2)),
                const SizedBox(height: 4),
                Text(
                  Money.kz(_monthly),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    color: MajuColors.blue800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(onPressed: _save, child: const Text('Criar Meta')),
        ],
      ),
    );
  }
}
