import 'package:flutter/material.dart';

import '../../../../core/services/database.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.contact, this.onTap});

  final Contact contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(contact.name);
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: contact.phone != null
          ? const Icon(Icons.chevron_right)
          : Icon(Icons.chevron_right, color: colors.outlineVariant),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
