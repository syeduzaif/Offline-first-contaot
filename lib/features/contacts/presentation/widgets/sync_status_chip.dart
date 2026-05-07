import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/sync_engine_service.dart';
import '../controllers/providers.dart';

class SyncStatusChip extends ConsumerWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingCountProvider).value ?? 0;
    final status = ref.watch(syncStatusProvider).value ??
        const SyncStatus.idle();
    final colors = Theme.of(context).colorScheme;

    final (label, icon, bg, fg) = switch (status) {
      SyncStatusSyncing() => ('Syncing…', Icons.sync, colors.primaryContainer, colors.onPrimaryContainer),
      SyncStatusError() => ('Sync error', Icons.sync_problem, colors.errorContainer, colors.onErrorContainer),
      SyncStatusConflict() => ('Conflict', Icons.warning_amber, colors.tertiaryContainer, colors.onTertiaryContainer),
      SyncStatusIdle() when pending > 0 => ('$pending pending', Icons.cloud_upload, colors.secondaryContainer, colors.onSecondaryContainer),
      SyncStatusIdle() => ('Up to date', Icons.cloud_done, colors.secondaryContainer, colors.onSecondaryContainer),
    };

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Tooltip(
        message: _tooltipFor(status, pending),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String _tooltipFor(SyncStatus status, int pending) {
    return switch (status) {
      SyncStatusSyncing() => 'Talking to server…',
      SyncStatusError(message: final m) => 'Last error: $m',
      SyncStatusConflict() => 'A change was rejected by the server.',
      SyncStatusIdle(lastSyncedAt: final t) =>
        '${pending == 0 ? "Queue empty" : "$pending in queue"}'
            '${t != null ? "\nLast sync: ${_relative(t)}" : ""}',
    };
  }

  String _relative(DateTime t) {
    final delta = DateTime.now().difference(t);
    if (delta.inSeconds < 60) return '${delta.inSeconds}s ago';
    if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    return '${delta.inDays}d ago';
  }
}
