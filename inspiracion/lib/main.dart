import 'package:flutter/material.dart';
import 'app.dart'; // 1. Importamos el widget raíz de nuestra app.
import 'core/di/injector.dart'; // 2. Importamos nuestro configurador de dependencias.
import 'package:url_strategy/url_strategy.dart';

// 3. 'async' convierte nuestra función 'main' en una función asíncrona.
//    Esto nos permite esperar a que las tareas de inicialización terminen.
void main() async {

  // 4. Esta línea es crucial. Se asegura de que Flutter esté completamente
  //    listo para usarse antes de ejecutar cualquier otro código.
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  // 5. 'await' le dice a la app que espere aquí hasta que la función 'setupDependencies'
  //    haya terminado de registrar todos nuestros servicios en GetIt.
  await setupDependencies();

  // 6. Una vez que todo está listo, 'runApp' dibuja nuestro widget raíz, StropApp,
  //    en la pantalla, iniciando así la interfaz de usuario.
  runApp(const StropApp());
}