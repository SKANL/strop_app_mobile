import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        maxLines: maxLines,
        obscureText: obscureText,
        // Usamos el validador que nos pasan, o uno por defecto que comprueba si está vacío.
        validator: validator ?? (value) {
          if (value == null || value.trim().isEmpty) {
            return '$labelText es requerido';
          }
          return null;
        },
      ),
    );
  }
}