// lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'di.dart';

/// Punto de entrada de la aplicación Strop
///
/// Responsabilidades:
/// 1. Inicializar los bindings de Flutter
/// 2. Configurar la inyección de dependencias
/// 3. Lanzar la aplicación
void main() async {
  // Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar todas las dependencias de la aplicación
  await setupDependencies();

  // Iniciar la aplicación
  runApp(const StropApp());
}
