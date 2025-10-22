// lib/features/incidents/presentation/screens/incident_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../domain/entities/incident_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../widgets/image_gallery.dart'; // <-- NUEVO
import '../../../../core/widgets/detail_info_row.dart';

class IncidentDetailScreen extends StatefulWidget {
  final String incidentId;
  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  final _closingNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentProvider>().fetchIncidentById(widget.incidentId);
    });
  }

  @override
  void dispose() {
    _closingNoteController.dispose();
    super.dispose();
  }

  // TU LÓGICA DE DIÁLOGO SE MANTIENE EXACTAMENTE IGUAL
  void _showCloseIncidentDialog(BuildContext context, Incident incident) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Incidencia'),
        content: CustomTextFormField(
          controller: _closingNoteController,
          labelText: 'Nota de Cierre',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_closingNoteController.text.trim().isEmpty) return;
              final success = await context
                  .read<IncidentProvider>()
                  .closeIncident(
                    incidentId: incident.id,
                    closingNote: _closingNoteController.text,
                  );
              if (success) {
                _closingNoteController.clear();
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Confirmar Cierre'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final incident = provider.selectedIncident; // Usamos 'selectedIncident' como en tu código

    // TU LÓGICA DE ESTADOS DE CARGA Y ERROR SE MANTIENE
    if (provider.isDetailLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (provider.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${provider.error}')));
    }
    if (incident == null) {
      return const Scaffold(body: Center(child: Text('No se encontró la incidencia.')));
    }

    // LA MAGIA OCURRE AQUÍ: USAMOS RESPONSIVE LAYOUT UNA VEZ TENEMOS LOS DATOS
    return ResponsiveLayout(
      mobileBody: _IncidentDetailMobileView(
        incident: incident,
        currentUser: authProvider.user,
        onShowCloseDialog: () => _showCloseIncidentDialog(context, incident),
      ),
      desktopBody: _IncidentDetailWebView(
        incident: incident,
        currentUser: authProvider.user,
        onShowCloseDialog: () => _showCloseIncidentDialog(context, incident),
      ),
    );
  }
}

// --- VISTA PARA MÓVIL ---
class _IncidentDetailMobileView extends StatelessWidget {
  final Incident incident;
  final User? currentUser;
  final VoidCallback onShowCloseDialog;

  const _IncidentDetailMobileView({
    required this.incident,
    required this.currentUser,
    required this.onShowCloseDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Detalle de Incidencia', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildIncidentInfo(context, incident),
            const SizedBox(height: 16),
            _buildActionButtons(context, incident, currentUser, onShowCloseDialog),
            const SizedBox(height: 24),
            const Text('Evidencia Fotográfica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            ImageGallery(imageUrls: incident.imageUrls, crossAxisCount: 1), // 1 columna para móvil
          ],
        ),
      ),
    );
  }
}

// --- VISTA PARA WEB/TABLET ---
class _IncidentDetailWebView extends StatelessWidget {
  final Incident incident;
  final User? currentUser;
  final VoidCallback onShowCloseDialog;

  const _IncidentDetailWebView({
    required this.incident,
    required this.currentUser,
    required this.onShowCloseDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle: ${incident.description}')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna Izquierda: Información y Acciones
            Expanded(
              flex: 2,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildIncidentInfo(context, incident),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, incident, currentUser, onShowCloseDialog),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Columna Derecha: Evidencia
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Text('Evidencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: ImageGallery(imageUrls: incident.imageUrls, crossAxisCount: 2), // 2 columnas en web
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS DE UI COMPARTIDOS (EXTRAÍDOS DE TU CÓDIGO) ---

Widget _buildIncidentInfo(BuildContext context, Incident incident) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(incident.description, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      DetailInfoRow(label: 'Reportado por:', value: incident.author),
      DetailInfoRow(label: 'Fecha:', value: DateFormat('dd/MM/yyyy, hh:mm a').format(incident.reportedDate)),
      DetailInfoRow(label: 'Estado:', value: incident.status.toString().split('.').last.toUpperCase()),
      if (incident.assignedTo != null)
        DetailInfoRow(label: 'Asignada a:', value: incident.assignedTo!),
      if (incident.status == IncidentStatus.closed && incident.closingNote != null)
        DetailInfoRow(label: 'Nota de Cierre:', value: incident.closingNote!),
    ],
  );
}

// TU WIDGET DE BOTONES, AHORA ES UNA FUNCIÓN PRIVADA REUTILIZABLE
Widget _buildActionButtons(
  BuildContext context,
  Incident incident,
  User? currentUser,
  VoidCallback onShowCloseDialog,
) {
  final provider = context.watch<IncidentProvider>();
  final canAssign = incident.status == IncidentStatus.open &&
      (currentUser?.role == UserRole.resident || currentUser?.role == UserRole.superintendent);
  final canClose = incident.status == IncidentStatus.assigned && currentUser?.id == incident.assignedToId;

  if (provider.isAssigning || provider.isClosing) {
    return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
  }

  // Si no hay acciones, no mostramos nada.
  if (!canAssign && !canClose && incident.status != IncidentStatus.closed) {
    return const SizedBox.shrink();
  }
  
  if (incident.status == IncidentStatus.closed) {
     return const Center(
      child: Chip(
        avatar: Icon(Icons.check_circle, color: Colors.white),
        label: Text('Incidencia Cerrada', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        if (canAssign)
          ElevatedButton.icon(
            icon: const Icon(Icons.assignment_ind),
            label: const Text('Asignar Tarea'),
            onPressed: () {
              final mockWorker = const User(
                id: 'res-01', name: 'Arq. Residente de Obra', email: 'residente@strop.com', role: UserRole.resident,
              );
              provider.assignIncident(incidentId: incident.id, userToAssign: mockWorker);
            },
          ),
        if (canClose)
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Marcar como Resuelta'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: onShowCloseDialog, // <-- Usamos el callback
          ),
      ],
    ),
  );
}