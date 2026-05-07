import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/sync_engine_service.dart';
import '../contacts/presentation/controllers/providers.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(dbStatsProvider);
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final syncStatus = ref.watch(syncStatusProvider).value ??
        const SyncStatus.idle();

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: asyncStats.when(
        data: (stats) {
          final lastSynced = switch (syncStatus) {
            SyncStatusIdle(lastSyncedAt: final t) => t,
            _ => null,
          };
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatGrid(
                tiles: [
                  _StatTile(
                    icon: Icons.contacts,
                    label: 'Active contacts',
                    value: '${stats.activeCount}',
                    color: Colors.indigo,
                  ),
                  _StatTile(
                    icon: Icons.delete_sweep_outlined,
                    label: 'Pending delete',
                    value: '${stats.deletedCount}',
                    color: Colors.deepOrange,
                  ),
                  _StatTile(
                    icon: Icons.outbox,
                    label: 'Queued ops',
                    value: '${stats.queuedCount}',
                    color: stats.queuedCount > 0
                        ? Colors.orange
                        : Colors.green,
                  ),
                  _StatTile(
                    icon: isOnline ? Icons.wifi : Icons.wifi_off,
                    label: 'Network',
                    value: isOnline ? 'Online' : 'Offline',
                    color: isOnline ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Database'),
              const _InfoRow(
                icon: Icons.lock,
                title: 'Encryption at rest',
                value: 'SQLite3MultipleCiphers (PRAGMA key)',
              ),
              const _InfoRow(
                icon: Icons.vpn_key,
                title: 'Key location',
                value: 'OS keychain (FlutterSecureStorage)',
              ),
              _InfoRow(
                icon: Icons.update,
                title: 'Most recent local update',
                value: stats.mostRecentUpdate?.toLocal().toString() ??
                    'never',
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Sync'),
              _InfoRow(
                icon: Icons.history,
                title: 'Last successful sync',
                value: lastSynced?.toLocal().toString() ?? 'never',
              ),
              const _InfoRow(
                icon: Icons.repeat,
                title: 'Foreground sync interval',
                value: '30 seconds',
              ),
              const _InfoRow(
                icon: Icons.alarm,
                title: 'Background sync interval',
                value: '15 minutes (OS best-effort)',
              ),
              const _InfoRow(
                icon: Icons.compare_arrows,
                title: 'Conflict strategy',
                value: 'Last-write-wins',
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Backend'),
              const _InfoRow(
                icon: Icons.api,
                title: 'API base',
                value: 'jsonplaceholder.typicode.com',
              ),
              const _InfoRow(
                icon: Icons.warning_amber,
                title: 'Note',
                value: 'JSONPlaceholder mock-acks writes; '
                    'local DB is the source of truth.',
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.tiles});
  final List<_StatTile> tiles;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: tiles,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
