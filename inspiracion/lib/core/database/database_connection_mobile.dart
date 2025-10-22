import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<QueryExecutor> createQueryExecutor() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final folder = await getApplicationDocumentsDirectory();
    final path = p.join(folder.path, 'db.sqlite');
    print('Database path: $path');
    return NativeDatabase(File(path));
  }
  // Para web, desktop, o cualquier otra plataforma, no usaremos base de datos.
  // Lanzamos un error si se intenta acceder a ella.
  return NativeDatabase.memory(); // O podrías lanzar un UnimplementedError
}