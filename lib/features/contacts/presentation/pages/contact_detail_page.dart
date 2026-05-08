import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auto_call/presentation/pages/schedule_call_page.dart';
import '../../../auto_call/presentation/widgets/quick_dial_button.dart';
import '../controllers/providers.dart';
import 'contact_edit_page.dart';

class ContactDetailPage extends ConsumerWidget {
  const ContactDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncContact = ref.watch(contactByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        actions: [
          asyncContact.maybeWhen(
            data: (c) =>
                c == null ? const SizedBox.shrink() : QuickDialButton(contact: c),
            orElse: SizedBox.shrink,
          ),
          asyncContact.maybeWhen(
            data: (c) => c == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.alarm_add),
                    tooltip: 'Schedule call',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ScheduleCallPage(prefilledContact: c),
                      ),
                    ),
                  ),
            orElse: SizedBox.shrink,
          ),
          asyncContact.maybeWhen(
            data: (c) => c == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ContactEditPage(existing: c),
                      ),
                    ),
                  ),
            orElse: SizedBox.shrink,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: asyncContact.when(
        data: (c) {
          if (c == null) {
            return const Center(child: Text('Contact not found.'));
          }
          return _DetailBody(contact: c);
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete contact?'),
        content: const Text('This will be queued for sync to the server.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(deleteContactProvider).call(id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Field(label: 'Name', value: contact.name),
        _Field(label: 'Email', value: contact.email),
        if (contact.username != null) _Field(label: 'Username', value: contact.username!),
        if (contact.phone != null) _Field(label: 'Phone', value: contact.phone!),
        if (contact.website != null) _Field(label: 'Website', value: contact.website!),
        if (_address(contact).isNotEmpty)
          _Field(label: 'Address', value: _address(contact)),
        if (contact.companyName != null)
          _Field(label: 'Company', value: contact.companyName!),
        const SizedBox(height: 16),
        Text(
          'Last updated locally: ${contact.updatedAt.toLocal()}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _address(Contact c) {
    final parts = [c.street, c.suite, c.city, c.zipcode]
        .whereType<String>()
        .where((s) => s.isNotEmpty);
    return parts.join(', ');
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
