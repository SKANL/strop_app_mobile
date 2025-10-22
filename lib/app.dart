// lib/app.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'src/features/auth/presentation/manager/auth_provider.dart';

/// Widget raíz de la aplicación Strop
/// 
/// Este widget es completamente agnóstico al contenido de la app.
/// Su única responsabilidad es:
/// 1. Obtener el router configurado desde el contenedor de DI
/// 2. Proveer AuthProvider globalmente (necesario para toda la app)
/// 3. Construir el MaterialApp.router
class StropApp extends StatelessWidget {
  const StropApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el router ya configurado desde GetIt
    final router = GetIt.instance<GoRouter>();
    
    // Proveemos AuthProvider globalmente para que esté disponible en toda la app
    // Esto es necesario porque múltiples features necesitan acceso al usuario actual
    return ChangeNotifierProvider<AuthProvider>.value(
      value: GetIt.instance<AuthProvider>(),
      child: MaterialApp.router(
        title: 'Strop - Campo',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        // El tema se aplicará desde el router inicial
      ),
    );
  }
}
