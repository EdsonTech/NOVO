import 'package:flutter/material.dart';

import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';

/// "Quanto preciso poupar?" — simple savings simulator.
class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final _target = TextEditingController(text: '4.500.000');
  int _months = 24;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  num get _perMonth {
    final t = Money.parse(_target.text);
    return _months == 0 ? 0 : (t / _months).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          MajuCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quanto preciso poupar?',
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 14),
                TextField(
                  controller: _target,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'Objetivo', suffixText: 'Kz'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  value: _months,
                  decoration: const InputDecoration(labelText: 'Em quanto tempo'),
                  items: const [
                    DropdownMenuItem(value: 12, child: Text('1 ano')),
                    DropdownMenuItem(value: 24, child: Text('2 anos')),
                    DropdownMenuItem(value: 36, child: Text('3 anos')),
                  ],
                  onChanged: (v) => setState(() => _months = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          HeroBalanceCard(label: 'Precisa poupar por mês', value: Money.kz(_perMonth)),
        ],
      ),
    );
  }
}
