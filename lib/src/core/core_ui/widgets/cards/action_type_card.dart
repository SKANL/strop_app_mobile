// lib/src/core/core_ui/widgets/action_type_card.dart

import 'package:flutter/material.dart';
import '../widgets.dart';

/// Widget reutilizable para Cards de acción/tipo con icono grande.
/// 
/// Usado típicamente en pantallas de selección (ej. tipo de reporte).
/// Muestra un icono grande, título, descripción y opcionalmente un badge de advertencia.
/// 
/// Ejemplo de uso:
/// ```dart
/// ActionTypeCard(
///   icon: Icons.report_problem,
///   iconColor: Colors.red,
///   title: 'Problema / Falla',
///   description: 'Reporta un problema en obra',
///   onTap: () => _navigateToForm('problem'),
///   showRequiresApproval: true,
/// )
/// ```
class ActionTypeCard extends StatelessWidget {
  /// Icono a mostrar
  final IconData icon;
  
  /// Color del icono y borde
  final Color iconColor;
  
  /// Color de fondo del icono (por defecto: iconColor con alpha 0.15)
  final Color? iconBackgroundColor;
  
  /// Título del card
  final String title;
  
  /// Descripción opcional
  final String? description;
  
  /// Callback al hacer tap
  final VoidCallback onTap;
  
  /// Si muestra el badge "Requiere aprobación"
  final bool showRequiresApproval;
  
  /// Texto personalizado del badge (por defecto: "Requiere aprobación")
  final String? badgeText;
  
  /// Radio del borde
  final double borderRadius;
  
  /// Tamaño del icono
  final double iconSize;

  const ActionTypeCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.iconBackgroundColor,
    this.description,
    this.showRequiresApproval = false,
    this.badgeText,
    this.borderRadius = 16,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  final effectiveIconBgColor = iconBackgroundColor ?? AppColors.withOpacity(iconColor, 0.15);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
  side: BorderSide(color: AppColors.withOpacity(iconColor, 0.3), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Icono + Badge (si aplica)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: effectiveIconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: iconSize,
                    ),
                  ),
                  
                  // Badge "Requiere aprobación"
                  if (showRequiresApproval) ...[
                    const Spacer(),
                    _buildRequiresApprovalBadge(context),
                  ],
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Título
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              
              // Descripción (opcional)
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequiresApprovalBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber[700]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.admin_panel_settings, size: 14, color: Colors.amber[900]),
          const SizedBox(width: 4),
          Text(
            badgeText ?? 'Requiere aprobación',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
        ],
      ),
    );
  }
}
