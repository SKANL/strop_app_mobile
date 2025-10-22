// lib/src/features/home/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          return ListView(
            children: [
              // Información de Usuario
              _buildSection(
                context,
                title: 'Información de Usuario',
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(user?.name ?? 'Usuario'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.email ?? ''),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            _getRoleLabel(user?.role),
                            style: const TextStyle(fontSize: 11),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/user-profile'),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Sincronización
              _buildSection(
                context,
                title: 'Sincronización',
                children: [
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Estado de Sincronización'),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        const Text('Sincronizado'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/sync-queue'),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Preferencias
              _buildSection(
                context,
                title: 'Preferencias',
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Notificaciones Push'),
                    subtitle: const Text('Recibir notificaciones de la app'),
                    value: true,
                    onChanged: (value) {
                      // TODO: Implementar toggle de notificaciones
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Modo Oscuro'),
                    subtitle: const Text('Cambiar apariencia de la app'),
                    value: false,
                    onChanged: (value) {
                      // TODO: Implementar toggle de tema
                    },
                  ),
                ],
              ),

              const Divider(height: 32),

              // Acerca de
              _buildSection(
                context,
                title: 'Acerca de',
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Versión de la App'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Ayuda y Soporte'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Abrir pantalla de ayuda
                    },
                  ),
                ],
              ),

              const Divider(height: 32),

              // Cerrar Sesión
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, authProvider),
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  String _getRoleLabel(dynamic role) {
    if (role == null) return 'Usuario';
    final roleStr = role.toString().split('.').last;
    switch (roleStr) {
      case 'superadmin':
        return 'Super Admin';
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

  Future<void> _showLogoutDialog(
      BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
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
