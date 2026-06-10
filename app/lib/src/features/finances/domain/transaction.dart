import 'package:equatable/equatable.dart';

enum TxType { income, expense }

/// A single money movement (receita or despesa).
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  final String id;
  final TxType type;
  final String title;
  final String category;
  final num amount;
  final DateTime date;

  factory Transaction.fromMap(Map<String, dynamic> m) => Transaction(
        id: m['id'].toString(),
        type: (m['type'] as String) == 'income' ? TxType.income : TxType.expense,
        title: m['title'] as String,
        category: m['category'] as String,
        amount: m['amount'] as num,
        date: DateTime.parse(m['date'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name,
        'title': title,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, type, title, category, amount, date];
}
