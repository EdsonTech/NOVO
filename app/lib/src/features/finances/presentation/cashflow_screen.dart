import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/maju_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/maju_widgets.dart';
import '../domain/cash_flow.dart';
import 'finances_providers.dart';

class CashflowScreen extends ConsumerWidget {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(cashflowProvider);
    final avgIncome = flow.map((f) => f.income).reduce((a, b) => a + b) / flow.length;
    final avgExpense = flow.map((f) => f.expense).reduce((a, b) => a + b) / flow.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Fluxo de Caixa')),
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
                    const Text('Entrada vs Saída',
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
                    _badge('+12%'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(height: 180, child: _chart(flow)),
                const SizedBox(height: 8),
                _legend(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.south_west,
                  label: 'Média entradas',
                  value: Money.kzShort(avgIncome),
                  color: MajuColors.green500,
                  bg: MajuColors.green100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.north_east,
                  label: 'Média saídas',
                  value: Money.kzShort(avgExpense),
                  color: MajuColors.red500,
                  bg: MajuColors.red100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chart(List<MonthlyFlow> flow) {
    List<FlSpot> spots(num Function(MonthlyFlow) sel) =>
        [for (var i = 0; i < flow.length; i++) FlSpot(i.toDouble(), sel(flow[i]).toDouble())];

    LineChartBarData bar(List<FlSpot> s, Color c) => LineChartBarData(
          spots: s,
          isCurved: true,
          color: c,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: true, color: c.withOpacity(0.12)),
        );

    return LineChart(
      LineChartData(
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
                if (i < 0 || i >= flow.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(flow[i].label, style: const TextStyle(fontSize: 10, color: MajuColors.ink3)),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          bar(spots((f) => f.income), MajuColors.green500),
          bar(spots((f) => f.expense), MajuColors.red500),
        ],
      ),
    );
  }

  Widget _badge(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: MajuColors.green100, borderRadius: BorderRadius.circular(99)),
        child: Text(t, style: const TextStyle(color: MajuColors.green500, fontWeight: FontWeight.w700, fontSize: 11)),
      );

  Widget _legend() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dot(MajuColors.green500, 'Entradas'),
          const SizedBox(width: 16),
          _dot(MajuColors.red500, 'Saídas'),
        ],
      );

  Widget _dot(Color c, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: MajuColors.ink2)),
        ],
      );
}
