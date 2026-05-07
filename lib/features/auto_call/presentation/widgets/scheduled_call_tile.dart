import 'package:flutter/material.dart';

import '../../../../core/services/database.dart';

class ScheduledCallTile extends StatelessWidget {
  const ScheduledCallTile({
    super.key,
    required this.call,
    this.onCancel,
    this.onCallNow,
  });

  final ScheduledCall call;
  final VoidCallback? onCancel;
  final VoidCallback? onCallNow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDue = call.runAt.isBefore(DateTime.now()) && call.firedAt == null;
    final isFired = call.firedAt != null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: isDue
          ? colors.errorContainer
          : colors.surfaceContainerHigh,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(call, colors),
          child: Icon(_statusIcon(call), color: Colors.white, size: 20),
        ),
        title: Text(
          call.contactName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_subtitleFor(call)),
            if (call.reason != null && call.reason!.isNotEmpty)
              Text(
                call.reason!,
                style: TextStyle(
                  color: colors.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        isThreeLine: call.reason != null && call.reason!.isNotEmpty,
        trailing: isFired
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDue && onCallNow != null)
                    IconButton(
                      tooltip: 'Place call now',
                      icon: const Icon(Icons.phone_in_talk),
                      onPressed: onCallNow,
                    ),
                  if (onCancel != null)
                    IconButton(
                      tooltip: 'Cancel',
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: onCancel,
                    ),
                ],
              ),
      ),
    );
  }

  String _subtitleFor(ScheduledCall c) {
    if (c.firedAt != null) {
      return '${c.outcome ?? "fired"} at ${c.firedAt!.toLocal()}';
    }
    final delta = c.runAt.difference(DateTime.now());
    if (delta.isNegative) {
      return 'Due now (was ${_relAbs(delta)} ago)';
    }
    return 'In ${_relAbs(delta)} • ${c.runAt.toLocal()}';
  }

  String _relAbs(Duration d) {
    final s = d.abs();
    if (s.inMinutes < 60) return '${s.inMinutes}m';
    if (s.inHours < 24) return '${s.inHours}h';
    return '${s.inDays}d';
  }

  Color _statusColor(ScheduledCall c, ColorScheme colors) {
    if (c.firedAt != null) {
      return switch (c.outcome) {
        'placed' => Colors.green,
        'cancelled' => colors.outline,
        'missed' => colors.error,
        _ => colors.primary,
      };
    }
    final isDue = c.runAt.isBefore(DateTime.now());
    return isDue ? colors.error : colors.primary;
  }

  IconData _statusIcon(ScheduledCall c) {
    if (c.firedAt != null) {
      return switch (c.outcome) {
        'placed' => Icons.phone,
        'cancelled' => Icons.block,
        'missed' => Icons.phone_missed,
        _ => Icons.history,
      };
    }
    final isDue = c.runAt.isBefore(DateTime.now());
    return isDue ? Icons.notifications_active : Icons.schedule;
  }
}
