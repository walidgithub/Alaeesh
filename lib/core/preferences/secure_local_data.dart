import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageLoginHelper {
  final FlutterSecureStorage _secureStorage;
  SecureStorageLoginHelper(this._secureStorage);

  // Load saved email and password
  Future<Map<String, String>> loadUserData() async {
    final id = await _secureStorage.read(key: 'id') ?? '';
    final email = await _secureStorage.read(key: 'email') ?? '';
    final displayName = await _secureStorage.read(key: 'displayName') ?? '';
    final photoUrl = await _secureStorage.read(key: 'photoUrl') ?? '';
    final role = await _secureStorage.read(key: 'role') ?? '';

    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  // Save or delete user data based on rememberMe status
  Future<void> saveUserData({
    required String id,
    required String email,
    required String displayName,
    required String photoUrl,
    required String role,
  }) async {
    await _secureStorage.write(key: 'id', value: id);
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'displayName', value: displayName);
    await _secureStorage.write(key: 'photoUrl', value: photoUrl);
    await _secureStorage.write(key: 'role', value: role);
  }

  Future<void> clearUserData() async {
    try {
      await _secureStorage.delete(key: 'id');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'displayName');
      await _secureStorage.delete(key: 'photoUrl');
      await _secureStorage.delete(key: 'role');
    } catch (e) {
      print("Error removing user data: $e");
    }
  }

  // Load saved email and password
  Future<Map<String, String>> loadCommentData() async {
    final id = await _secureStorage.read(key: 'id') ?? '';
    return {
      'id': id,
    };
  }

  // Save or delete user data based on rememberMe status
  Future<void> saveCommentData({
    required String id,
  }) async {
    await _secureStorage.write(key: 'id', value: id);
  }
}
