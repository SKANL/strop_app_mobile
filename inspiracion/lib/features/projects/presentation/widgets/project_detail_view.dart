// lib/features/projects/presentation/widgets/project_detail_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/project_entity.dart';
import '../../../../core/widgets/detail_info_row.dart';

class ProjectDetailView extends StatelessWidget {
  final Project project;
  const ProjectDetailView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailInfoRow(label: 'Ubicación', value: project.location),
            ElevatedButton(
              onPressed: () => context.push('/project/${project.id}', extra: project.name),
              child: const Text('Ver Incidencias'),
            )
          ],
        ),
      ),
    );
  }
}