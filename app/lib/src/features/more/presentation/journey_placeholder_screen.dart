import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';

/// Placeholder for journeys scaffolded but not yet implemented (see
/// docs/BACKLOG.md and docs/SPRINTS.md for which sprint owns each one).
class JourneyPlaceholderScreen extends StatelessWidget {
  const JourneyPlaceholderScreen({
    required this.title,
    required this.sprint,
    this.icon = Icons.construction,
    super.key,
  });

  final String title;
  final String sprint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 56, color: MajuColors.blue500),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Jornada planeada para $sprint.\nUI já modelada no protótipo web (/prototype).',
                textAlign: TextAlign.center,
                style: const TextStyle(color: MajuColors.ink2, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
