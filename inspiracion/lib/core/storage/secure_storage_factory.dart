/// Factory para crear la implementación correcta de SecureStorageInterface
/// según la plataforma actual
/// 
/// Este archivo usa imports condicionales para cargar solo el código
/// específico de cada plataforma, evitando errores de compilación
library;

// Import condicional: solo se carga el archivo correcto según la plataforma
export 'secure_storage_factory_stub.dart'
    if (dart.library.io) 'secure_storage_factory_io.dart'
    if (dart.library.html) 'secure_storage_factory_web.dart';
