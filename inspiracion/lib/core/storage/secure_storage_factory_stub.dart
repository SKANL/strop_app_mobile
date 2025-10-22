/// Stub file - Este archivo nunca se ejecuta, solo existe para satisfacer al analizador
/// La implementación real está en los archivos _io.dart y _web.dart
library;

import 'secure_storage_interface.dart';

/// Esta función será reemplazada por la implementación específica de plataforma
SecureStorageInterface createSecureStorage() {
  throw UnsupportedError(
    'Cannot create SecureStorage without dart:html or dart:io.',
  );
}
