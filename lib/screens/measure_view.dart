import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/connection_status.dart';
import '../models/measurement.dart';
import '../models/user_profile.dart';
import '../models/weight_entry.dart';
import '../providers/history_provider.dart';
import '../providers/scale_provider.dart';
import '../providers/user_provider.dart';
import './device_connection_screen.dart';
import '../services/scale_handlers/scale_handler.dart';
import '../theme/design_tokens.dart';
import '../utils/formatters.dart';
import '../utils/id.dart';
import '../utils/body_composition.dart';

class MeasureView extends StatefulWidget {
  final UserProfile user;
  const MeasureView({super.key, required this.user});

  @override
  State<MeasureView> createState() => _MeasureViewState();
}

class _MeasureViewState extends State<MeasureView> {
  double? _lastSavedWeight;
  int? _lastSavedImpedance;
  DateTime? _lastSavedAt;

  @override
  Widget build(BuildContext context) {
    final scale = context.watch<ScaleProvider>();
    final history = context.watch<HistoryProvider>();
    final last = history.entries.isNotEmpty ? history.entries.last : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeAutoSave(scale, history);
    });

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: DesignTokens.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LiveWeightCard(
            measurement: scale.liveMeasurement,
            status: scale.status,
            capturing: scale.capturing,
          ),
          const SizedBox(height: 14),
          _ActionRow(user: widget.user, scaleStatus: scale.status),
          const SizedBox(height: 14),
          if (scale.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                scale.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 12),
          if (!widget.user.isGuest && last != null)
            _LastRecordCard(
              entry: last,
              target: widget.user.targetWeight,
              onDelete: () => history.remove(last.id, widget.user.id),
            ),
          if (widget.user.isGuest)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '게스트 모드에서는 기록이 저장되지 않습니다.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _maybeAutoSave(ScaleProvider scale, HistoryProvider history) async {
    final measurement = scale.liveMeasurement;
    if (measurement == null || widget.user.isGuest) return;

    final now = DateTime.now();
    const weightEpsilon = 0.05;
    final sameWeight =
        _lastSavedWeight != null && (measurement.weightKg - _lastSavedWeight!).abs() < weightEpsilon;
    final sameImp = _lastSavedImpedance != null && measurement.impedanceOhm == _lastSavedImpedance;
    final recent = _lastSavedAt != null && now.difference(_lastSavedAt!) < const Duration(seconds: 8);

    if (sameWeight && sameImp && recent) return;

    final comp = _compositionFor(measurement, widget.user);
    final entry = WeightEntry(
      id: generateId(),
      userId: widget.user.id,
      weightKg: measurement.weightKg,
      recordedAt: now,
      deviceName: scale.connectedName,
      impedanceOhm: measurement.impedanceOhm,
      bmi: comp.bmi,
      bodyFatPercent: comp.bodyFatPercent,
      bodyFatKg: comp.bodyFatKg,
      musclePercent: comp.musclePercent,
      muscleKg: comp.muscleKg,
    );
    await history.add(entry);
    _lastSavedWeight = measurement.weightKg;
    _lastSavedImpedance = measurement.impedanceOhm;
    _lastSavedAt = now;
  }
}

