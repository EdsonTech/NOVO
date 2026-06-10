import 'package:equatable/equatable.dart';

/// An asset or liability in the family's patrimony.
class Asset extends Equatable {
  const Asset({
    required this.id,
    required this.title,
    required this.category,
    required this.value,
    required this.isLiability,
  });

  final String id;
  final String title;
  final String category;
  final num value;
  final bool isLiability;

  factory Asset.fromMap(Map<String, dynamic> m) => Asset(
        id: m['id'].toString(),
        title: m['title'] as String,
        category: (m['category'] as String?) ?? 'outro',
        value: (m['value'] as num?) ?? 0,
        isLiability: (m['is_liability'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'category': category,
        'value': value,
        'is_liability': isLiability,
      };

  @override
  List<Object?> get props => [id, title, category, value, isLiability];
}

/// Aggregated patrimony figures.
class PatrimonySummary {
  const PatrimonySummary({required this.assets, required this.liabilities});

  final num assets;
  final num liabilities;
  num get net => assets - liabilities;

  factory PatrimonySummary.from(List<Asset> items) {
    num a = 0, l = 0;
    for (final x in items) {
      if (x.isLiability) {
        l += x.value;
      } else {
        a += x.value;
      }
    }
    return PatrimonySummary(assets: a, liabilities: l);
  }
}
