import 'package:flutter/material.dart';

import '../../../../../core/core_ui/utils/app_logger.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Reusable base for incident detail sections.
///
/// Encapsula:
/// - AppCard wrapper
/// - Header (title, leading, actions) uniforme
/// - visibility/empty handling
/// - try/catch + centralized logging
/// - optional loading and error builders
class DetailSectionBase extends StatelessWidget {
  const DetailSectionBase({
    super.key,
    required this.builder,
    this.loading = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.visible = true,
    this.margin,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.padding,
    this.headerSpacing = 12.0,
  });

  final WidgetBuilder builder;
  final bool loading;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext, Object?)? errorBuilder;
  final bool visible;
  final EdgeInsets? margin;

  // Header options
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final double headerSpacing;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    try {
      Widget content;

      if (loading) {
        content = loadingBuilder?.call(context) ?? const Center(child: CircularProgressIndicator());
      } else {
        content = builder(context);
      }

      // Build optional header
      Widget? header;
      if (titleWidget != null || title != null || leading != null || (actions != null && actions!.isNotEmpty)) {
        header = Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            if (titleWidget != null)
              Expanded(child: titleWidget!)
            else if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            const Spacer(),
            if (actions != null) ...actions!,
          ],
        );
      }

      final columnChildren = <Widget>[];
      if (header != null) {
        columnChildren.add(header);
        columnChildren.add(SizedBox(height: headerSpacing));
      }
      columnChildren.add(content);

      return AppCard(
        margin: margin,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          ),
        ),
      );
    } catch (e, st) {
      AppLogger.e('DetailSectionBase build error', e, st);
      if (errorBuilder != null) return errorBuilder!(context, e);
      return Center(child: Text('Error al renderizar sección'));
    }
  }
}
