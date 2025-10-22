import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Utilidad para detectar la plataforma actual y determinar estrategia de persistencia.
///
/// Estrategia multiplataforma:
/// - Web: Solo API (no persistencia local)
/// - Desktop (Windows/Mac/Linux): Solo API (no persistencia local)
/// - Mobile (Android/iOS): Offline-first con Drift + API
///
/// Uso:
/// ```dart
/// if (PlatformHelper.isMobile) {
///   // Lógica offline-first
/// } else {
///   // Solo API remota
/// }
/// ```
class PlatformHelper {
  PlatformHelper._(); // Constructor privado - clase de utilidades estáticas

  /// Indica si la plataforma actual es Web
  static bool get isWeb => kIsWeb;

  /// Indica si la plataforma actual es Desktop (Windows, macOS, Linux)
  ///
  /// Desktop se trata igual que Web: solo API, sin persistencia local.
  static bool get isDesktop {
    if (kIsWeb) return false;
    
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      // Si falla Platform (por ejemplo, en Web), retorna false
      return false;
    }
  }

  /// Indica si la plataforma actual es Mobile (Android o iOS)
  ///
  /// Mobile usa estrategia offline-first con Drift + sincronización API.
  static bool get isMobile {
    if (kIsWeb) return false;
    
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      // Si falla Platform (por ejemplo, en Web), retorna false
      return false;
    }
  }

  /// Indica si la plataforma debe usar SOLO API (sin persistencia local)
  ///
  /// Retorna true para Web y Desktop.
  static bool get useOnlyApi => isWeb || isDesktop;

  /// Indica si la plataforma debe usar estrategia offline-first (Drift + API)
  ///
  /// Retorna true solo para Mobile (Android/iOS).
  static bool get useOfflineFirst => isMobile;

  /// Obtiene el nombre de la plataforma actual para logging
  static String get platformName {
    if (kIsWeb) return 'Web';
    
    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isLinux) return 'Linux';
    } catch (e) {
      // Fallback si Platform no está disponible
    }
    
    return 'Unknown';
  }

  /// Obtiene una descripción de la estrategia de persistencia para la plataforma actual
  static String get persistenceStrategy {
    if (useOnlyApi) return 'Solo API (sin persistencia local)';
    if (useOfflineFirst) return 'Offline-first (Drift + API)';
    return 'Desconocida';
  }
}
