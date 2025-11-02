// lib/src/core/core_ui/widgets/banners/critical_banner.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Banner de advertencia crítica para alertas importantes
/// 
/// **Uso:**
/// ```dart
/// CriticalBanner(message: 'Acción irreversible')
/// CriticalBanner(
///   message: 'Esta acción no se puede deshacer',
///   type: CriticalBannerType.error,
/// )
/// ```
class CriticalBanner extends StatelessWidget {
  final String message;
  final CriticalBannerType type;
  final bool showIcon;

  const CriticalBanner({
    super.key,
    required this.message,
    this.type = CriticalBannerType.warning,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final iconData = _getIcon();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lighten(color, 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(
              iconData,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.darken(color, 0.2),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case CriticalBannerType.warning:
        return AppColors.warning;
      case CriticalBannerType.error:
        return AppColors.error;
      case CriticalBannerType.info:
        return AppColors.primary;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case CriticalBannerType.warning:
        return Icons.warning_amber_rounded;
      case CriticalBannerType.error:
        return Icons.error_outline_rounded;
      case CriticalBannerType.info:
        return Icons.info_outline_rounded;
    }
  }
}

enum CriticalBannerType { warning, error, info }
