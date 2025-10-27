// lib/src/core/core_ui/widgets/role_badge.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge para mostrar roles de usuarios (Superintendente, Residente, Cabo, etc)
/// 
/// **Uso:**
/// ```dart
/// RoleBadge(role: 'Superintendente')
/// RoleBadge(role: 'Residente', size: RoleBadgeSize.small)
/// ```
class RoleBadge extends StatelessWidget {
  final String role;
  final RoleBadgeSize size;
  final bool showIcon;

  const RoleBadge({
    super.key,
    required this.role,
    this.size = RoleBadgeSize.medium,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getRoleColor(role);
    final iconData = _getRoleIcon(role);
    
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: AppColors.lighten(color, 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lighten(color, 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              iconData,
              size: _getIconSize(),
              color: color,
            ),
            SizedBox(width: _getSpacing()),
          ],
          Text(
            role,
            style: TextStyle(
              color: color,
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case RoleBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case RoleBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
      case RoleBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    }
  }

  double _getIconSize() {
    switch (size) {
      case RoleBadgeSize.small:
        return 12;
      case RoleBadgeSize.medium:
        return 16;
      case RoleBadgeSize.large:
        return 20;
    }
  }

  double _getFontSize() {
    switch (size) {
      case RoleBadgeSize.small:
        return 11;
      case RoleBadgeSize.medium:
        return 13;
      case RoleBadgeSize.large:
        return 15;
    }
  }

  double _getSpacing() {
    switch (size) {
      case RoleBadgeSize.small:
        return 3;
      case RoleBadgeSize.medium:
        return 4;
      case RoleBadgeSize.large:
        return 6;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'superintendente':
      case 'superintendent':
        return Icons.admin_panel_settings;
      case 'residente':
      case 'resident':
        return Icons.engineering;
      case 'cabo':
      case 'foreman':
        return Icons.supervisor_account;
      case 'trabajador':
      case 'worker':
        return Icons.construction;
      default:
        return Icons.person;
    }
  }
}

enum RoleBadgeSize { small, medium, large }
