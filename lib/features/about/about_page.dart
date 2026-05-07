import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Header(),
          const SizedBox(height: 16),
          const _SectionTitle('Architecture'),
          const _Layer(
            color: Colors.indigo,
            icon: Icons.dashboard_customize,
            title: 'Presentation',
            subtitle: 'Flutter widgets — Contacts, Sync, Stats, About tabs.',
          ),
          const _Connector(),
          const _Layer(
            color: Colors.teal,
            icon: Icons.flash_on,
            title: 'State (Riverpod)',
            subtitle: 'StreamProviders watching the database & sync events.',
          ),
          const _Connector(),
          const _Layer(
            color: Colors.purple,
            icon: Icons.shield,
            title: 'Repository',
            subtitle:
                'Atomic transactions: row write + outbox enqueue, in one shot.',
          ),
          const _Connector(),
          const _Layer(
            color: Colors.blue,
            icon: Icons.storage,
            title: 'Drift + SQLCipher',
            subtitle:
                'Encrypted local DB — the source of truth. PRAGMA key from secure keychain.',
          ),
          const _Connector(),
          const _Layer(
            color: Colors.orange,
            icon: Icons.sync_alt,
            title: 'Sync engine',
            subtitle:
                'offline_first_sync_drift — outbox poller, conflict resolver, cursor pagination.',
          ),
          const _Connector(),
          const _Layer(
            color: Colors.green,
            icon: Icons.cloud_outlined,
            title: 'Transport (custom)',
            subtitle:
                'JsonPlaceholderTransport — adapts JSONPlaceholder to the engine\'s contract.',
          ),
          const SizedBox(height: 24),
          const _SectionTitle('How a write flows'),
          const _StepRow(
            step: 1,
            text: 'Tap Save — UI calls the repository.',
          ),
          const _StepRow(
            step: 2,
            text:
                'Repository opens a transaction: writes the row AND enqueues '
                'an outbox op atomically.',
          ),
          const _StepRow(
            step: 3,
            text:
                'Drift reactive streams emit — the list rebuilds instantly. '
                'No network involved.',
          ),
          const _StepRow(
            step: 4,
            text:
                'Sync engine drains the outbox in the background — on a '
                'timer, on reconnect, or via Workmanager when the app is closed.',
          ),
          const _StepRow(
            step: 5,
            text:
                'Server response feeds back into the DB; conflicts are '
                'resolved by last-write-wins.',
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Why offline-first?'),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'The local database is authoritative. Network access is an '
                'enhancement, not a prerequisite. Writes never block on the '
                'server, the UI never spins waiting for a request, and a '
                'crash between local write and server push can never lose '
                'the user\'s intent — that\'s the outbox guarantee.',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Stack'),
          const _Bullet('Drift over sqlite3 (sqlite3mc multi-cipher build)'),
          const _Bullet('offline_first_sync_drift + custom transport'),
          const _Bullet('Riverpod for state and DI'),
          const _Bullet('connectivity_plus + workmanager for sync triggers'),
          const _Bullet('flutter_secure_storage for the SQLCipher key'),
          const _Bullet('dio for non-sync HTTP'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primaryContainer, colors.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offline Dummy',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'A reference offline-first Flutter app',
            style: TextStyle(color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

class _Layer extends StatelessWidget {
  const _Layer({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 14,
      alignment: Alignment.center,
      child: Icon(
        Icons.arrow_downward,
        size: 14,
        color: Theme.of(context).colorScheme.outline,
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
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.text});
  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colors.primaryContainer,
            child: Text(
              '$step',
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 6),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
