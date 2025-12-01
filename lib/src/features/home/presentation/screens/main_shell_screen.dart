// lib/src/features/home/presentation/screens/main_shell_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_ui/theme/app_colors.dart';
import '../providers/projects_provider.dart';
import '../widgets/dialogs/project_selector_bottom_sheet.dart';

/// Shell principal con navegación simplificada y FAB inteligente
///
/// IMPLEMENTACIÓN FASE 8 (Responsividad):
/// - Soporte para Tablets/Desktop usando NavigationRail
/// - Mobile mantiene BottomAppBar
class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/project')) return 1; // "Mi Proyecto"
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
        // Navegar a la lista de proyectos (detalles)
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

  void _onFabTapped(BuildContext context) {
    _showProjectSelector(context);
  }

  void _showProjectSelector(BuildContext context) {
    final projectsProvider = context.read<ProjectsProvider>();
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: projectsProvider,
        child: ProjectSelectorBottomSheet(parentContext: parentContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) => _onItemTapped(context, index),
              labelType: NavigationRailLabelType.all,
              leading: FloatingActionButton(
                onPressed: () => _onFabTapped(context),
                backgroundColor: AppColors.accent,
                elevation: 4,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.business_outlined),
                  selectedIcon: Icon(Icons.business),
                  label: Text('Proyecto'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  selectedIcon: Icon(Icons.task_alt),
                  label: Text('Tareas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Perfil'),
                ),
              ],
            ),
          if (isWideScreen) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              color: Colors.white,
              elevation: 8,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Inicio',
                      isSelected: currentIndex == 0,
                      onTap: () => _onItemTapped(context, 0),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.business_outlined,
                      activeIcon: Icons.business,
                      label: 'Proyecto',
                      isSelected: currentIndex == 1,
                      onTap: () => _onItemTapped(context, 1),
                    ),
                    const SizedBox(width: 48), // Espacio para el FAB
                    _buildNavItem(
                      context,
                      icon: Icons.task_alt_outlined,
                      activeIcon: Icons.task_alt,
                      label: 'Tareas',
                      isSelected: currentIndex == 2,
                      onTap: () => _onItemTapped(context, 2),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Perfil',
                      isSelected: currentIndex == 3,
                      onTap: () => _onItemTapped(context, 3),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: isWideScreen
          ? null
          : FloatingActionButton(
              onPressed: () => _onFabTapped(context),
              backgroundColor: AppColors.accent,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.iconColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
