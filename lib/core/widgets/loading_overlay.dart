import 'package:flutter/material.dart';
import '../../src/core/core_ui/theme/app_colors.dart';

/// Reusable loading overlay widget
/// 
/// Displays a consistent loading indicator with optional message
/// Can be used as:
/// - Modal overlay (blocks interaction)
/// - Inline loading indicator
/// 
/// Replaces 10+ duplicated loading implementations
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.isModal = true,
    this.backgroundColor,
    this.indicatorColor,
  });

  final String? message;
  final bool isModal;
  final Color? backgroundColor;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? AppColors.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isModal) {
      return Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.5),
        child: content,
      );
    }

    return content;
  }

  /// Shows a modal loading overlay
  static void show(
    BuildContext context, {
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingOverlay(
        message: message,
        isModal: true,
      ),
    );
  }

  /// Hides the modal loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
