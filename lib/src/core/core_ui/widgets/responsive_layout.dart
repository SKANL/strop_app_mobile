// lib/src/core/core_ui/widgets/responsive_layout.dart
import 'package:flutter/material.dart';

/// Widget para layouts responsivos
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;
  
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  });
  
  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 900;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakpoint && desktopBody != null) {
          return desktopBody!;
        } else if (constraints.maxWidth >= mobileBreakpoint && tabletBody != null) {
          return tabletBody!;
        } else {
          return mobileBody;
        }
      },
    );
  }
}

/// Obtener el tipo de dispositivo actual
enum DeviceType { mobile, tablet, desktop }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= ResponsiveLayout.tabletBreakpoint) {
    return DeviceType.desktop;
  } else if (width >= ResponsiveLayout.mobileBreakpoint) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}
