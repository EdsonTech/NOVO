import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';

/// Shared layout for the 3 onboarding steps: kicker, title, body, dots + CTA.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.step,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onNext,
    this.ctaLabel = 'Continuar',
    super.key,
  });

  final int step; // 1..3
  final String kicker;
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onNext;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kicker,
                style: const TextStyle(
                  color: MajuColors.orange500,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: MajuColors.ink2, fontSize: 14)),
              const SizedBox(height: 22),
              Expanded(child: SingleChildScrollView(child: body)),
              _dots(step),
              const SizedBox(height: 14),
              FilledButton(onPressed: onNext, child: Text(ctaLabel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dots(int active) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 1; i <= 3; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == active ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: i == active ? MajuColors.orange500 : MajuColors.line,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
        ],
      );
}

/// Selectable chip used across onboarding steps.
class SelectChip extends StatelessWidget {
  const SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? MajuColors.blue100 : MajuColors.card,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? MajuColors.blue500 : MajuColors.line,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: selected ? MajuColors.blue700 : MajuColors.ink2,
          ),
        ),
      ),
    );
  }
}
