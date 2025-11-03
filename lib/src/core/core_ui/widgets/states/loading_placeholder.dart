// lib/src/core/core_ui/widgets/loading_placeholder.dart
import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Widget para mostrar placeholder de carga con efecto animado
/// 
/// Consolida lógica de loading manual en:
/// - home_screen.dart
/// - my_tasks_screen.dart
/// - project_bitacora_screen.dart
/// - incident_detail_screen.dart
class LoadingPlaceholder extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final bool horizontal;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const LoadingPlaceholder({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 80,
    this.horizontal = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  /// Constructor para placeholder de lista vertical
  factory LoadingPlaceholder.list({
    int itemCount = 3,
    double itemHeight = 80,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) => LoadingPlaceholder(
    itemCount: itemCount,
    itemHeight: itemHeight,
    horizontal: false,
    padding: padding,
  );

  /// Constructor para placeholder de grid
  factory LoadingPlaceholder.grid({
    int itemCount = 6,
    double itemHeight = 120,
  }) => LoadingPlaceholder(
    itemCount: itemCount,
    itemHeight: itemHeight,
    horizontal: false,
    padding: const EdgeInsets.all(8),
  );

  /// Constructor para placeholder horizontal (scroll)
  factory LoadingPlaceholder.horizontal({
    int itemCount = 5,
    double itemHeight = 100,
  }) => LoadingPlaceholder(
    itemCount: itemCount,
    itemHeight: itemHeight,
    horizontal: true,
    padding: const EdgeInsets.symmetric(horizontal: 8),
  );

  /// Constructor compacto para headers/títulos
  factory LoadingPlaceholder.compact({
    double? height = 20,
  }) => LoadingPlaceholder(
    itemCount: 1,
    itemHeight: height,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  @override
  Widget build(BuildContext context) {
    return horizontal ? _buildHorizontal() : _buildVertical();
  }

  /// Placeholder vertical (por defecto)
  Widget _buildVertical() {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildPlaceholderItem(),
    );
  }

  /// Placeholder horizontal
  Widget _buildHorizontal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: itemHeight ?? 80,
              height: itemHeight ?? 80,
              child: _buildPlaceholderItem(),
            ),
          ),
        ),
      ),
    );
  }

  /// Item placeholder individual con animación
  Widget _buildPlaceholderItem() {
    return _AnimatedPlaceholder(
      height: itemHeight,
      borderRadius: borderRadius,
      margin: horizontal ? null : const EdgeInsets.only(bottom: 8),
    );
  }
}

/// Widget que proporciona efecto de carga animado
class _AnimatedPlaceholder extends StatefulWidget {
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsets? margin;

  const _AnimatedPlaceholder({
    this.height = 80,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin,
  });

  @override
  State<_AnimatedPlaceholder> createState() => _AnimatedPlaceholderState();
}

class _AnimatedPlaceholderState extends State<_AnimatedPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.4, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          height: widget.height,
          margin: widget.margin ?? const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.withOpacity(AppColors.borderColor, _opacity.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

/// Variante para usar dentro de SliverList
class SliverLoadingPlaceholder extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const SliverLoadingPlaceholder({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _AnimatedPlaceholder(
            height: itemHeight,
            borderRadius: borderRadius,
            margin: padding,
          );
        },
        childCount: itemCount,
      ),
    );
  }
}
