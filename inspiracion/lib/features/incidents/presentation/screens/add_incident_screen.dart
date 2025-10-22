// lib/features/incidents/presentation/screens/add_incident_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../widgets/add_incident_form.dart'; // <-- IMPORTAMOS EL NUEVO WIDGET

class AddIncidentScreen extends StatelessWidget {
  final String projectId;
  const AddIncidentScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _AddIncidentMobileView(projectId: projectId),
      desktopBody: _AddIncidentWebView(projectId: projectId),
    );
  }
}

// --- VISTA PRIVADA PARA MÓVIL ---
class _AddIncidentMobileView extends StatelessWidget {
  final String projectId;
  const _AddIncidentMobileView({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Registrar Incidencia',
        showBack: true,
      ),
      // Tu código usaba un Column, pero lo ponemos dentro de un ListView
      // para asegurar que no haya desbordes con el teclado.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          AddIncidentForm(projectId: projectId), // Pasamos el projectId
        ],
      ),
    );
  }
}

// --- VISTA PRIVADA PARA WEB/TABLET ---
class _AddIncidentWebView extends StatelessWidget {
  final String projectId;
  const _AddIncidentWebView({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Incidencia'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(32.0),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  AddIncidentForm(projectId: projectId), // Reutilizamos el mismo widget
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}