import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../../core/services/permission_service.dart';

/// Resolves a 10-digit phone number to a contact name from the native address book.
///
/// Ported from ContactsResolver.kt / MerchantContactDisplay.kt.
/// Uses ChangeNotifier to trigger UI updates automatically on successful resolution.
class ContactsResolverService extends ChangeNotifier {
  final PermissionService _permissionService;
  static const _channel = MethodChannel('com.genzloop.finsight_ai/sms');

  // Compiled once. Captures optional +91 prefix followed by exactly 10 digits.
  static final RegExp _indianMobileRegex = RegExp(r'(?<!\d)(?:\+?91)?(\d{10})(?!\d)');

  // In-memory cache mapping 10-digit number -> Display Name (null means queried but no match).
  final Map<String, String?> _cache = {};

  // Active query registry to avoid redundant MethodChannel dispatches.
  final Set<String> _pending = {};

  ContactsResolverService(this._permissionService);

  /// Dynamic UI display mapping function.
  ///
  /// Swaps a UPI-style merchant string (containing a phone number) for a contact
  /// name if the user enabled [useContactsForVpa].
  String? displayMerchantName(String? merchant, bool useContactsForVpa) {
    if (merchant == null || merchant.isEmpty) return merchant;
    if (!useContactsForVpa) return merchant;

    final phone = extractIndianMobile(merchant);
    if (phone == null) return merchant;

    if (_cache.containsKey(phone)) {
      return _cache[phone] ?? merchant;
    }

    _scheduleQuery(phone);
    return merchant;
  }

  /// Extracts a 10-digit Indian mobile number from text.
  String? extractIndianMobile(String text) {
    final match = _indianMobileRegex.firstMatch(text);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  /// Clears resolved contact memory.
  void clearCache() {
    _cache.clear();
    _pending.clear();
    notifyListeners();
  }

  Future<void> _scheduleQuery(String phone) async {
    if (!_pending.add(phone)) return;

    try {
      final hasPerm = await _permissionService.checkContactsPermission();
      if (!hasPerm) {
        _cache[phone] = null;
        _pending.remove(phone);
        return;
      }

      final String? name = await _channel.invokeMethod<String>(
        'resolveContact',
        {'phone': phone},
      );

      _cache[phone] = name;
      _pending.remove(phone);
      notifyListeners();
    } catch (_) {
      _cache[phone] = null;
      _pending.remove(phone);
    }
  }
}
