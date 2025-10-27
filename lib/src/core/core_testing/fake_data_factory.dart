import 'dart:math';

/// Factory centralizado para generar datos fake.
/// 
/// Elimina duplicación de datos hardcodeados en datasources.
/// Proporciona métodos reutilizables para generar listas de datos fake.
/// 
/// Ejemplo de uso:
/// ```dart
/// // En un datasource
/// @override
/// Future<List<IncidentEntity>> getIncidents() async {
///   return FakeDataFactory.generateIncidents(count: 20);
/// }
/// ```
class FakeDataFactory {
  static final Random _random = Random();
  
  // Datos base para generación
  static final List<String> _nombres = [
    'Juan', 'María', 'Pedro', 'Ana', 'Carlos', 'Lucía', 'Miguel', 'Carmen',
    'José', 'Isabel', 'Francisco', 'Rosa', 'Antonio', 'Laura', 'Manuel', 'Elena',
  ];
  
  static final List<String> _apellidos = [
    'García', 'González', 'Rodríguez', 'Fernández', 'López', 'Martínez', 'Sánchez', 'Pérez',
    'Gómez', 'Martín', 'Jiménez', 'Ruiz', 'Hernández', 'Díaz', 'Moreno', 'Muñoz',
  ];
  
  static final List<String> _proyectos = [
    'Construcción Torre A',
    'Remodelación Edificio Central',
    'Ampliación Planta Industrial',
    'Mantenimiento Estructural',
    'Obra Civil Sector Norte',
    'Instalaciones Eléctricas',
    'Sistema de Climatización',
    'Infraestructura Vial',
  ];
  
  static final List<String> _empresas = [
    'Constructora ABC',
    'Ingeniería XYZ',
    'Grupo Constructor 123',
    'Obras y Proyectos SAC',
    'Construcciones del Sur',
    'Ingenieros Asociados',
  ];
  
  static final List<String> _cargos = [
    'Ingeniero',
    'Supervisor',
    'Capataz',
    'Técnico',
    'Maestro de Obra',
    'Operario',
    'Residente de Obra',
    'Superintendente',
  ];
  
  static final List<String> _tiposIncidente = [
    'Seguridad',
    'Calidad',
    'Medioambiente',
    'Producción',
    'Mantenimiento',
    'Logística',
  ];
  
  static final List<String> _prioridades = ['Baja', 'Media', 'Alta', 'Crítica'];
  
  static final List<String> _estados = ['Pendiente', 'En Proceso', 'Completado', 'Cancelado'];
  
  static final List<String> _descripcionesBase = [
    'Se requiere revisión de',
    'Problema detectado en',
    'Es necesario ajustar',
    'Se observó falla en',
    'Solicitud de verificación de',
    'Incidente reportado en',
    'Requiere atención urgente',
    'Necesita mantenimiento',
  ];
  
  // Generadores de datos primitivos
  
  /// Genera un nombre completo aleatorio
  static String generateNombreCompleto() {
    final nombre = _nombres[_random.nextInt(_nombres.length)];
    final apellido1 = _apellidos[_random.nextInt(_apellidos.length)];
    final apellido2 = _apellidos[_random.nextInt(_apellidos.length)];
    return '$nombre $apellido1 $apellido2';
  }
  
  /// Genera un email basado en un nombre
  static String generateEmail([String? nombre]) {
    nombre ??= generateNombreCompleto();
    final parts = nombre.toLowerCase().split(' ');
    return '${parts.first}.${parts.last}@strop.com';
  }
  
  /// Genera un teléfono aleatorio
  static String generateTelefono() {
    return '9${_random.nextInt(100000000).toString().padLeft(8, '0')}';
  }
  
  /// Genera un nombre de proyecto aleatorio
  static String generateNombreProyecto() {
    return _proyectos[_random.nextInt(_proyectos.length)];
  }
  
  /// Genera un nombre de empresa aleatorio
  static String generateNombreEmpresa() {
    return _empresas[_random.nextInt(_empresas.length)];
  }
  
