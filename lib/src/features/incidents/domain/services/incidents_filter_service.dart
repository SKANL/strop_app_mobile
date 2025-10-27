import '../../../../core/core_domain/entities/incident_entity.dart';
import 'package:flutter/material.dart';

/// Servicio centralizado para filtrado y ordenamiento de incidencias
/// 
/// CREADO EN SEMANA 4:
/// - Extrae lógica de filtrado duplicada de múltiples providers
/// - Proporciona métodos puros y testeables
/// - Soporta múltiples criterios de filtrado simultáneos
/// - Centraliza lógica de ordenamiento
/// 
/// Usado por:
/// - IncidentsListProvider
/// - IncidentFormProvider
/// - DashboardProvider (futuro)
class IncidentsFilterService {
  /// Filtra incidencias según múltiples criterios
  /// 
  /// Parámetros opcionales permiten combinar filtros:
  /// - [searchQuery]: Busca en título y descripción (case-insensitive)
  /// - [type]: Filtra por tipo específico
  /// - [status]: Filtra por estado específico
  /// - [priority]: Filtra por prioridad específica
  /// - [assignedToUserId]: Filtra por usuario asignado
  /// - [createdByUserId]: Filtra por usuario creador
  /// - [projectId]: Filtra por proyecto específico
  /// 
  /// Returns: Lista filtrada de incidencias
  static List<IncidentEntity> filterIncidents(
    List<IncidentEntity> incidents, {
    String? searchQuery,
    IncidentType? type,
    IncidentStatus? status,
    IncidentPriority? priority,
    String? assignedToUserId,
    String? createdByUserId,
    String? projectId,
  }) {
    return incidents.where((incident) {
      // Filtro por búsqueda de texto
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesTitle = incident.title.toLowerCase().contains(query);
        final matchesDescription = incident.description.toLowerCase().contains(query);
        
        if (!matchesTitle && !matchesDescription) {
          return false;
        }
      }
      
      // Filtro por tipo
      if (type != null && incident.type != type) {
        return false;
      }
      
      // Filtro por estado
      if (status != null && incident.status != status) {
        return false;
      }
      
      // Filtro por prioridad
      if (priority != null && incident.priority != priority) {
        return false;
      }
      
      // Filtro por usuario asignado
      if (assignedToUserId != null && incident.assignedTo != assignedToUserId) {
        return false;
      }
      
      // Filtro por usuario creador
      if (createdByUserId != null && incident.createdBy != createdByUserId) {
        return false;
      }
      
      // Filtro por proyecto
      if (projectId != null && incident.projectId != projectId) {
        return false;
      }
      
      return true;
    }).toList();
  }
  
  /// Ordena incidencias según criterio especificado
  /// 
  /// Soporta:
  /// - [newest]: Más recientes primero (por fecha de creación)
  /// - [oldest]: Más antiguas primero (por fecha de creación)
  /// - [priority]: Por prioridad (critical > high > normal > low)
  /// - [status]: Por estado (open > inProgress > closed)
  /// - [title]: Por título (alfabético A-Z)
  /// 
  /// Returns: Lista ordenada de incidencias
  static List<IncidentEntity> sortIncidents(
    List<IncidentEntity> incidents,
    IncidentsSortBy sortBy,
  ) {
    final sorted = List<IncidentEntity>.from(incidents);
    
    switch (sortBy) {
      case IncidentsSortBy.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
        
      case IncidentsSortBy.oldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
        
      case IncidentsSortBy.priority:
        sorted.sort((a, b) {
          final priorityOrder = {
            IncidentPriority.critical: 0,
            IncidentPriority.high: 1,
            IncidentPriority.normal: 2,
            IncidentPriority.low: 3,
          };
          return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
        });
        break;
        
      case IncidentsSortBy.status:
        sorted.sort((a, b) {
          final statusOrder = {
            IncidentStatus.open: 0,
            IncidentStatus.closed: 1,
          };
          return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
        });
        break;
        
      case IncidentsSortBy.title:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    
    return sorted;
  }
  
  /// Filtra Y ordena incidencias en un solo paso
  /// 
  /// Combina [filterIncidents] y [sortIncidents] de manera eficiente.
  /// Útil cuando se necesitan ambas operaciones.
  /// 
  /// Returns: Lista filtrada y ordenada
  static List<IncidentEntity> filterAndSort(
    List<IncidentEntity> incidents, {
    String? searchQuery,
    IncidentType? type,
    IncidentStatus? status,
    IncidentPriority? priority,
    String? assignedToUserId,
    String? createdByUserId,
    String? projectId,
    IncidentsSortBy sortBy = IncidentsSortBy.newest,
  }) {
    final filtered = filterIncidents(
      incidents,
      searchQuery: searchQuery,
      type: type,
      status: status,
      priority: priority,
      assignedToUserId: assignedToUserId,
      createdByUserId: createdByUserId,
      projectId: projectId,
    );
    
    return sortIncidents(filtered, sortBy);
  }
  
  /// Cuenta incidencias por estado
  /// 
  /// Útil para dashboards y badges de contadores.
  /// 
  /// Returns: Map con contadores por cada estado
  static Map<IncidentStatus, int> countByStatus(List<IncidentEntity> incidents) {
    return {
      IncidentStatus.open: incidents.where((i) => i.status == IncidentStatus.open).length,
      IncidentStatus.closed: incidents.where((i) => i.status == IncidentStatus.closed).length,
    };
  }
  
  /// Cuenta incidencias por prioridad
  /// 
  /// Útil para dashboards y estadísticas.
  /// 
  /// Returns: Map con contadores por cada prioridad
  static Map<IncidentPriority, int> countByPriority(List<IncidentEntity> incidents) {
    return {
      IncidentPriority.critical: incidents.where((i) => i.priority == IncidentPriority.critical).length,
      IncidentPriority.high: incidents.where((i) => i.priority == IncidentPriority.high).length,
      IncidentPriority.normal: incidents.where((i) => i.priority == IncidentPriority.normal).length,
      IncidentPriority.low: incidents.where((i) => i.priority == IncidentPriority.low).length,
    };
  }
  
  /// Obtiene incidencias críticas (prioridad critical + estado open)
  /// 
  /// Útil para alertas y notificaciones urgentes.
  /// 
  /// Returns: Lista de incidencias críticas activas
  static List<IncidentEntity> getCriticalIncidents(List<IncidentEntity> incidents) {
    return incidents.where((incident) {
      return incident.priority == IncidentPriority.critical &&
          incident.status == IncidentStatus.open;
    }).toList();
  }
}

