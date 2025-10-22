/// Implementación para plataforma Web
library;

import 'secure_storage_interface.dart';
import 'secure_storage_web.dart';

/// Crea una instancia de SecureStorage para Web
SecureStorageInterface createSecureStorage() {
  return SecureStorageWeb();
}
