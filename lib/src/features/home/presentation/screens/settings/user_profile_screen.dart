// lib/src/features/home/presentation/screens/settings/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../widgets/sections/user_avatar_section.dart';
import '../../widgets/dialogs/change_password_dialog.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../../../../core/core_ui/widgets/layouts/responsive_container.dart';

/// Pantalla de Perfil de Usuario (Fase 8 UI/UX Overhaul)
///
/// CAMBIOS:
/// - Uso de ResponsiveContainer para soporte en tablets
/// - Diseño modernizado con tarjetas y mejor espaciado
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final user = authProvider.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // Avatar con diseño Hero
                  UserAvatarSection(
                    userName: user?.name ?? 'Usuario',
                    onEditPhoto: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cambio de foto (pendiente)'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Información del usuario
                  AppCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Información Personal',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Nombre Completo',
                          value: user?.name ?? 'No disponible',
                        ),
                        const Divider(height: 32),

                        InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Correo Electrónico',
                          value: user?.email ?? 'No disponible',
                        ),
                        const Divider(height: 32),

                        InfoRow(
                          icon: Icons.work_outline,
                          label: 'Rol Asignado',
                          value: _getRoleLabel(user?.role),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Acciones de Seguridad
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: AppColors.primary,
                            ),
                          ),
                          title: const Text('Cambiar Contraseña'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const ChangePasswordDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Versión de la App
                  Text(
                    'Versión 1.0.0 (Build 100)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getRoleLabel(dynamic role) {
    if (role == null) return 'No asignado';
    final roleStr = role.toString().split('.').last;
    switch (roleStr) {
      case 'superadmin':
        return 'Super Administrador';
      case 'owner':
        return 'Dueño';
      case 'superintendent':
        return 'Superintendente';
      case 'resident':
        return 'Residente';
      case 'cabo':
        return 'Cabo';
      default:
        return roleStr;
    }
  }
}
