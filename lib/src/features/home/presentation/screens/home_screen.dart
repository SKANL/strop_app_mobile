// lib/src/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/projects_provider.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../widgets/sections/quick_actions_widget.dart';
import '../widgets/sections/recent_activity_widget.dart';

/// Pantalla principal de inicio de la aplicación
/// 
/// ENFOQUE: Agilizar el registro de incidencias
/// 
/// Esta pantalla está diseñada para que el usuario pueda:
/// 1. **Crear reportes rápidamente**: Botón grande y visible para crear nuevos reportes
/// 2. **Ver actividad reciente**: Resumen compacto de últimos reportes y acciones
/// 3. **Acceder a tareas**: Contador visible de tareas pendientes
/// 
/// SIMPLIFICACIONES REALIZADAS:
/// - ❌ Eliminada sección de "Proyectos Activos" (duplicada con tab Proyectos)
/// - ✅ Foco en acciones rápidas como elemento principal
/// - ✅ Layout minimalista para reducir fricción
/// 
/// FLUJO DE REGISTRO DE INCIDENCIA:
/// Home → [Toca "Crear Nuevo Reporte"] → Selecciona Proyecto → Selecciona Tipo → Formulario → ✓
/// Tiempo estimado: 30 segundos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar proyectos activos para que estén disponibles en el ProjectSelector
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().loadActiveProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                if (user != null) AvatarWithInitials.forRole(name: user.name, role: user.role.toString().split('.').last),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user != null ? 'Hola, ${user.name}' : 'Inicio',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Recargar tareas y actividades recientes
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.user?.id ?? '';
              if (userId.isNotEmpty) {
                // Podrías agregar aquí la recarga de datos si es necesario
              }
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                
                // HÉROE: Acciones Rápidas - Lo más importante
                // Este es el foco principal de la app: registrar incidencias rápidamente
                const SliverToBoxAdapter(
                  child: QuickActionsWidget(),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                
                // Mini resumen: Actividad Reciente compacta
                const SliverToBoxAdapter(
                  child: RecentActivityWidget(),
                ),
                
                // Espacio final
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        );
      },
    );
  }
}
