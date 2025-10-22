// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // --- TU LÓGICA DE ESTADO (COPIADA DIRECTAMENTE) ---
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

  // --- TU MÉTODO _submit (COPIADO DIRECTAMENTE) ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Error desconocido'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- TU UI DEL FORMULARIO (COPIADA DIRECTAMENTE) ---
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _emailController,
            labelText: 'Correo Electrónico', obscureText: false,
          ),
          const SizedBox(height: 16), // Espacio añadido para consistencia
          CustomTextFormField(
            controller: _passwordController,
            labelText: 'Contraseña',
            obscureText: true, // Añadido para ocultar la contraseña
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
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