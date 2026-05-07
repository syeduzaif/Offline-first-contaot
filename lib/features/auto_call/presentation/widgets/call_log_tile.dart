import 'package:flutter/material.dart';

import '../../../../core/services/database.dart';

class CallLogTile extends StatelessWidget {
  const CallLogTile({super.key, required this.log});

  final CallLog log;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isScheduled = log.origin == 'scheduled';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isScheduled
            ? colors.tertiaryContainer
            : colors.primaryContainer,
        foregroundColor: isScheduled
            ? colors.onTertiaryContainer
            : colors.onPrimaryContainer,
        child: Icon(isScheduled ? Icons.alarm_on : Icons.phone),
      ),
      title: Text(log.contactName),
      subtitle: Text(
        '${log.origin} • ${log.placedAt.toLocal()}'
        '${log.phone != null ? "\n${log.phone}" : ""}',
      ),
      isThreeLine: log.phone != null,
    );
  }
}
