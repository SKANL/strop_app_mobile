// lib/src/core/core_ui/theme/app_colors.dart

import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Colores semánticos de la aplicación Strop
/// 
/// Esta clase centraliza todos los colores usados en la app,
/// evitando hard-coding y facilitando cambios globales de diseño.
/// 
/// Uso:
/// ```dart
/// Container(color: AppColors.progressReportColor)
/// Icon(Icons.warning, color: AppColors.criticalColor)
/// ```
class AppColors {
  AppColors._(); // Constructor privado para evitar instanciación

  // ============================================================================
  // COLORES BASE (desde AppTheme)
  // ============================================================================
  
  static const Color primary = AppTheme.primaryColor;
  static const Color accent = AppTheme.accentColor;
  static const Color background = AppTheme.backgroundColor;
  static const Color error = AppTheme.errorColor;
  static const Color success = AppTheme.successColor;
  static const Color warning = AppTheme.warningColor;

  // ============================================================================
  // COLORES DE TIPOS DE INCIDENCIA
  // ============================================================================
  
  /// Azul - Para reportes de avance/progreso
  static const Color progressReportColor = Color(0xFF2196F3); // Blue
  
  /// Naranja - Para problemas/fallas
  static const Color problemColor = Color(0xFFFF9800); // Orange
  
  /// Morado - Para consultas
  static const Color consultationColor = Color(0xFF9C27B0); // Purple
  
  /// Rojo - Para incidentes de seguridad
  static const Color safetyIncidentColor = AppTheme.errorColor; // Red
  
  /// Verde azulado - Para solicitudes de material
  static const Color materialRequestColor = Color(0xFF009688); // Teal

  // ============================================================================
  // COLORES DE ROLES DE EQUIPO
  // ============================================================================
  
  /// Morado - Superintendente (rol superior)
  static const Color superintendentColor = Color(0xFF9C27B0); // Purple
  
  /// Azul - Residente de obra
  static const Color residentColor = AppTheme.primaryColor; // Blue dark
  
  /// Naranja - Cabo de cuadrilla
  static const Color caboColor = Color(0xFFFF9800); // Orange
  
  /// Verde - Trabajador general
  static const Color workerColor = Color(0xFF4CAF50); // Green

  // ============================================================================
  // COLORES DE ESTADOS
  // ============================================================================
  
  /// Azul - Estado abierto/activo
  static const Color openStatusColor = AppTheme.primaryColor;
  
  /// Verde - Estado cerrado/completado
  static const Color closedStatusColor = AppTheme.successColor;
  
  /// Naranja - Estado pendiente/en espera
  static const Color pendingStatusColor = AppTheme.warningColor;
  
  /// Rojo - Prioridad crítica/urgente
  static const Color criticalStatusColor = AppTheme.errorColor;
  
  /// Gris - Estado inactivo/archivado
  static const Color inactiveStatusColor = Color(0xFF9E9E9E); // Grey

  // ============================================================================
  // COLORES DE APROBACIÓN
  // ============================================================================
  
  /// Naranja - Esperando aprobación
  static const Color approvalPendingColor = Color(0xFFFF9800); // Orange
  
  /// Verde - Aprobado
  static const Color approvedColor = Color(0xFF4CAF50); // Green
  
  /// Rojo - Rechazado
  static const Color rejectedColor = Color(0xFFF44336); // Red
  
  /// Azul - Asignado (en proceso)
  static const Color assignedColor = Color(0xFF2196F3); // Blue
  
  /// Gris - No aplica
  static const Color notApplicableColor = Color(0xFF9E9E9E); // Grey

  // ============================================================================
  // COLORES DE UI GENÉRICOS
  // ============================================================================
  
  /// Para íconos y texto secundario
  static const Color iconColor = Color(0xFF757575); // Grey 600
  
  /// Para borders y divisores
  static const Color borderColor = Color(0xFFE0E0E0); // Grey 300
  
  /// Para overlays y sombras
  static const Color overlayColor = Color(0x1F000000); // Black 12%
  
  /// Para backgrounds de cards
  static const Color cardBackground = Colors.white;
  
  /// Para texto disabled
  static const Color disabledColor = Color(0xFFBDBDBD); // Grey 400

  // ============================================================================
  // MÉTODOS HELPER
  // ============================================================================

  /// Obtiene el color según el tipo de incidencia
  static Color getIncidentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'avance':
      case 'progressreport':
      case 'progress_report':
        return progressReportColor;
      case 'problema':
      case 'problem':
        return problemColor;
      case 'consulta':
      case 'consultation':
        return consultationColor;
      case 'seguridad':
      case 'safetyincident':
      case 'safety_incident':
        return safetyIncidentColor;
      case 'material':
      case 'materialrequest':
      case 'material_request':
        return materialRequestColor;
      default:
        return iconColor;
    }
  }

  /// Obtiene el color según el rol del usuario
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'superintendente':
      case 'superintendent':
        return superintendentColor;
      case 'residente':
      case 'resident':
        return residentColor;
      case 'cabo':
      case 'foreman':
        return caboColor;
      case 'trabajador':
      case 'worker':
        return workerColor;
      default:
        return iconColor;
    }
  }

  /// Obtiene el color según el estado
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'abierta':
      case 'open':
      case 'activo':
      case 'active':
        return openStatusColor;
      case 'cerrada':
      case 'closed':
      case 'completado':
      case 'completed':
        return closedStatusColor;
      case 'pendiente':
      case 'pending':
        return pendingStatusColor;
      case 'crítica':
      case 'critical':
      case 'urgente':
      case 'urgent':
        return criticalStatusColor;
      case 'inactivo':
      case 'inactive':
      case 'archivado':
      case 'archived':
        return inactiveStatusColor;
      default:
        return iconColor;
    }
  }

  /// Obtiene el color según el estado de aprobación
  static Color getApprovalColor(String? approval) {
    if (approval == null) return notApplicableColor;
    
    switch (approval.toLowerCase()) {
      case 'pendiente':
      case 'pending':
        return approvalPendingColor;
      case 'aprobada':
      case 'aprobado':
      case 'approved':
        return approvedColor;
      case 'rechazada':
      case 'rechazado':
      case 'rejected':
        return rejectedColor;
      case 'asignada':
      case 'asignado':
      case 'assigned':
        return assignedColor;
      default:
        return notApplicableColor;
    }
  }

  /// Obtiene un color con opacidad reducida
  static Color withOpacity(Color color, double opacity) {
    // Use standard withOpacity to remain compatible across Flutter versions
    return color.withOpacity(opacity);
  }

  /// Obtiene un color más claro (para backgrounds)
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Obtiene un color más oscuro (para borders)
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  // ============================================================================
  // ALIASES PARA WIDGETS GENÉRICOS
  // ============================================================================
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = iconColor;
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color textDisabled = disabledColor;
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundMedium = Color(0xFFEEEEEE);
  
  // Border colors
  static const Color borderLight = borderColor;
  static const Color borderMedium = Color(0xFFBDBDBD);
  
  // Status colors with dark variants
  static const Color danger = error;
  static const Color dangerDark = Color(0xFFD32F2F);
  static const Color successDark = Color(0xFF388E3C);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
}
