import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_interface.dart';

/// Implementación de almacenamiento seguro para plataformas móviles
/// 
/// Usa flutter_secure_storage que guarda datos en:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
class SecureStorageMobile implements SecureStorageInterface {
  final FlutterSecureStorage _storage;

  SecureStorageMobile(this._storage);

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }
}
