import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database.dart';
import '../controllers/providers.dart';

/// Drop-in icon button that places a call to a contact and records a
/// CallLog entry on success. Designed to slot into the contact detail
/// page's AppBar.
class QuickDialButton extends ConsumerWidget {
  const QuickDialButton({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPhone = contact.phone != null && contact.phone!.isNotEmpty;
    return IconButton(
      tooltip: hasPhone ? 'Call ${contact.name}' : 'No phone number',
      icon: const Icon(Icons.phone),
      onPressed: hasPhone ? () => _dial(context, ref) : null,
    );
  }

  Future<void> _dial(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(placeCallNowProvider).call(
          contactId: contact.id,
          contactName: contact.name,
          phone: contact.phone,
        );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open dialer.')),
      );
    }
  }
}
