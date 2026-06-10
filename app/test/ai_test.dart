import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju_app/src/features/ai/data/ai_repository.dart';
import 'package:maju_app/src/features/ai/domain/category_classifier.dart';
import 'package:maju_app/src/features/ai/domain/receipt_scan.dart';
import 'package:maju_app/src/features/ai/presentation/ai_providers.dart';
import 'package:maju_app/src/features/finances/domain/transaction.dart';

void main() {
  group('CategoryClassifier', () {
    test('classifies known merchants', () {
      expect(CategoryClassifier.classify('Supermercado Kero'), 'Alimentação');
      expect(CategoryClassifier.classify('Pumangol gasóleo'), 'Transporte');
      expect(CategoryClassifier.classify('Unitel recarga'), 'Telecomunicações');
      expect(CategoryClassifier.classify('Farmácia Popular'), 'Saúde');
    });

    test('falls back to Outros for unknown text', () {
      expect(CategoryClassifier.classify('xpto qualquer coisa'), 'Outros');
    });

    test('normalise keeps a known model category, else re-classifies', () {
      expect(CategoryClassifier.normalise('Saúde', 'qualquer'), 'Saúde');
      expect(CategoryClassifier.normalise('garbage', 'Supermercado Kero'), 'Alimentação');
    });
  });

  group('ReceiptScan', () {
    test('fromJson sanitises bad input', () {
      final s = ReceiptScan.fromJson({'amount': 1500, 'confidence': 0.9});
      expect(s.merchant, 'Comprovante');
      expect(s.category, 'Outros');
      expect(s.type, TxType.expense);
    });

    test('toTransaction maps fields correctly', () {
      final s = ReceiptScan(
        merchant: 'Kero', amount: 12500, date: DateTime(2026, 6, 1),
        category: 'Alimentação', type: TxType.expense, confidence: 0.92,
      );
      final tx = s.toTransaction();
      expect(tx.title, 'Kero');
      expect(tx.amount, 12500);
      expect(tx.category, 'Alimentação');
      expect(tx.type, TxType.expense);
    });
  });

  test('MockAiRepository extracts a confident, classified scan', () async {
    final repo = MockAiRepository();
    final scan = await repo.scanReceipt(Uint8List(0));
    expect(scan.isConfident, isTrue);
    expect(CategoryClassifier.isKnown(scan.category), isTrue);
    expect(scan.amount, greaterThan(0));
  });

  test('offline mode selects the mock AI repository', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(aiRepositoryProvider), isA<MockAiRepository>());
  });
}