/// Enumeración de criterios de ordenamiento disponibles
enum IncidentsSortBy {
  /// Más recientes primero (por fecha de creación)
  newest,
  
  /// Más antiguas primero (por fecha de creación)
  oldest,
  
  /// Por prioridad (critical > high > normal > low)
  priority,
  
  /// Por estado (open > inProgress > closed)
  status,
  
  /// Por título alfabético (A-Z)
  title,
}

/// Extensión para obtener label legible del criterio de ordenamiento
extension IncidentsSortByX on IncidentsSortBy {
  String get label {
    switch (this) {
      case IncidentsSortBy.newest:
        return 'Más recientes';
      case IncidentsSortBy.oldest:
        return 'Más antiguas';
      case IncidentsSortBy.priority:
        return 'Por prioridad';
      case IncidentsSortBy.status:
        return 'Por estado';
      case IncidentsSortBy.title:
        return 'Por título';
    }
  }
  
  IconData get icon {
    switch (this) {
      case IncidentsSortBy.newest:
        return Icons.arrow_downward;
      case IncidentsSortBy.oldest:
        return Icons.arrow_upward;
      case IncidentsSortBy.priority:
        return Icons.priority_high;
      case IncidentsSortBy.status:
        return Icons.check_circle_outline;
      case IncidentsSortBy.title:
        return Icons.sort_by_alpha;
    }
  }
}
