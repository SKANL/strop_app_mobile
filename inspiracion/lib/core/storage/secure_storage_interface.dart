/// Interface para almacenamiento seguro multiplataforma
/// 
/// Esta abstracción permite diferentes implementaciones según la plataforma:
/// - Mobile: flutter_secure_storage (Keychain/Keystore)
/// - Web: localStorage del navegador
abstract class SecureStorageInterface {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<bool> containsKey({required String key});
}
