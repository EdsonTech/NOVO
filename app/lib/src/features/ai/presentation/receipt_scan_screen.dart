import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../../finances/domain/transaction.dart';
import '../../finances/presentation/finances_providers.dart';
import '../domain/category_classifier.dart';
import '../domain/receipt_scan.dart';
import 'ai_providers.dart';

/// MAJU IA — digitalizar comprovante: capture → extract → classify → confirm.
class ReceiptScanScreen extends ConsumerStatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  ConsumerState<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

enum _Stage { start, scanning, review, saving, error }

class _ReceiptScanScreenState extends ConsumerState<ReceiptScanScreen> {
  _Stage _stage = _Stage.start;
  Uint8List? _image;
  ReceiptScan? _scan;

  // Editable review fields
  final _title = TextEditingController();
  final _amount = TextEditingController();
  late String _category;
  TxType _type = TxType.expense;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _image = bytes;
        _stage = _Stage.scanning;
      });
      final scan = await ref.read(aiRepositoryProvider).scanReceipt(bytes);
      _title.text = scan.merchant;
      _amount.text = scan.amount.toString();
      _category = CategoryClassifier.isKnown(scan.category) ? scan.category : 'Outros';
      _type = scan.type;
      setState(() {
        _scan = scan;
        _stage = _Stage.review;
      });
    } catch (_) {
      setState(() => _stage = _Stage.error);
    }
  }

  Future<void> _confirm() async {
    setState(() => _stage = _Stage.saving);
    final base = _scan ??
        ReceiptScan(
          merchant: '',
          amount: 0,
          date: DateTime.now(),
          category: _category,
          type: _type,
          confidence: 0,
        );
    final tx = base
        .copyWith(
          merchant: _title.text.trim().isEmpty ? 'Comprovante' : _title.text.trim(),
          amount: Money.parse(_amount.text),
          category: _category,
          type: _type,
        )
        .toTransaction();
    await ref.read(addTransactionProvider)(tx);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lançamento criado automaticamente! ✅')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digitalizar Comprovante')),
      body: switch (_stage) {
        _Stage.start => _startView(),
        _Stage.scanning => _scanningView(),
        _Stage.review => _reviewView(),
        _Stage.saving => const Center(child: CircularProgressIndicator()),
        _Stage.error => _errorView(),
      },
    );
  }

  Widget _startView() => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          MajuCard(
            child: Column(
              children: const [
                Icon(Icons.document_scanner_outlined, size: 48, color: MajuColors.blue500),
                SizedBox(height: 12),
                Text('Aponte para o comprovante',
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 16)),
                SizedBox(height: 6),
                Text(
                  'A MAJU IA lê o valor, a data e o estabelecimento, classifica a categoria e cria o lançamento por si.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: MajuColors.ink2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _pick(ImageSource.camera),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Tirar foto'),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => _pick(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Escolher da galeria'),
          ),
        ],
      );

  Widget _scanningView() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(_image!, height: 220, fit: BoxFit.cover),
            ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('A MAJU IA está a ler o comprovante...',
              style: TextStyle(color: MajuColors.ink2)),
        ],
      );

  Widget _reviewView() {
    final confident = _scan?.isConfident ?? false;
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        if (_image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(_image!, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(confident ? Icons.verified : Icons.info_outline,
                size: 18, color: confident ? MajuColors.green500 : MajuColors.amber500),
            const SizedBox(width: 6),
            Text(
              confident
                  ? 'Extraído com ${(100 * (_scan?.confidence ?? 0)).round()}% de confiança'
                  : 'Confiança baixa — confirme os dados',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: confident ? MajuColors.green500 : MajuColors.amber500,
              ),
            ),
          ],
        ),
        const SectionTitle('Dados extraídos'),
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Estabelecimento')),
        const SizedBox(height: 14),
        TextField(
          controller: _amount,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Valor', suffixText: 'Kz'),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: const InputDecoration(labelText: 'Categoria (classificada pela IA)'),
          items: [for (final c in CategoryClassifier.categories) DropdownMenuItem(value: c, child: Text(c))],
          onChanged: (v) => setState(() => _category = v!),
        ),
        const SizedBox(height: 14),
        SegmentedButton<TxType>(
          segments: const [
            ButtonSegment(value: TxType.expense, label: Text('Despesa')),
            ButtonSegment(value: TxType.income, label: Text('Receita')),
          ],
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
        ),
        const SizedBox(height: 22),
        FilledButton(onPressed: _confirm, child: const Text('Confirmar lançamento')),
      ],
    );
  }

  Widget _errorView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: MajuColors.red500),
              const SizedBox(height: 12),
              const Text(
                'Não foi possível ler o comprovante.\nTente novamente ou registe manualmente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: MajuColors.ink2),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => setState(() => _stage = _Stage.start),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
}
