import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import '../../../../domain/entities/project_entity.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isSelected;

  const ProjectListItem({super.key, required this.project, required this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Theme.of(context).primaryColor.withAlpha( 50) : null,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(project.name),
        subtitle: Text(project.location),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}