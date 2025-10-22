// lib/features/incidents/presentation/screens/incident_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/list_data_view.dart';
import '../../../../core/widgets/data_state_handler.dart';
import '../../../../core/widgets/list_skeleton.dart';
import '../providers/incident_provider.dart';
import '../widgets/incident_list_item.dart';
import '../widgets/incident_detail_view.dart'; // <-- IMPORTAR NUEVO WIDGET

class IncidentListScreen extends StatefulWidget {
  final String projectId;
  final String projectName;

  const IncidentListScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usamos el projectId del widget para cargar las incidencias correctas
      context.read<IncidentProvider>().fetchIncidents(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // El widget principal ahora solo decide qué layout mostrar
    return ResponsiveLayout(
      mobileBody: _IncidentListMobileView(
        projectId: widget.projectId,
        projectName: widget.projectName,
      ),
      desktopBody: _IncidentListWebView(
        projectId: widget.projectId,
        projectName: widget.projectName,
      ),
    );
  }
}

// WIDGET PRIVADO PARA VISTA MÓVIL
class _IncidentListMobileView extends StatelessWidget {
  final String projectId;
  final String projectName;

  const _IncidentListMobileView({required this.projectId, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();

    return Scaffold(
      appBar: MainAppBar(
        title: 'Incidencias: $projectName',
        showBack: true,
      ),
      body: ListDataView<dynamic>(
        isLoading: provider.isLoading,
        error: provider.error,
        data: provider.incidents,
        onRefresh: () async => context.read<IncidentProvider>().fetchIncidents(projectId),
        onRetry: () => context.read<IncidentProvider>().fetchIncidents(projectId),
        itemBuilder: (context, incident, index) => IncidentListItem(
          incident: incident,
          onTap: () => context.push('/incident/${incident.id}'),
        ),
        emptyBuilder: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No hay incidencias para este proyecto.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.push('/project/$projectId/add-incident'), child: const Text('Crear incidencia')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/project/$projectId/add-incident'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// WIDGET PRIVADO PARA VISTA WEB
class _IncidentListWebView extends StatelessWidget {
  final String projectId;
  final String projectName;
  
  const _IncidentListWebView({required this.projectId, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias: $projectName'),
        automaticallyImplyLeading: false, // Opcional: para integrarlo mejor en MainShell
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/project/$projectId/add-incident'),
              icon: const Icon(Icons.add),
              label: const Text('Nueva Incidencia'),
            ),
          )
        ],
      ),
      body: DataStateHandler<List<dynamic>>(
        isLoading: provider.isLoading,
        error: provider.error,
        data: provider.incidents,
        loadingBuilder: () => const ListSkeleton(),
        errorBuilder: (err) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ocurrió un error: $err', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => context.read<IncidentProvider>().fetchIncidents(projectId), child: const Text('Reintentar')),
              ],
            ),
          ),
        ),
        emptyBuilder: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Selecciona un proyecto para ver sus incidencias.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.push('/project/$projectId/add-incident'), child: const Text('Crear incidencia')),
            ],
          ),
        ),
        contentBuilder: (incidents) {
          return Row(
            children: [
              // --- COLUMNA DE LA LISTA (MAESTRO) ---
              SizedBox(
                width: 350,
                child: ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    final incident = incidents[index];
                    return IncidentListItem(
                      incident: incident,
                      isSelected: provider.selectedIncidentForDetail?.id == incident.id,
                      onTap: () => context.read<IncidentProvider>().selectIncidentForDetail(incident),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              // --- COLUMNA DEL DETALLE ---
              Expanded(
                child: provider.selectedIncidentForDetail != null
                    ? IncidentDetailView(incident: provider.selectedIncidentForDetail!)
                    : const Center(child: Text('Selecciona una incidencia para ver los detalles')),
              ),
            ],
          );
        },
      ),
    );
  }
}