class _LiveWeightCard extends StatelessWidget {
  final Measurement? measurement;
  final ConnectionStatus status;
  final bool capturing;
  const _LiveWeightCard(
      {required this.measurement, required this.status, required this.capturing});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: DesignTokens.softShadow(colors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  measurement?.weightKg.toStringAsFixed(2) ?? '--.--',
                  style: const TextStyle(
                    fontSize: 56,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('kg', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                _statusLabel(status, capturing),
                const SizedBox(height: 14),
                _MetricsRow(measurement: measurement),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusLabel(ConnectionStatus status, bool capturing) {
    String text = status.message;
    if (capturing) {
      text = '측정 중...';
    } else if (status == ConnectionStatus.connected && measurement == null) {
      text = '값을 기다리는 중';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(DesignTokens.smallRadius),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final Measurement? measurement;
  const _MetricsRow({this.measurement});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().selectedUser;
    if (measurement == null || user == null) {
      return const SizedBox.shrink();
    }

    final comp = BodyCompositionCalculator.derive(
      measurement: measurement!,
      heightCm: user.heightCm,
      age: user.age,
      gender: user.gender,
    );

    final chips = [
      _metricChip('BMI', comp.bmi != null ? comp.bmi!.toStringAsFixed(1) : '--'),
      _metricChip('체지방%', Formatters.percent(comp.bodyFatPercent)),
      _metricChip('체지방량', Formatters.mass(comp.bodyFatKg)),
      _metricChip('골격근%', Formatters.percent(comp.musclePercent)),
      _metricChip('근육량', Formatters.mass(comp.muscleKg)),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: chips,
    );
  }

  Widget _metricChip(String label, String value) {
    return Chip(
      label: Text('$label $value'),
      backgroundColor: Colors.white.withValues(alpha: 0.12),
      labelStyle: const TextStyle(color: Colors.white),
      side: BorderSide.none,
    );
  }
}

class _ActionRow extends StatelessWidget {
  final UserProfile user;
  final ConnectionStatus scaleStatus;
  const _ActionRow({required this.user, required this.scaleStatus});

  @override
  Widget build(BuildContext context) {
    final scale = context.read<ScaleProvider>();

    final isBroadcastAvailable =
        (scale.connectedMatch?.linkMode == ScaleLinkMode.broadcastOnly) || scale.hasStoredBroadcast;

    final buttons = <Widget>[];

    if (isBroadcastAvailable) {
      buttons.addAll([
        Expanded(
          child: FilledButton.icon(
            onPressed: (scaleStatus == ConnectionStatus.connecting)
                ? null
                : () => scale.capturing ? scale.cancelCapture() : scale.takeStableMeasurement(),
            icon: Icon(scale.capturing ? Icons.stop_circle_outlined : Icons.podcasts),
            label: Text(scale.capturing ? '측정 중지' : '측정하기'),
          ),
        ),
      ]);
    } else {
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: scaleStatus == ConnectionStatus.scanning
                ? null
                : scaleStatus == ConnectionStatus.connected
                    ? () => scale.disconnect()
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DeviceConnectionScreen(),
                          ),
                        ),
            icon: Icon(scaleStatus == ConnectionStatus.connected ? Icons.link_off : Icons.refresh),
            label: Text(scaleStatus == ConnectionStatus.connected ? '연결 해제' : '다시 검색'),
          ),
        ),
      );
    }

    return Row(children: buttons);
  }
}

BodyComposition _compositionFor(Measurement m, UserProfile user) =>
    BodyCompositionCalculator.derive(
      measurement: m,
      heightCm: user.heightCm,
      age: user.age,
      gender: user.gender,
    );


class _LastRecordCard extends StatelessWidget {
  final WeightEntry entry;
  final double? target;
  final VoidCallback onDelete;
  const _LastRecordCard({required this.entry, this.target, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final diff = target != null ? (entry.weightKg - target!) : null;
    final pills = <Widget>[
      if (diff != null)
        _metricPill(
          '목표',
          diff > 0
              ? '+${diff.abs().toStringAsFixed(1)} kg 초과'
              : '${diff.abs().toStringAsFixed(1)} kg 남음',
        ),
      if (entry.bmi != null) _metricPill('BMI', entry.bmi!.toStringAsFixed(1)),
      if (entry.bodyFatPercent != null)
        _metricPill('체지방%', Formatters.percent(entry.bodyFatPercent)),
      if (entry.bodyFatKg != null)
        _metricPill('체지방량', Formatters.mass(entry.bodyFatKg)),
      if (entry.musclePercent != null)
        _metricPill('골격근%', Formatters.percent(entry.musclePercent)),
      if (entry.muscleKg != null)
        _metricPill('근육량', Formatters.mass(entry.muscleKg)),
    ];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: const Icon(Icons.monitor_weight_outlined),
            title: Text(
              '${entry.weightKg.toStringAsFixed(2)} kg',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(Formatters.dayWithTime.format(entry.recordedAt)),
            trailing: IconButton(
              tooltip: '기록 삭제',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ),
          if (pills.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: pills,
              ),
            ),
        ],
      ),
    );
  }
}

Widget _metricPill(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '$label $value',
      style: const TextStyle(fontSize: 12),
    ),
  );
}
