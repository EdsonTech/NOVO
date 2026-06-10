import 'package:equatable/equatable.dart';

/// One month of aggregated cash flow.
class MonthlyFlow extends Equatable {
  const MonthlyFlow({required this.label, required this.income, required this.expense});

  final String label;
  final num income;
  final num expense;

  @override
  List<Object?> get props => [label, income, expense];
}

/// A debt / liability with a simple amortization view.
class Debt extends Equatable {
  const Debt({
    required this.title,
    required this.kind,
    required this.balance,
    required this.installments,
  });

  final String title;
  final String kind; // Empréstimo, Cartão, Crédito informal
  final num balance;
  final int installments;

  @override
  List<Object?> get props => [title, kind, balance, installments];
}
