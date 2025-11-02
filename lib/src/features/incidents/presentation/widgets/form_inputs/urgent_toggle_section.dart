import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Widget para marcar una solicitud como urgente/crítica
class UrgentToggleSection extends StatelessWidget {
  final bool isCritical;
  final ValueChanged<bool> onChanged;

  const UrgentToggleSection({
    super.key,
    required this.isCritical,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: isCritical,
      onChanged: onChanged,
      title: const Text('Marcar como Urgente'),
      subtitle: const Text('Se priorizará la revisión'),
      secondary: Icon(
        Icons.priority_high,
        color: isCritical ? AppColors.criticalStatusColor : AppColors.iconColor,
      ),
      tileColor: isCritical ? AppColors.lighten(AppColors.criticalStatusColor, 0.9) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCritical ? AppColors.criticalStatusColor : AppColors.borderColor,
        ),
      ),
    );
  }
}
