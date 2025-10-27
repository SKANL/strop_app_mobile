import 'package:flutter/material.dart';
import '../../src/core/core_ui/theme/app_colors.dart';

/// Generic status badge widget for displaying states
/// 
/// Provides consistent badge styling across features with:
/// - Label text
/// - Background color
/// - Optional icon
/// - Customizable styling
/// 
/// Replaces multiple feature-specific status badges
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderRadius = 8,
    this.padding,
  });

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Creates a status badge for "Pending" state
  factory StatusBadge.pending(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.warning.withOpacity(0.15),
      textColor: AppColors.warningDark,
      icon: Icons.schedule,
    );
  }

  /// Creates a status badge for "In Progress" state
  factory StatusBadge.inProgress(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.info.withOpacity(0.15),
      textColor: AppColors.infoDark,
      icon: Icons.autorenew,
    );
  }

  /// Creates a status badge for "Completed" state
  factory StatusBadge.completed(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.success.withOpacity(0.15),
      textColor: AppColors.successDark,
      icon: Icons.check_circle,
    );
  }

  /// Creates a status badge for "Rejected/Failed" state
  factory StatusBadge.rejected(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.danger.withOpacity(0.15),
      textColor: AppColors.dangerDark,
      icon: Icons.cancel,
    );
  }

  /// Creates a status badge for "Approved" state
  factory StatusBadge.approved(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.success.withOpacity(0.15),
      textColor: AppColors.successDark,
      icon: Icons.verified,
    );
  }

  /// Creates a neutral status badge
  factory StatusBadge.neutral(String label) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.backgroundMedium,
      textColor: AppColors.textSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: textColor ?? AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
