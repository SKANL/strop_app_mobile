// lib/src/core/core_ui/widgets/app_text_field.dart
import 'package:flutter/material.dart';

/// TextField genérico y reutilizable
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final void Function(String)? onChanged;
  
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: maxLength != null ? null : '',
      ),
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return '${labelText ?? 'Este campo'} es requerido';
        }
        return null;
      },
    );
  }
}

/// TextField para email
class AppEmailField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool enabled;
  
  const AppEmailField({
    super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText ?? 'Correo Electrónico',
      hintText: 'usuario@ejemplo.com',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: validator ?? _defaultEmailValidator,
      enabled: enabled,
    );
  }
  
  String? _defaultEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }
}

/// TextField para contraseña
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool enabled;
  
  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.enabled = true,
  });
  
  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      enabled: widget.enabled,
      labelText: widget.labelText ?? 'Contraseña',
      obscureText: _obscureText,
      prefixIcon: const Icon(Icons.lock_outlined),
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      validator: widget.validator,
    );
  }
}
