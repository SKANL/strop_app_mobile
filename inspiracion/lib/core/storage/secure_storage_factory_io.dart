/// Implementación para plataformas nativas (Android, iOS, Desktop)
library;

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_interface.dart';
import 'secure_storage_mobile.dart';
import 'secure_storage_desktop.dart';

/// Crea una instancia de SecureStorage para plataformas nativas
/// 
/// - Mobile (Android/iOS): Usa flutter_secure_storage (KeyChain/EncryptedSharedPreferences)
/// - Desktop (Windows/macOS/Linux): Usa SharedPreferences (más confiable en Desktop)
SecureStorageInterface createSecureStorage() {
  // Desktop: Windows, macOS, Linux
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return SecureStorageDesktop();
  }
  
  // Mobile: Android, iOS
  return SecureStorageMobile(const FlutterSecureStorage());
}
