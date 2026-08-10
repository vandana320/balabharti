import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String emailKey = "email";
  static const String userIdKey = "userId";
  static const String roleKey = "role";

  static Future<void> saveUser({
    required int id,
    required String email,
    required String role,
  }) async {
    await _storage.write(key: userIdKey, value: id.toString());

    await _storage.write(key: emailKey, value: email);

    await _storage.write(key: roleKey, value: role);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: emailKey);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static Future<int?> getUserId() async {
    final value = await _storage.read(key: userIdKey);

    if (value == null) {
      return null;
    }

    return int.tryParse(value);
  }
}
