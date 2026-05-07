import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/providers.dart';
import '../widgets/call_log_tile.dart';
import '../widgets/scheduled_call_tile.dart';
import 'schedule_call_page.dart';

class AutoCallPage extends ConsumerWidget {
  const AutoCallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auto Call'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming', icon: Icon(Icons.schedule)),
              Tab(text: 'History', icon: Icon(Icons.history)),
              Tab(text: 'Call log', icon: Icon(Icons.phone)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UpcomingTab(),
            _HistoryTab(),
            _CallLogTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ScheduleCallPage(),
            ),
          ),
          icon: const Icon(Icons.add_alarm),
          label: const Text('Schedule'),
        ),
      ),
    );
  }
}

class _UpcomingTab extends ConsumerWidget {
  const _UpcomingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(upcomingCallsProvider);
    return async.when(
      data: (list) {
        if (list.isEmpty) {
          return const _EmptyHint(
            icon: Icons.schedule,
            text: 'No upcoming calls. Tap Schedule to add one.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: list
              .map(
                (c) => ScheduledCallTile(
                  call: c,
                  onCancel: () => ref
                      .read(cancelScheduledCallProvider)
                      .call(c.id),
                  onCallNow: () => ref
                      .read(placeCallNowProvider)
                      .call(
                        contactId: c.contactId,
                        contactName: c.contactName,
                        phone: c.phone,
                      ),
                ),
              )
              .toList(growable: false),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(scheduledHistoryProvider);
    return async.when(
      data: (list) {
        if (list.isEmpty) {
          return const _EmptyHint(
            icon: Icons.history,
            text: 'No scheduled-call history yet.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: list
              .map((c) => ScheduledCallTile(call: c))
              .toList(growable: false),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _CallLogTab extends ConsumerWidget {
  const _CallLogTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(callLogProvider);
    return async.when(
      data: (list) {
        if (list.isEmpty) {
          return const _EmptyHint(
            icon: Icons.phone,
            text: 'No call log entries yet.\n'
                'Calls placed via Quick Dial or fired schedules will appear here.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) => CallLogTile(log: list[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48,
                color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
