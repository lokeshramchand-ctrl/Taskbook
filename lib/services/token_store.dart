import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores the GitHub personal access token in OS-level secure storage
/// (iOS Keychain / Android Keystore-backed EncryptedSharedPreferences).
/// The token never touches Dart source, git, or plain-text app storage.
class TokenStore {
  TokenStore._();
  static final TokenStore instance = TokenStore._();

  static const _key = 'github_token';
  final _storage = const FlutterSecureStorage();

  Future<String?> readToken() => _storage.read(key: _key);

  Future<void> saveToken(String token) =>
      _storage.write(key: _key, value: token.trim());

  Future<void> clearToken() => _storage.delete(key: _key);
}
