import 'package:url_launcher/url_launcher.dart';

/// Wraps `url_launcher` for placing calls. Uses the `tel:` scheme which
/// opens the system dialer with the number prefilled — works on iOS and
/// Android with no special permissions. The user confirms the call by
/// tapping the green button. (True auto-dial via ACTION_CALL would
/// require Android's CALL_PHONE permission and isn't allowed on iOS,
/// so we deliberately don't go that far.)
class DialerService {
  const DialerService();

  Future<bool> dial(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return false;
    final uri = Uri(scheme: 'tel', path: _sanitize(phone));
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }

  String _sanitize(String raw) {
    // Keep digits, +, *, # — strip the rest (JSONPlaceholder phones have
    // junk like "1-770-736-8031 x56442" which dialer apps reject).
    return raw.replaceAll(RegExp(r'[^0-9+*#]'), '');
  }
}
