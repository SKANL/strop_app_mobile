import 'package:flutter/material.dart';
import '../../../../core/core_ui/theme/app_colors.dart';

/// Widget para mostrar un banner informativo
class ProjectInfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const ProjectInfoBanner({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lighten(color, 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lighten(color, 0.7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.darken(color, 0.2),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
