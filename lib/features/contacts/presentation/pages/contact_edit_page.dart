import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database.dart';
import '../controllers/providers.dart';

class ContactEditPage extends ConsumerStatefulWidget {
  const ContactEditPage({super.key, this.existing});

  final Contact? existing;

  @override
  ConsumerState<ContactEditPage> createState() => _ContactEditPageState();
}

class _ContactEditPageState extends ConsumerState<ContactEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _website;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _zipcode;
  late final TextEditingController _company;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _username = TextEditingController(text: e?.username ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _website = TextEditingController(text: e?.website ?? '');
    _street = TextEditingController(text: e?.street ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _zipcode = TextEditingController(text: e?.zipcode ?? '');
    _company = TextEditingController(text: e?.companyName ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _name, _username, _email, _phone, _website,
      _street, _city, _zipcode, _company,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref.read(upsertContactProvider).call(
            id: widget.existing?.id,
            name: _name.text.trim(),
            username: _nullIfEmpty(_username.text),
            email: _email.text.trim(),
            phone: _nullIfEmpty(_phone.text),
            website: _nullIfEmpty(_website.text),
            street: _nullIfEmpty(_street.text),
            city: _nullIfEmpty(_city.text),
            zipcode: _nullIfEmpty(_zipcode.text),
            companyName: _nullIfEmpty(_company.text),
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'New Contact' : 'Edit Contact')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_name, 'Name *', validator: _required),
            _field(_email, 'Email *',
                validator: (v) => _required(v) ?? _emailFormat(v)),
            _field(_username, 'Username'),
            _field(_phone, 'Phone'),
            _field(_website, 'Website'),
            _field(_street, 'Street'),
            _field(_city, 'City'),
            _field(_zipcode, 'Zipcode'),
            _field(_company, 'Company'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving…' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailFormat(String? v) {
    if (v == null || v.isEmpty) return null;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Invalid email';
  }
}
