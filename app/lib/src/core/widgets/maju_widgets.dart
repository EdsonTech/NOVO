import 'package:flutter/material.dart';

import '../theme/maju_colors.dart';
import '../theme/maju_theme.dart';

/// Small library of reusable presentation widgets, mirroring the prototype's
/// component set (cards, hero balance, stat tiles, list rows, section titles).

class MajuCard extends StatelessWidget {
  const MajuCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MajuColors.card,
      borderRadius: BorderRadius.circular(MajuTheme.rMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MajuTheme.rMd),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(MajuTheme.s16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MajuTheme.rMd),
            boxShadow: const [
              BoxShadow(color: Color(0x0F102A4F), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {this.trailing, super.key});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MajuColors.ink3,
              letterSpacing: 0.4,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Blue gradient hero card (balance / result).
class HeroBalanceCard extends StatelessWidget {
  const HeroBalanceCard({
    required this.label,
    required this.value,
    this.left,
    this.right,
    super.key,
  });

  final String label;
  final String value;
  final ({String label, String value})? left;
  final ({String label, String value})? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MajuTheme.s20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MajuTheme.rLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MajuColors.blue800, MajuColors.blue500],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          if (left != null && right != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _pill(left!)),
                const SizedBox(width: 10),
                Expanded(child: _pill(right!)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _pill(({String label, String value}) p) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text(
              p.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
}

/// Small stat tile (icon + label + value).
class StatTile extends StatelessWidget {
  const StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MajuCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 9),
          Text(label, style: const TextStyle(fontSize: 12, color: MajuColors.ink2)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

/// List row with leading icon, title/subtitle and trailing amount.
class MajuListRow extends StatelessWidget {
  const MajuListRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor = MajuColors.blue700,
    this.iconBg = MajuColors.blue100,
    this.amountColor,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailing;
  final Color iconColor;
  final Color iconBg;
  final Color? amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(subtitle!, style: const TextStyle(fontSize: 12, color: MajuColors.ink3)),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: amountColor ?? MajuColors.ink,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// White rounded container that hosts [MajuListRow]s with dividers.
class MajuList extends StatelessWidget {
  const MajuList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MajuColors.card,
        borderRadius: BorderRadius.circular(MajuTheme.rMd),
        boxShadow: const [
          BoxShadow(color: Color(0x0F102A4F), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: MajuColors.line),
            children[i],
          ],
        ],
      ),
    );
  }
}
