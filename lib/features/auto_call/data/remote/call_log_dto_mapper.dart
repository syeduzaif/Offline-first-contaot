/// Translates between the (hypothetical) server JSON shape for call_logs
/// and the flat shape Drift's generated `CallLog` class expects.
///
/// JSONPlaceholder doesn't actually have a /call_logs endpoint, but the
/// transport's POST/PUT/DELETE will return mock-success regardless, and
/// the `pull` for kind='call_logs' will fail with 404 — which the engine
/// treats as "no items to pull." That's fine for the demo: we exercise
/// the push path (queue → drain) without needing a real server.
class CallLogDtoMapper {
  const CallLogDtoMapper._();

  static Map<String, dynamic> fromServer(Map<String, dynamic> raw) {
    return <String, dynamic>{
      'id': raw['id']?.toString() ?? '',
      'contactId': raw['contactId']?.toString() ?? '',
      'contactName': raw['contactName'] ?? '',
      'phone': raw['phone'],
      'placedAt': raw['placedAt'] ??
          DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(),
      'durationSec': raw['durationSec'] ?? 0,
      'notes': raw['notes'],
      'origin': raw['origin'] ?? 'manual',
      'updatedAt': raw['updatedAt'] ?? DateTime.now().toUtc().toIso8601String(),
      'deletedAt': null,
      'deletedAtLocal': null,
    };
  }
}
