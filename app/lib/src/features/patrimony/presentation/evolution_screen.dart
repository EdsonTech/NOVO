import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/widgets/maju_widgets.dart';

class EvolutionScreen extends StatelessWidget {
  const EvolutionScreen({super.key});

  // Net worth (millions Kz) by year. TODO(S11): compute from monthly snapshots.
  static const _years = ['2021', '2022', '2023', '2024', '2025'];
  static const _net = [14.0, 16.0, 18.0, 21.0, 24.0];

  @override
  Widget build(BuildContext context) {
    final max = _net.reduce((a, b) => a > b ? a : b);
    return Scaffold(
      appBar: AppBar(title: const Text('Evolução Patrimonial')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          MajuCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Património por ano',
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: MajuColors.green100, borderRadius: BorderRadius.circular(99)),
                      child: const Text('+34%',
                          style: TextStyle(color: MajuColors.green500, fontWeight: FontWeight.w700, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(height: 190, child: _chart(max)),
                const SizedBox(height: 6),
                const Text('Em milhões de Kwanzas',
                    style: TextStyle(fontSize: 12, color: MajuColors.ink3), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chart(double max) => BarChart(
        BarChartData(
          maxY: max * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= _years.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(_years[i], style: const TextStyle(fontSize: 10, color: MajuColors.ink3)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < _net.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: _net[i],
                  color: MajuColors.blue500,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ]),
          ],
        ),
      );
}
