import 'package:flutter/material.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget para mostrar una categoría de materiales con sus items
class ProjectMaterialCategory extends StatelessWidget {
  final String category;
  final List<Map<String, String>> items;

  const ProjectMaterialCategory({
    super.key,
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        leading: const Icon(Icons.category),
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: items.map((item) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(item['name']!),
              trailing: Text(
                '${item['quantity']} ${item['unit']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.iconColor,
                ),
              ),
            )).toList(),
      ),
    );
  }
}
