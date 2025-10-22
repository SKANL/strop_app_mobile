import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:strop_app_v2/core/widgets/main_app_bar.dart';
import 'package:strop_app_v2/core/widgets/responsive_layout.dart';
import 'package:strop_app_v2/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:strop_app_v2/features/dashboard/presentation/widgets/kpi_card.dart';

import '../../../../domain/entities/dashboard_summary_entity.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Llama a fetchSummary una sola vez cuando la pantalla se inicializa.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    // La pantalla principal ahora solo se encarga de cambiar entre layouts.
    return const ResponsiveLayout(
      mobileBody: _DashboardMobileView(),
      desktopBody: _DashboardWebView(),
    );
  }
}

//--- WIDGET PRIVADO PARA LA VISTA MÓVIL ---

class _DashboardMobileView extends StatelessWidget {
  const _DashboardMobileView();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DashboardProvider>();

    return Scaffold(
      appBar: MainAppBar(
        title: 'Dashboard Ejecutivo',
        showLogout: false, // El logout se maneja en el MainShell
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchSummary(),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.summary == null) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final summary = provider.summary!;
          // El RefreshIndicator es perfecto para la experiencia táctil móvil.
          return RefreshIndicator(
            onRefresh: () => provider.fetchSummary(),
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _buildKpiCards(context, summary),
            ),
          );
        },
      ),
    );
  }
}

//--- WIDGET PRIVADO PARA LA VISTA WEB/DESKTOP ---

class _DashboardWebView extends StatelessWidget {
  const _DashboardWebView();

  @override
  Widget build(BuildContext context) {
    // final provider = context.read<DashboardProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Sin AppBar, el título y las acciones van en el body.
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.summary == null) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final summary = provider.summary!;
          // Usamos un CustomScrollView para combinar el RefreshIndicator con otros elementos.
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard Ejecutivo',
                        style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Actualizar Datos',
                        onPressed: () => provider.fetchSummary(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                sliver: SliverGrid.count(
                  crossAxisCount: 5, // 5 columnas para mostrar todas las tarjetas
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.6, // Ajusta la proporción de las tarjetas
                  children: _buildKpiCards(context, summary),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//--- FUNCIÓN HELPER REUTILIZABLE PARA CONSTRUIR LAS TARJETAS ---
// Esto evita duplicar la lista de KpiCard en ambos layouts.

List<Widget> _buildKpiCards(BuildContext context, DashboardSummary summary) {
  return [
    KpiCard(
      title: 'Proyectos Activos',
      value: summary.activeProjects.toString(),
      icon: Icons.business,
      color: Colors.blue,
    ),
    KpiCard(
      title: 'Incidencias Abiertas',
      value: summary.openIncidents.toString(),
      icon: Icons.warning,
      color: Colors.orange,
    ),
    KpiCard(
      title: 'Incidencias Cerradas',
      value: summary.closedIncidents.toString(),
      icon: Icons.check_circle,
      color: Colors.green,
    ),
    KpiCard(
      title: 'Usuarios Registrados',
      value: summary.totalUsers.toString(),
      icon: Icons.people,
      color: Colors.purple,
    ),
    KpiCard(
      title: 'Ver Proyectos',
      value: summary.activeProjects.toString(), // Muestra el número para consistencia
      icon: Icons.list_alt,
      color: Theme.of(context).colorScheme.primary,
      onTap: () => context.push('/projects'),
    ),
  ];
}