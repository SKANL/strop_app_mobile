import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_domain/entities/data_state.dart';
import '../../../../../core/core_domain/entities/incident_entity.dart';
import '../../providers/incident_detail_provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../../../../core/core_ui/utils/app_logger.dart';
import '../../widgets/sections/incident_detail_sections/header_section.dart';
import '../../widgets/sections/incident_detail_sections/description_section.dart';
import '../../widgets/sections/incident_detail_sections/photos_section.dart';
import '../../widgets/sections/incident_detail_sections/timeline_section.dart';
import '../../widgets/sections/incident_detail_sections/comments_section.dart';
import '../../widgets/sections/incident_detail_sections/actions_section.dart';

/// Screen 19: Detalle de Incidencia
/// 
/// REFACTORIZADO EN SEMANA 2:
/// - Dividido en 6 widgets de secciones independientes
/// - Reducido de 319 → ~90 líneas (-72%)
/// - Cada sección es reutilizable y testeable
/// - Eliminado código duplicado de presentación
/// 
/// OPTIMIZADO EN SEMANA 5:
/// - Reemplazado Consumer por Selector (reducción de rebuilds ~70%)
/// - Agregados const constructors donde es posible
/// 
/// Widgets de sección creados:
/// - IncidentDetailHeaderSection: tipo, título, autor, fecha, estado
/// - IncidentDescriptionSection: descripción
/// - IncidentPhotosSection: galería de fotos
/// - IncidentTimelineEventsSection: timeline de eventos
/// - IncidentCommentsListSection: lista de comentarios
/// - IncidentActionsSection: botones según rol/estado
class IncidentDetailScreen extends StatefulWidget {
  const IncidentDetailScreen({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  bool _showDeferredSections = false;
  String? _renderedIncidentId;
  @override
  void initState() {
    super.initState();
    // Cargar detalle de incidencia al montar la pantalla
    AppLogger.d('[IncidentDetailScreen] initState - incidentId: ${widget.incidentId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        AppLogger.d('[IncidentDetailScreen] Calling loadIncidentDetail');
        final provider = context.read<IncidentDetailProvider>();
        provider.loadIncidentDetail(widget.incidentId);
        AppLogger.d('[IncidentDetailScreen] loadIncidentDetail called successfully');
      } catch (e, stackTrace) {
        AppLogger.e('[IncidentDetailScreen] Error in loadIncidentDetail', e, stackTrace);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  AppLogger.d('[IncidentDetailScreen] Building widget');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Incidencia'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                // TODO: Implementar compartir
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Compartir'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Selector<IncidentDetailProvider, DataState<IncidentEntity>>(
        selector: (_, provider) {
          AppLogger.d('[IncidentDetailScreen] Selector called - state: ${provider.incidentState}');
          return provider.incidentState;
        },
        builder: (context, incidentState, _) {
          AppLogger.d('[IncidentDetailScreen] Builder called with state: $incidentState');
          try {
            return incidentState.when(
              initial: () {
                AppLogger.d('[IncidentDetailScreen] Showing initial state');
                return const Center(child: Text('Cargando...'));
              },
              loading: () {
                AppLogger.d('[IncidentDetailScreen] Showing loading state');
                return const Center(child: CircularProgressIndicator());
              },
              error: (failure) {
                AppLogger.d('[IncidentDetailScreen] Showing error state: ${failure.message}');
                return Center(
                  child: AppError(
                    message: failure.message,
                    onRetry: () => context.read<IncidentDetailProvider>().loadIncidentDetail(widget.incidentId),
                  ),
                );
              },
              success: (incident) {
                  AppLogger.d('[IncidentDetailScreen] Showing success state - incident: ${incident.title}');
                  // If we've just loaded a new incident, defer heavy sections to avoid a large first frame
                  if (_renderedIncidentId != incident.id) {
                    _renderedIncidentId = incident.id;
                    _showDeferredSections = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // small delay to allow first frame to render
                      Future.delayed(const Duration(milliseconds: 80), () {
                        if (mounted) setState(() => _showDeferredSections = true);
                      });
                    });
                  }
                  return _buildSuccessContent(incident);
                },
            );
          } catch (e, stackTrace) {
            AppLogger.e('[IncidentDetailScreen] Error in builder', e, stackTrace);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error inesperado: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSuccessContent(IncidentEntity incident) {
    try {
      AppLogger.d('[IncidentDetailScreen] Building success content');
      return SingleChildScrollView(
        child: Column(
          children: [
            // Render lightweight sections immediately
            IncidentDetailHeaderSection(incident: incident),
            IncidentDescriptionSection(description: incident.description),

            // Deferred (potentially heavier) sections: photos, timeline, comments, actions
            if (_showDeferredSections) ...[
              IncidentPhotosSection(photoUrls: incident.photoUrls),
              IncidentTimelineEventsSection(incidentId: widget.incidentId),
              IncidentCommentsListSection(incidentId: widget.incidentId),
              IncidentActionsSection(incident: incident),
            ] else ...[
              // Lightweight placeholders while heavy sections are prepared
              const SizedBox(height: 8),
              const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 16),
          ],
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.e('[IncidentDetailScreen] Error building success content', e, stackTrace);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al mostrar detalles: $e'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      );
    }
  }
}
