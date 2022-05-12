import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  // Singleton
  static final SecureStorageUtil _singleton = SecureStorageUtil._internal();

  factory SecureStorageUtil() => _singleton;

  SecureStorageUtil._internal();

  static SecureStorageUtil get shared => _singleton;

  // Variable
  final storage = const FlutterSecureStorage();

  Future<String?> readData(String key) async {
    final String? value = await storage.read(key: key);
    return value;
  }

  Future writeData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future deleteKey(String key) async {
    await storage.delete(key: key);
  }

  Future deleteAll() async {
    await storage.deleteAll();
  }
}
