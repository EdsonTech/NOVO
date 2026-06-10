import 'package:equatable/equatable.dart';

import '../../finances/domain/transaction.dart';

/// Coerces a JSON `amount` (which a model may emit as a number OR a string with
/// separators) into a clean [num].
num _coerceAmount(dynamic v) {
  if (v is num) return v;
  if (v is String) return num.tryParse(v.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  return 0;
}

/// Structured data extracted from a receipt/comprovante image by MAJU IA.
class ReceiptScan extends Equatable {
  const ReceiptScan({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    required this.confidence,
    this.rawText,
  });

  final String merchant;
  final num amount;
  final DateTime date;
  final String category;
  final TxType type;

  /// 0..1 — how confident the model is in the extraction.
  final double confidence;
  final String? rawText;

  bool get isConfident => confidence >= 0.7;

  ReceiptScan copyWith({
    String? merchant,
    num? amount,
    DateTime? date,
    String? category,
    TxType? type,
  }) =>
      ReceiptScan(
        merchant: merchant ?? this.merchant,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        category: category ?? this.category,
        type: type ?? this.type,
        confidence: confidence,
        rawText: rawText,
      );

  /// Builds the [Transaction] that this scan should create.
  Transaction toTransaction() => Transaction(
        id: '',
        type: type,
        title: merchant,
        category: category,
        amount: amount,
        date: date,
      );

  factory ReceiptScan.fromJson(Map<String, dynamic> j) => ReceiptScan(
        merchant: (j['merchant'] as String?)?.trim().isNotEmpty == true
            ? j['merchant'] as String
            : 'Comprovante',
        amount: _coerceAmount(j['amount']),
        date: j['date'] != null
            ? DateTime.tryParse(j['date'] as String) ?? DateTime.now()
            : DateTime.now(),
        category: (j['category'] as String?) ?? 'Outros',
        type: (j['type'] as String?) == 'income' ? TxType.income : TxType.expense,
        confidence: ((j['confidence'] as num?) ?? 0).toDouble(),
        rawText: j['raw_text'] as String?,
      );

  @override
  List<Object?> get props => [merchant, amount, date, category, type, confidence];
}
