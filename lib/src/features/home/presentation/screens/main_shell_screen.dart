// lib/src/features/home/presentation/screens/main_shell_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_ui/theme/app_colors.dart';

/// Shell principal con bottom navigation bar
/// 
/// Proporciona navegación rápida entre las secciones principales:
/// - **Inicio**: Acciones rápidas para crear reportes + Actividad reciente
/// - **Proyectos**: Lista completa de proyectos activos y archivados
/// - **Tareas**: Todas las tareas asignadas al usuario (pendientes y completadas)
/// - **Ajustes**: Configuración de perfil, notificaciones y sincronización
/// 
/// FLUJO OPTIMIZADO:
/// 1. Usuario abre app → Ve botón grande "Crear Nuevo Reporte"
/// 2. Toca botón → Selecciona Proyecto (bottom sheet)
/// 3. Selecciona Tipo de reporte (bottom sheet)
/// 4. Llena formulario → Envía reporte
/// Total: 4 pasos, ~30 segundos
class MainShellScreen extends StatelessWidget {
  final Widget child;
  
  const MainShellScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/projects')) return 1;
    if (location.startsWith('/all-my-tasks')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/projects');
        break;
      case 2:
        context.go('/all-my-tasks');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.iconColor,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            activeIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
