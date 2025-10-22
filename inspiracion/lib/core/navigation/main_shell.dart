// lib/core/navigation/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/sync/sync_service.dart';
import '../widgets/responsive_layout.dart';
import '../utils/platform_helper.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    Text(authProvider.user?.name ?? 'Invitado'); // Ejemplo de uso del authProvider

    // Lógica para determinar el índice de la pestaña actual a partir de la ruta
    int getCurrentIndex(GoRouterState state) {
      final location = state.uri.toString();
      if (location.startsWith('/projects')) return 1;
      if (location.startsWith('/sync')) return 2;
      if (location.startsWith('/dashboard')) return 0;
      return 0;
    }

    // Lógica para navegar al hacer clic en un ítem
    void onItemTapped(int index, BuildContext context) {
      switch (index) {
        case 0:
          context.go('/dashboard');
          break;
        case 1:
          context.go('/projects');
          break;
        case 2:
          context.go('/sync');
          break;
      }
    }

    return ResponsiveLayout(
      // --- VISTA MÓVIL ---
      mobileBody: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: getCurrentIndex(GoRouterState.of(context)),
          onTap: (index) => onItemTapped(index, context),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Proyectos',
            ),
            // Badge con contador de items pendientes (solo móvil con sincronización)
            if (PlatformHelper.isMobile)
              BottomNavigationBarItem(
                icon: _buildSyncBadge(context),
                label: 'Sincronizar',
              ),
          ],
        ),
      ),
      // --- VISTA WEB/ESCRITORIO ---
      desktopBody: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: getCurrentIndex(GoRouterState.of(context)),
              onDestinationSelected: (index) => onItemTapped(index, context),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: FloatingActionButton(
                  onPressed: () => context.read<AuthProvider>().logout(),
                  tooltip: 'Cerrar Sesión',
                  child: const Icon(Icons.logout),
                ),
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: Text('Proyectos'),
                ),
                // Badge con contador de items pendientes (solo móvil con sincronización)
                if (PlatformHelper.isMobile)
                  NavigationRailDestination(
                    icon: _buildSyncBadge(context),
                    selectedIcon: _buildSyncBadge(context, selected: true),
                    label: const Text('Sincronizar'),
                  ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  /// Badge que muestra el contador de items pendientes de sincronización
  Widget _buildSyncBadge(BuildContext context, {bool selected = false}) {
    // Solo debe llamarse en plataformas móviles con sincronización
    // Este método NO debe ejecutarse en Web o Desktop
    if (!PlatformHelper.isMobile) {
      return const Icon(Icons.sync);
    }

    return Consumer<SyncService>(
      builder: (context, syncService, _) {
        final count = syncService.pendingCount;
        
        return Badge(
          label: Text(count.toString()),
          isLabelVisible: count > 0,
          child: Icon(
            selected ? Icons.sync : Icons.sync_outlined,
          ),
        );
      },
    );
  }
}