import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database.dart';
import '../../../contacts/presentation/controllers/providers.dart';
import '../controllers/providers.dart';

class ScheduleCallPage extends ConsumerStatefulWidget {
  const ScheduleCallPage({super.key, this.prefilledContact});

  final Contact? prefilledContact;

  @override
  ConsumerState<ScheduleCallPage> createState() => _ScheduleCallPageState();
}

class _ScheduleCallPageState extends ConsumerState<ScheduleCallPage> {
  Contact? _selectedContact;
  late DateTime _runAt;
  final _reasonCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedContact = widget.prefilledContact;
    _runAt = DateTime.now().add(const Duration(minutes: 5));
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _runAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_runAt),
    );
    if (time == null) return;
    setState(() {
      _runAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final c = _selectedContact;
    if (c == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(scheduleCallProvider).call(
            contactId: c.id,
            contactName: c.name,
            phone: c.phone,
            runAt: _runAt,
            reason: _reasonCtrl.text.trim().isEmpty
                ? null
                : _reasonCtrl.text.trim(),
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncContacts = ref.watch(contactsListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule call')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          asyncContacts.when(
            data: (list) => DropdownButtonFormField<Contact>(
              initialValue: _selectedContact != null &&
                      list.any((c) => c.id == _selectedContact!.id)
                  ? list.firstWhere((c) => c.id == _selectedContact!.id)
                  : null,
              decoration: const InputDecoration(labelText: 'Contact *'),
              items: list
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.name} ${c.phone ?? ""}'),
                      ))
                  .toList(),
              onChanged: (c) => setState(() => _selectedContact = c),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('When'),
              subtitle: Text(_runAt.toLocal().toString()),
              trailing: TextButton(
                onPressed: _pickDateTime,
                child: const Text('Pick'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Reason (optional)',
              hintText: 'Why are you calling?',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed:
                _selectedContact == null || _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(_saving ? 'Scheduling…' : 'Schedule'),
          ),
          const SizedBox(height: 8),
          Text(
            'Stored locally. The call will fire at the scheduled time '
            'and be added to your call log; the call log syncs to the '
            'server when you\'re online.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
