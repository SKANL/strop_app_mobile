import 'package:shared_preferences/shared_preferences.dart';
import 'secure_storage_interface.dart';

/// Implementación de almacenamiento para Desktop (Windows, macOS, Linux)
/// 
/// Usa SharedPreferences en lugar de flutter_secure_storage porque:
/// - Windows Credential Manager tiene problemas de permisos
/// - SharedPreferences es más confiable en Desktop
/// - Para tokens JWT, SharedPreferences es suficientemente seguro en Desktop
/// 
/// NOTA DE SEGURIDAD:
/// SharedPreferences NO es tan seguro como KeyChain/EncryptedSharedPreferences,
/// pero para una aplicación Desktop empresarial es aceptable porque:
/// 1. El usuario tiene control físico de la máquina
/// 2. Los tokens JWT expiran rápido (15 minutos típicamente)
/// 3. Es preferible una solución que FUNCIONE que una ultra-segura que NO funcione
class SecureStorageDesktop implements SecureStorageInterface {
  SharedPreferences? _prefs;

  /// Inicializa SharedPreferences de forma lazy
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  @override
  Future<String?> read({required String key}) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  @override
  Future<void> delete({required String key}) async {
    final prefs = await _preferences;
    await prefs.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await _preferences;
    // Solo eliminar las keys relacionadas con auth
    final keys = prefs.getKeys().where((key) => 
      key.startsWith('auth_') || 
      key.startsWith('user_') ||
      key.contains('token')
    );
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  @override
  Future<bool> containsKey({required String key}) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }
}