  /// Genera un cargo aleatorio
  static String generateCargo() {
    return _cargos[_random.nextInt(_cargos.length)];
  }
  
  /// Genera un tipo de incidente aleatorio
  static String generateTipoIncidente() {
    return _tiposIncidente[_random.nextInt(_tiposIncidente.length)];
  }
  
  /// Genera una prioridad aleatoria
  static String generatePrioridad() {
    return _prioridades[_random.nextInt(_prioridades.length)];
  }
  
  /// Genera un estado aleatorio
  static String generateEstado() {
    return _estados[_random.nextInt(_estados.length)];
  }
  
  /// Genera una descripción aleatoria
  static String generateDescripcion([String? complemento]) {
    final base = _descripcionesBase[_random.nextInt(_descripcionesBase.length)];
    complemento ??= _proyectos[_random.nextInt(_proyectos.length)];
    return '$base $complemento';
  }
  
  /// Genera una fecha aleatoria en los últimos N días
  static DateTime generateFechaReciente({int maxDiasAtras = 30}) {
    final diasAtras = _random.nextInt(maxDiasAtras);
    return DateTime.now().subtract(Duration(days: diasAtras));
  }
  
  /// Genera una fecha aleatoria entre dos fechas
  static DateTime generateFechaEntre(DateTime inicio, DateTime fin) {
    final diferencia = fin.difference(inicio).inDays;
    final diasAleatorios = _random.nextInt(diferencia);
    return inicio.add(Duration(days: diasAleatorios));
  }
  
  /// Genera un ID aleatorio
  static String generateId() {
    return _random.nextInt(100000).toString();
  }
  
  /// Genera un código alfanumérico
  static String generateCodigo({int longitud = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      longitud,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }
  
  /// Genera un número decimal aleatorio
  static double generateDecimal({double min = 0, double max = 100}) {
    return min + _random.nextDouble() * (max - min);
  }
  
  /// Genera un número entero aleatorio
  static int generateInt({int min = 0, int max = 100}) {
    return min + _random.nextInt(max - min);
  }
  
  /// Genera un booleano aleatorio
  static bool generateBool({double probabilidadTrue = 0.5}) {
    return _random.nextDouble() < probabilidadTrue;
  }
  
  /// Genera una URL de imagen placeholder
  static String generateImageUrl({int width = 400, int height = 300}) {
    return 'https://picsum.photos/$width/$height?random=${_random.nextInt(1000)}';
  }
  
  /// Genera una lista de URLs de imágenes
  static List<String> generateImageUrls({int count = 3, int width = 400, int height = 300}) {
    return List.generate(
      count,
      (index) => generateImageUrl(width: width, height: height),
    );
  }
  
  /// Selecciona un elemento aleatorio de una lista
  static T selectRandom<T>(List<T> lista) {
    return lista[_random.nextInt(lista.length)];
  }
  
  /// Selecciona múltiples elementos aleatorios de una lista
  static List<T> selectMultiple<T>(List<T> lista, {int count = 3}) {
    final shuffled = List<T>.from(lista)..shuffle(_random);
    return shuffled.take(count).toList();
  }
  
  // Métodos de utilidad
  
  /// Simula un delay de red
  static Future<void> simulateNetworkDelay({int milliseconds = 500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
  
  /// Simula un error aleatorio
  static void simulateRandomError({double probabilidad = 0.1}) {
    if (_random.nextDouble() < probabilidad) {
      throw Exception('Error simulado de red');
    }
  }
  
  /// Genera datos paginados
  static List<T> paginate<T>(List<T> items, {required int page, required int pageSize}) {
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    
    if (start >= items.length) return [];
    if (end >= items.length) return items.sublist(start);
    
    return items.sublist(start, end);
  }
  
  /// Filtra items por texto de búsqueda
  static List<T> search<T>(
    List<T> items,
    String query,
    String Function(T item) extractor,
  ) {
    if (query.isEmpty) return items;
    
    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      return extractor(item).toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
