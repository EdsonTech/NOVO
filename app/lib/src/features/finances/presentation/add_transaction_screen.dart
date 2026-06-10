import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/currency.dart';
import '../domain/transaction.dart';
import 'finances_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({required this.isIncome, super.key});
  final bool isIncome;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  late String _category = _categories.first;
  bool _saving = false;

  List<String> get _categories => widget.isIncome
      ? const ['Salário', 'Negócio', 'Freelance', 'Comissões', 'Outros']
      : const ['Alimentação', 'Transporte', 'Habitação', 'Educação', 'Saúde', 'Telecomunicações'];

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final tx = Transaction(
      id: '',
      type: widget.isIncome ? TxType.income : TxType.expense,
      title: _title.text.trim().isEmpty ? _category : _title.text.trim(),
      category: _category,
      amount: Money.parse(_amount.text),
      date: DateTime.now(),
    );
    await ref.read(addTransactionProvider)(tx);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guardado com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isIncome ? 'Nova Receita' : 'Nova Despesa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor', suffixText: 'Kz'),
              validator: (v) => Money.parse(v ?? '') <= 0 ? 'Indique um valor' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: [for (final c in _categories) DropdownMenuItem(value: c, child: Text(c))],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'A guardar...' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
