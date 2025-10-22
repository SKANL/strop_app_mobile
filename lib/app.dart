// lib/app.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

/// Widget raíz de la aplicación Strop
/// 
/// Este widget es completamente agnóstico al contenido de la app.
/// Su única responsabilidad es:
/// 1. Obtener el router configurado desde el contenedor de DI
/// 2. Construir el MaterialApp.router
class StropApp extends StatelessWidget {
  const StropApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el router ya configurado desde GetIt
    final router = GetIt.instance<GoRouter>();
    
    return MaterialApp.router(
      title: 'Strop - Campo',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // El tema se aplicará desde el router inicial
    );
  }
}
