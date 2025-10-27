// lib/src/features/home/presentation/widgets/settings/logout_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra el botón de cerrar sesión.
/// 
/// Al presionarlo, muestra un diálogo de confirmación usando DialogActions.
/// Si se confirma, cierra la sesión y navega al login.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return AppButton.danger(
      text: 'Cerrar Sesión',
      icon: Icons.logout,
      size: ButtonSize.large,
      onPressed: () => _showLogoutDialog(context, authProvider),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          DialogActions.danger(
            onCancel: () => Navigator.of(context).pop(false),
            onConfirm: () => Navigator.of(context).pop(true),
            confirmText: 'Cerrar Sesión',
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await authProvider.logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}
