// lib/src/core/core_ui/widgets/responsive_layout.dart
import 'package:flutter/material.dart';

/// Widget para layouts responsivos SOLO MÓVIL
/// 
/// Esta app está diseñada únicamente para dispositivos móviles.
/// Soporta orientación portrait y landscape, pero NO web/desktop.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
  });
  
  /// Breakpoint para tablets (600dp es el estándar Material Design)
  static const int tabletBreakpoint = 600;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Solo distinguimos entre móvil pequeño y tablet
        if (constraints.maxWidth >= tabletBreakpoint && tabletBody != null) {
          return tabletBody!;
        } else {
          return mobileBody;
        }
      },
    );
  }
}

/// Obtener el tipo de dispositivo móvil actual
enum MobileDeviceType { phone, tablet }

MobileDeviceType getMobileDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= ResponsiveLayout.tabletBreakpoint) {
    return MobileDeviceType.tablet;
  } else {
    return MobileDeviceType.phone;
  }
}

/// Helper para saber si estamos en orientación landscape
bool isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Helper para obtener padding seguro
EdgeInsets getSafeAreaPadding(BuildContext context) {
  return MediaQuery.of(context).padding;
}

/// Helper para tamaños responsivos
class ResponsiveSize {
  static double text(BuildContext context, {
    required double phone,
    double? tablet,
  }) {
    if (getMobileDeviceType(context) == MobileDeviceType.tablet && tablet != null) {
      return tablet;
    }
    return phone;
  }

  static double spacing(BuildContext context, {
    required double phone,
    double? tablet,
  }) {
    if (getMobileDeviceType(context) == MobileDeviceType.tablet && tablet != null) {
      return tablet;
    }
    return phone;
  }
}

