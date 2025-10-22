// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/lottie_animation.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../widgets/login_form.dart'; // <-- IMPORTAMOS EL NUEVO WIDGET

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: _LoginMobileView(),
        desktopBody: _LoginWebView(),
      ),
    );
  }
}

// --- VISTA PRIVADA PARA MÓVIL (REPLICA TU DISEÑO ORIGINAL) ---
class _LoginMobileView extends StatelessWidget {
  const _LoginMobileView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Strop', style: Theme.of(context).textTheme.headlineLarge),
            const LottieAnimation.asset(
              'lib/assets/animations/login_animation.json',
              width: 300,
              height: 200,
            ),
            const SizedBox(height: 32),
            const LoginForm(), // Usamos el widget de formulario
          ],
        ),
      ),
    );
  }
}

// --- VISTA PRIVADA PARA WEB/TABLET (DISEÑO DE PANELES) ---
class _LoginWebView extends StatelessWidget {
  const _LoginWebView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel Izquierdo: Animación y Marca
        Expanded(
          flex: 2, // Le damos más espacio a la animación
          child: Container(
            color: Theme.of(context).colorScheme.surface.withAlpha(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Strop', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Text('Gestión de incidencias en obra'),
                const LottieAnimation.asset('lib/assets/animations/login_animation.json'),
              ],
            ),
          ),
        ),
        // Panel Derecho: Formulario de Login
        Expanded(
          flex: 1, // Menos espacio para el formulario, más enfocado
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Card(
                elevation: 8,
                margin: EdgeInsets.all(32),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: LoginForm(), // Reutilizamos el mismo formulario
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}