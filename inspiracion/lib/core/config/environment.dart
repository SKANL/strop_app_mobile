/// Configuración de entornos de la aplicación
/// 
/// Define las URLs base y configuraciones específicas para cada entorno
class Environment {
  // Entorno actual (cambiar a production para producción)
  static const String current = development;
  
  // Constantes de entornos
  static const String development = 'development';
  static const String production = 'production';
  
  // URLs base por entorno
  // IMPORTANTE: Para dispositivos físicos Android, usa la IP de tu laptop
  // Para emuladores Android, usa 10.0.2.2:5024
  // Para localhost (web/desktop), usa localhost:5024
  static const Map<String, String> _baseUrls = {
    development: 'http://10.3.1.9:5024', // IP de tu laptop en la red local
    production: 'https://api.strop.com',
    // 'http://192.168.1.9:5024'
  };

  // Timeouts por entorno (en milisegundos)
  static const Map<String, int> _connectTimeouts = {
    development: 30000, // 30 segundos
    production: 15000,  // 15 segundos
  };

  static const Map<String, int> _receiveTimeouts = {
    development: 30000, // 30 segundos
    production: 15000,  // 15 segundos
  };
  
  // Getters públicos
  static String get baseUrl => _baseUrls[current] ?? _baseUrls[development]!;
  static int get connectTimeout => _connectTimeouts[current] ?? _connectTimeouts[development]!;
  static int get receiveTimeout => _receiveTimeouts[current] ?? _receiveTimeouts[development]!;
  
  // Configuración de logs
  static bool get enableDetailedLogs => current == development;
  
  // Información del entorno
  static String get environmentName => current;
  static bool get isDevelopment => current == development;
  static bool get isProduction => current == production;
}
