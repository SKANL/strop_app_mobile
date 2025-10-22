import 'package:flutter/material.dart';

class AppTheme {
  // Definimos nuestros colores primarios para tener una paleta consistente.
  static const Color primaryColor = Color(
    0xFF1A237E,
  ); // Un azul oscuro corporativo
  static const Color accentColor = Color(0xFFF57C00); // Un naranja para acentos
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Un gris claro para fondos
  static const Color errorColor = Color(
    0xFFD32F2F,
  ); // Rojo estándar para errores

  /// El tema principal de la aplicación Strop.
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,

      // Configuración del AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Color del texto y los iconos
        elevation: 4,
      ),

      // Configuración de los botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Configuración de los Floating Action Buttons
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),

      // Configuración de los campos de formulario
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: primaryColor),
      ),

      // Configuración de los Cards
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
