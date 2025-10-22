// lib/src/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_ui/widgets/app_text_field.dart';
import '../manager/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@strop.com');
  final _passwordController = TextEditingController(text: 'Admin123');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Error desconocido'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      // Navegamos al home después del login exitoso
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de email
          AppEmailField(
            controller: _emailController,
            labelText: 'Correo Electrónico',
            enabled: !_isLoading,
          ),
          
          const SizedBox(height: 16),
          
          // Campo de contraseña
          AppPasswordField(
            controller: _passwordController,
            labelText: 'Contraseña',
            enabled: !_isLoading,
          ),
          
          const SizedBox(height: 8),
          
          // Enlace de "Olvidé mi contraseña"
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : () => context.push('/forgot-password'),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botón de submit
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Iniciar Sesión'),
            ),
        ],
      ),
    );
  }
}
