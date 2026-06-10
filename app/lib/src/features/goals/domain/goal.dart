import 'package:equatable/equatable.dart';

/// A family savings goal / sonho.
class Goal extends Equatable {
  const Goal({
    required this.id,
    required this.title,
    required this.icon,
    required this.target,
    required this.saved,
    this.deadline,
  });

  final String id;
  final String title;
  final String icon; // logical name mapped to an IconData in the UI
  final num target;
  final num saved;
  final DateTime? deadline;

  double get progress => target == 0 ? 0 : (saved / target).clamp(0, 1).toDouble();
  num get remaining => (target - saved).clamp(0, target);

  factory Goal.fromMap(Map<String, dynamic> m) => Goal(
        id: m['id'].toString(),
        title: m['title'] as String,
        icon: (m['icon'] as String?) ?? 'flag',
        target: m['target_amount'] as num,
        saved: (m['saved_amount'] as num?) ?? 0,
        deadline: m['deadline'] == null ? null : DateTime.parse(m['deadline'] as String),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'icon': icon,
        'target_amount': target,
        'saved_amount': saved,
        'deadline': deadline?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, title, icon, target, saved, deadline];
}
