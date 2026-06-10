/// MAJU credit score (0–1000) and eligibility, computed from the family's
/// finances. Pure Dart — deterministic and unit-testable.
class CreditScore {
  const CreditScore(this.value);
  final int value; // 0..1000

  String get band {
    if (value >= 800) return 'Excelente';
    if (value >= 700) return 'Bom';
    if (value >= 550) return 'Razoável';
    if (value >= 400) return 'Baixo';
    return 'Crítico';
  }

  double get fraction => (value / 1000).clamp(0, 1).toDouble();
}

class Eligibility {
  const Eligibility({required this.title, required this.detail, required this.eligible});
  final String title;
  final String detail;
  final bool eligible;
}

abstract class CreditScoreCalculator {
  /// Weighs savings rate (+), goals progress (+) and debt burden (−) onto a
  /// 500 baseline. [income]/[expense] are monthly; [debts] is total outstanding
  /// (compared against ANNUAL income, the financially sound ratio).
  static CreditScore compute({
    required num income,
    required num expense,
    required num debts,
    double goalsProgress = 0,
  }) {
    if (income <= 0) return const CreditScore(400);
    final savingsRate = ((income - expense) / income).clamp(0.0, 1.0);
    final debtRatio = (debts / (income * 12)).clamp(0.0, 1.0);

    var score = 500.0;
    score += savingsRate * 250; // up to +250
    score += goalsProgress.clamp(0.0, 1.0) * 150; // up to +150
    score -= debtRatio * 200; // up to -200

    return CreditScore(score.clamp(0, 1000).round());
  }

  /// Product eligibility derived from the score.
  static List<Eligibility> eligibility(CreditScore score) {
    final v = score.value;
    final microLimit = v >= 800
        ? '3.000.000 Kz'
        : v >= 700
            ? '1.500.000 Kz'
            : v >= 550
                ? '500.000 Kz'
                : '—';
    return [
      Eligibility(
        title: 'Microcrédito',
        detail: v >= 550 ? 'Até $microLimit' : 'Melhore o score para aceder',
        eligible: v >= 550,
      ),
      Eligibility(
        title: 'Seguro Familiar',
        detail: v >= 500 ? 'Plano Essencial' : 'Indisponível',
        eligible: v >= 500,
      ),
      Eligibility(
        title: 'Investimento',
        detail: v >= 650 ? 'A partir de 50.000 Kz' : 'Indisponível',
        eligible: v >= 650,
      ),
    ];
  }
}
