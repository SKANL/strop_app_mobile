// lib/src/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../widgets/login_form.dart';

/// Pantalla de Login - Solo para móvil
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Título
                Text(
                  'Strop',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gestión de Incidencias en Obra',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Animación Lottie
                Lottie.asset(
                  'assets/animations/login_animation_v3.json',
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                // Formulario de login
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
