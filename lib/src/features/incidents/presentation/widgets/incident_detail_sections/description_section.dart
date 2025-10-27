import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget de descripción para incident detail
/// 
/// Muestra la descripción de la incidencia en un Card con título
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar descripción
/// - ~40 líneas
class IncidentDescriptionSection extends StatelessWidget {
  const IncidentDescriptionSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, size: 20),
              const SizedBox(width: 8),
              Text(
                'Descripción',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
