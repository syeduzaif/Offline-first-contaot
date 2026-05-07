import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class SecureStorageService {
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  /// Returns the SQLCipher passphrase, generating and persisting one on first run.
  Future<String> getOrCreateSqlCipherKey() async {
    final existing = await _storage.read(key: AppConstants.secureStorageKeyName);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final key = base64Url.encode(bytes);
    await _storage.write(
      key: AppConstants.secureStorageKeyName,
      value: key,
    );
    return key;
  }
}
