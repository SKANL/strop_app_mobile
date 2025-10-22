import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int activeProjects;
  final int openIncidents;
  final int closedIncidents;
  final int totalUsers; // Simulado por ahora

  const DashboardSummary({
    required this.activeProjects,
    required this.openIncidents,
    required this.closedIncidents,
    required this.totalUsers,
  });

  @override
  List<Object?> get props => [activeProjects, openIncidents, closedIncidents, totalUsers];
}