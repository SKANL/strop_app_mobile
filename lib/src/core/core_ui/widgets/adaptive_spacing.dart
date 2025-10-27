// lib/src/core/core_ui/widgets/adaptive_spacing.dart

import 'package:flutter/material.dart';
import 'responsive_layout.dart';

/// Espaciado adaptativo según tipo de dispositivo.
/// 
/// Proporciona espaciado consistente que se escala automáticamente
/// en tablets para una mejor experiencia visual.
/// 
/// Ejemplo de uso:
/// ```dart
/// Column(
///   children: [
///     Text('Título'),
///     AdaptiveSpacing.vertical(16), // 16 en phone, 20 en tablet
///     Text('Contenido'),
///   ],
/// )
/// ```
class AdaptiveSpacing extends StatelessWidget {
  final double phoneSize;
  final double? tabletSize;
  final Axis axis;

  const AdaptiveSpacing._({
    super.key,
    required this.phoneSize,
    this.tabletSize,
    required this.axis,
  });

  /// Espaciado vertical (SizedBox con height)
  const AdaptiveSpacing.vertical(
    double phoneSize, {
    double? tabletSize,
    Key? key,
  }) : this._(
          key: key,
          phoneSize: phoneSize,
          tabletSize: tabletSize,
          axis: Axis.vertical,
        );

  /// Espaciado horizontal (SizedBox con width)
  const AdaptiveSpacing.horizontal(
    double phoneSize, {
    double? tabletSize,
    Key? key,
  }) : this._(
          key: key,
          phoneSize: phoneSize,
          tabletSize: tabletSize,
          axis: Axis.horizontal,
        );

  @override
  Widget build(BuildContext context) {
    final deviceType = getMobileDeviceType(context);
    final effectiveSize = deviceType == MobileDeviceType.tablet && tabletSize != null
        ? tabletSize!
        : phoneSize;

    return axis == Axis.vertical
        ? SizedBox(height: effectiveSize)
        : SizedBox(width: effectiveSize);
  }
}

/// Padding adaptativo según tipo de dispositivo.
/// 
/// Similar a AdaptiveSpacing pero para padding.
/// 
/// Ejemplo de uso:
/// ```dart
/// AdaptivePadding(
///   phone: EdgeInsets.all(16),
///   tablet: EdgeInsets.all(24),
///   child: MyContent(),
/// )
/// ```
class AdaptivePadding extends StatelessWidget {
  final EdgeInsetsGeometry phone;
  final EdgeInsetsGeometry? tablet;
  final Widget child;

  const AdaptivePadding({
    super.key,
    required this.phone,
    this.tablet,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = getMobileDeviceType(context);
    final effectivePadding = deviceType == MobileDeviceType.tablet && tablet != null
        ? tablet!
        : phone;

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}

/// Clase de utilidad para obtener valores adaptativos directamente.
/// 
/// Útil cuando no quieres widgets sino valores numéricos.
/// 
/// Ejemplo de uso:
/// ```dart
/// final padding = AdaptiveValue.get(
///   context,
///   phone: 16,
///   tablet: 24,
/// );
/// ```
class AdaptiveValue {
  /// Obtiene un valor según el tipo de dispositivo
  static double get(
    BuildContext context, {
    required double phone,
    double? tablet,
  }) {
    final deviceType = getMobileDeviceType(context);
    if (deviceType == MobileDeviceType.tablet && tablet != null) {
      return tablet;
    }
    return phone;
  }

  /// Obtiene EdgeInsets según el tipo de dispositivo
  static EdgeInsets padding(
    BuildContext context, {
    required EdgeInsets phone,
    EdgeInsets? tablet,
  }) {
    final deviceType = getMobileDeviceType(context);
    if (deviceType == MobileDeviceType.tablet && tablet != null) {
      return tablet;
    }
    return phone;
  }

  /// Valores de espaciado comunes y consistentes
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Tamaños de fuente adaptativos
  static double fontSize(
    BuildContext context, {
    required double phone,
    double? tablet,
  }) {
    final deviceType = getMobileDeviceType(context);
    if (deviceType == MobileDeviceType.tablet && tablet != null) {
      return tablet;
    }
    return phone;
  }
}
