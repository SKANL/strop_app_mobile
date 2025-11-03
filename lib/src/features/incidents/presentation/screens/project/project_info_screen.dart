// lib/src/features/incidents/presentation/screens/project/project_info_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/form_inputs/project_material_category.dart';

/// Screen 15: Información del Proyecto - Programa y explosión de insumos (solo lectura)
class ProjectInfoScreen extends StatefulWidget {
  final String projectId;

  const ProjectInfoScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Proyecto'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.timeline),
              text: 'Programa',
            ),
            Tab(
              icon: Icon(Icons.inventory),
              text: 'Insumos',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProgramTab(),
          _buildMaterialsTab(),
        ],
      ),
    );
  }

  Widget _buildProgramTab() {
    // TODO: Implementar visor de Ruta Crítica (PDF o lista)
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Banner informativo
        InfoBanner(
          message: 'Este es el programa original del proyecto. Es de solo lectura.',
          icon: Icons.info_outline,
          type: InfoBannerType.info,
        ),

        const SizedBox(height: 24),

        // Lista de actividades del programa (ejemplo)
        // OPTIMIZADO: Usa composición de widgets core en lugar de ProjectActivityCard
        _buildActivityCard(
          context,
          title: 'Cimentación',
          startDate: '01/01/2024',
          endDate: '15/01/2024',
          progress: 100,
          status: 'Completado',
        ),
        
        _buildActivityCard(
          context,
          title: 'Estructura - Planta 1',
          startDate: '16/01/2024',
          endDate: '30/01/2024',
          progress: 75,
          status: 'En Progreso',
        ),
        
        _buildActivityCard(
          context,
          title: 'Estructura - Planta 2',
          startDate: '31/01/2024',
          endDate: '15/02/2024',
          progress: 30,
          status: 'En Progreso',
        ),
        
        _buildActivityCard(
          context,
          title: 'Instalaciones',
          startDate: '16/02/2024',
          endDate: '28/02/2024',
          progress: 0,
          status: 'Pendiente',
        ),
      ],
    );
  }

  Widget _buildMaterialsTab() {
    // TODO: Implementar visor de Explosión de Insumos
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Banner informativo
        InfoBanner(
          message: 'Presupuesto de insumos del proyecto. Solo lectura.',
          icon: Icons.lock_outline,
          type: InfoBannerType.warning,
        ),

        const SizedBox(height: 24),

        // Lista de categorías de materiales (ejemplo)
        ProjectMaterialCategory(
          category: 'Cemento y Agregados',
          items: const [
            {'name': 'Cemento Portland', 'quantity': '500', 'unit': 'bultos'},
            {'name': 'Arena', 'quantity': '50', 'unit': 'm³'},
            {'name': 'Grava', 'quantity': '75', 'unit': 'm³'},
          ],
        ),
        
        const SizedBox(height: 16),
        
        ProjectMaterialCategory(
          category: 'Acero',
          items: const [
            {'name': 'Varilla 3/8"', 'quantity': '2000', 'unit': 'kg'},
            {'name': 'Varilla 1/2"', 'quantity': '3000', 'unit': 'kg'},
            {'name': 'Malla electrosoldada', 'quantity': '500', 'unit': 'm²'},
          ],
        ),
        
        const SizedBox(height: 16),
        
        ProjectMaterialCategory(
          category: 'Instalaciones',
          items: const [
            {'name': 'Tubería PVC 4"', 'quantity': '200', 'unit': 'mts'},
            {'name': 'Cable calibre 12', 'quantity': '500', 'unit': 'mts'},
            {'name': 'Cajas de registro', 'quantity': '20', 'unit': 'pzas'},
          ],
        ),
      ],
    );
  }

  /// Widget helper para construir cards de actividad usando composición
  /// Reemplaza el widget ProjectActivityCard eliminado
  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String startDate,
    required String endDate,
    required int progress,
    required String status,
  }) {
    Color statusColor;
    switch (status) {
      case 'Completado':
        statusColor = AppColors.closedStatusColor;
        break;
      case 'En Progreso':
        statusColor = AppColors.openStatusColor;
        break;
      default:
        statusColor = AppColors.inactiveStatusColor;
    }

    return AppCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y estado
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Chip(
                label: Text(
                  status,
                  style: TextStyle(fontSize: 11, color: statusColor),
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: statusColor),
                backgroundColor: AppColors.withOpacity(statusColor, 0.1),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Fechas
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                '$startDate - $endDate',
                style: TextStyle(fontSize: 12, color: AppColors.iconColor),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Barra de progreso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso',
                    style: TextStyle(fontSize: 12, color: AppColors.iconColor),
                  ),
                  Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: AppColors.lighten(statusColor, 0.8),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
