import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

import '../../core/services/sync_engine.dart';
import '../contacts/presentation/controllers/providers.dart';

class SyncCenterPage extends ConsumerWidget {
  const SyncCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ops = ref.watch(outboxOpsProvider);
    final events = ref.watch(syncEventLogProvider);
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final status = ref.watch(syncStatusProvider).value ??
        const SyncStatus.idle();

    return Scaffold(
      appBar: AppBar(title: const Text('Sync Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatusCard(status: status, isOnline: isOnline),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isOnline
                      ? () => ref.read(syncEngineServiceProvider).syncNow()
                      : null,
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isOnline
                      ? () =>
                          ref.read(syncEngineServiceProvider).engine.fullResync()
                      : null,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Full resync'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Outbox queue', count: ops.value?.length),
          ops.when(
            data: (list) => list.isEmpty
                ? const _EmptyHint(
                    icon: Icons.inbox,
                    text: 'Queue empty — all caught up.',
                  )
                : Column(
                    children: list
                        .map((op) => _OpTile(op: op))
                        .toList(growable: false),
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Recent sync events',
            count: events.value?.length,
          ),
          events.when(
            data: (list) => list.isEmpty
                ? const _EmptyHint(
                    icon: Icons.history,
                    text: 'No events yet — trigger a sync to see activity.',
                  )
                : Column(
                    children: list
                        .take(20)
                        .map((e) => _EventTile(event: e))
                        .toList(growable: false),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.isOnline});
  final SyncStatus status;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (label, sub, icon, color) = switch (status) {
      SyncStatusSyncing() => (
          'Syncing in progress',
          'Talking to the server…',
          Icons.sync,
          colors.primary,
        ),
      SyncStatusError(message: final m) => (
          'Sync error',
          m,
          Icons.sync_problem,
          colors.error,
        ),
      SyncStatusConflict() => (
          'Conflict detected',
          'Awaiting resolution.',
          Icons.warning_amber,
          colors.tertiary,
        ),
      SyncStatusIdle(lastSyncedAt: final t) => (
          'Idle',
          t == null
              ? 'No sync has run yet.'
              : 'Last sync: ${t.toLocal()}',
          Icons.cloud_done,
          colors.primary,
        ),
    };

    return Card(
      elevation: 0,
      color: colors.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(sub, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isOnline ? Icons.wifi : Icons.wifi_off,
                        size: 14,
                        color: isOnline ? colors.primary : colors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? colors.primary : colors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.count});
  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          if (count != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OpTile extends StatelessWidget {
  const _OpTile({required this.op});
  final Op op;

  @override
  Widget build(BuildContext context) {
    final isUpsert = op is UpsertOp;
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: colors.surfaceContainerLow,
      child: ListTile(
        leading: Icon(
          isUpsert ? Icons.cloud_upload : Icons.delete_outline,
          color: isUpsert ? colors.primary : colors.error,
        ),
        title: Text('${isUpsert ? "Upsert" : "Delete"} • ${op.kind}'),
        subtitle: Text('id: ${op.id}\nqueued: ${_relTime(op.localTimestamp)}'),
        isThreeLine: true,
        trailing: Text(
          op.opId.substring(0, 8),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
        ),
      ),
    );
  }

  String _relTime(DateTime t) {
    final delta = DateTime.now().difference(t.toLocal());
    if (delta.inSeconds < 60) return '${delta.inSeconds}s ago';
    if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    return '${delta.inDays}d ago';
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});
  final SyncEvent event;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (event) {
      SyncStarted() => (Icons.play_arrow, Colors.blue),
      SyncCompleted() => (Icons.check_circle_outline, Colors.green),
      SyncErrorEvent() => (Icons.error_outline, Colors.red),
      ConflictDetectedEvent() => (Icons.warning_amber, Colors.orange),
      OperationPushedEvent() => (Icons.outbox, Colors.indigo),
      OperationFailedEvent() => (Icons.cancel_outlined, Colors.deepOrange),
      _ => (Icons.info_outline, Colors.grey),
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 18),
      title: Text(
        event.toString(),
        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, size: 36,
              color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
