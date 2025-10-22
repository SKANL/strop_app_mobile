import 'package:drift/drift.dart';

/// Esta es la implementación para plataformas no soportadas (Web, Desktop).
/// Lanza un error si se intenta crear la base de datos.
QueryExecutor createQueryExecutor() {
  throw UnsupportedError('La base de datos local no está soportada en esta plataforma.');
}