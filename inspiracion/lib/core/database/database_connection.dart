// import 'package:drift/drift.dart';

// Esta es la magia: exportamos un archivo u otro dependiendo de la plataforma.
// El compilador para web NUNCA verá 'database_connection_mobile.dart'.
export 'database_connection_unsupported.dart'
    if (dart.library.io) 'database_connection_mobile.dart';