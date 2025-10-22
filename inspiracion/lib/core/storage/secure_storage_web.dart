import 'dart:html' as html;
import 'secure_storage_interface.dart';

/// Implementación de almacenamiento seguro para plataforma Web
/// 
/// Usa localStorage del navegador. Nota: No es tan seguro como
/// Keychain/Keystore nativo, pero es la única opción disponible en web.
/// 
/// IMPORTANTE: En producción web, considera usar:
/// - HTTPS siempre
/// - Tokens con tiempo de expiración corto
/// - HttpOnly cookies para tokens sensibles
class SecureStorageWeb implements SecureStorageInterface {
  final html.Storage _storage = html.window.localStorage;

  @override
  Future<void> write({required String key, required String value}) async {
    _storage[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _storage[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return _storage.containsKey(key);
  }
}
