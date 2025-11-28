import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor_blue_scale/l10n/app_localizations.dart';

import '../models/user_profile.dart';
import '../models/weight_entry.dart';
import '../providers/history_provider.dart';
import '../theme/design_tokens.dart';
import '../utils/formatters.dart';

class HistoryView extends StatefulWidget {
  final UserProfile user;
  const HistoryView({super.key, required this.user});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.user.isGuest) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.historyGuestMessage,
              style: TextStyle(color: Colors.grey.shade700)),
        ),
      );
    }

    final history = context.watch<HistoryProvider>();
    final entries = history.entries;

    return SingleChildScrollView(
      padding: DesignTokens.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(entries: entries, target: widget.user.targetWeight),
          const SizedBox(height: 12),
          if (entries.length >= 2)
            _HistoryChart(entries: entries, target: widget.user.targetWeight)
          else
            _EmptyChartHint(onAdd: () {}),
          const SizedBox(height: 16),
          Text(l10n.historyListTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            Text(l10n.historyEmpty, style: TextStyle(color: Colors.grey.shade700))
          else
              ...entries.reversed.map(
                (e) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.bubble_chart_outlined),
                    title: Text('${e.weightKg.toStringAsFixed(2)} kg'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Formatters.dayWithTime(e.recordedAt, locale: l10n.localeName)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (e.bmi != null)
                              _metricChip('BMI', e.bmi!.toStringAsFixed(1)),
                            if (e.bodyFatPercent != null)
                              _metricChip(l10n.labelBodyFatPercent,
                                  Formatters.percent(e.bodyFatPercent)),
                            if (e.musclePercent != null)
                              _metricChip(l10n.labelMusclePercent,
                                  Formatters.percent(e.musclePercent)),
                          ],
                        ),
                      ],
                    ),
                    trailing: widget.user.targetWeight != null
                        ? _targetDelta(e.weightKg, widget.user.targetWeight!)
                        : null,
                  ),
                ),
              ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _targetDelta(double weight, double target) {
    final diff = weight - target;
    final color = diff > 0 ? Colors.redAccent : Colors.green;
    final label = diff > 0
        ? '+${diff.abs().toStringAsFixed(1)}'
        : '-${diff.abs().toStringAsFixed(1)}';
    return Chip(
      label: Text('$label kg'),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color),
    );
  }
}

Widget _metricChip(String label, String value) {
  return Chip(
    label: Text('$label $value'),
    padding: const EdgeInsets.symmetric(horizontal: 6),
    visualDensity: VisualDensity.compact,
  );
}

class _HistoryChart extends StatelessWidget {
  final List<WeightEntry> entries;
  final double? target;
  const _HistoryChart({required this.entries, this.target});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spots = entries
        .map((e) => FlSpot(
              e.recordedAt.millisecondsSinceEpoch.toDouble(),
              e.weightKg,
            ))
        .toList();

    final minX = spots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 0.5;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 0.5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 240,
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 44),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxX - minX) / 3,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          Formatters.day(date, locale: l10n.localeName),
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isCurved: true,
                  dotData: FlDotData(show: true),
                  spots: spots,
                ),
              ],
              extraLinesData: target != null
                  ? ExtraLinesData(horizontalLines: [
                      HorizontalLine(
                        y: target!,
                        color: Colors.orange,
                        strokeWidth: 2,
                        dashArray: [6, 6],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          labelResolver: (_) =>
                              l10n.chartGoalLabel(target!.toStringAsFixed(1)),
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ])
                  : ExtraLinesData(),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<WeightEntry> entries;
  final double? target;
  const _StatsRow({required this.entries, this.target});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latest = entries.isNotEmpty ? entries.last.weightKg : null;
    final latestFat = entries.isNotEmpty ? entries.last.bodyFatPercent : null;
    final avg = entries.isEmpty
        ? null
        : entries
                .map<double>((e) => e.weightKg)
                .reduce((a, b) => a + b) /
            entries.length;

    return Row(
      children: [
        _StatChip(label: l10n.statLatest, value: Formatters.weight(latest)),
        const SizedBox(width: 10),
        _StatChip(label: l10n.statAverage, value: Formatters.weight(avg)),
        const SizedBox(width: 10),
        _StatChip(label: l10n.statBodyFatPercent, value: Formatters.percent(latestFat)),
        const SizedBox(width: 10),
        if (target != null)
          _StatChip(label: l10n.labelGoal, value: '${target!.toStringAsFixed(1)} kg'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChartHint extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyChartHint({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        children: [
          Text(l10n.historyChartEmpty),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onAdd,
            child: Text(l10n.historyChartEmptyCta),
          ),
        ],
      ),
    );
  }
}
