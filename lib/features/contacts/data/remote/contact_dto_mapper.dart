/// Translates between the JSONPlaceholder /users shape (nested address/company)
/// and the flat shape expected by the Drift Contacts table / Contact data class.
class ContactDtoMapper {
  const ContactDtoMapper._();

  /// Static stamp used as `updatedAt` for all server-side contacts.
  /// JSONPlaceholder doesn't track modification times, so we pin a stable
  /// epoch — this keeps cursor logic stable: pull once, advance, no churn.
  static final DateTime serverEpoch = DateTime.utc(2020, 1, 1);

  /// Flatten a JSONPlaceholder /users item into the camelCase shape that
  /// Drift's generated `Contact.fromJson` expects.
  static Map<String, dynamic> fromServer(Map<String, dynamic> raw) {
    final address =
        (raw['address'] as Map?)?.cast<String, dynamic>() ?? const {};
    final company =
        (raw['company'] as Map?)?.cast<String, dynamic>() ?? const {};

    final updatedAtRaw = raw['updatedAt'] ?? raw['updated_at'];
    final updatedAt = updatedAtRaw is String
        ? DateTime.parse(updatedAtRaw).toUtc()
        : serverEpoch;

    return <String, dynamic>{
      'id': raw['id']?.toString() ?? '',
      'name': raw['name'] ?? '',
      'username': raw['username'],
      'email': raw['email'] ?? '',
      'phone': raw['phone'],
      'website': raw['website'],
      'street': address['street'],
      'suite': address['suite'],
      'city': address['city'],
      'zipcode': address['zipcode'],
      'companyName': company['name'],
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': null,
      'deletedAtLocal': null,
    };
  }
}
