import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  // --- NUEVAS PROPIEDADES AÑADIDAS ---
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;

  const LottieAnimation.asset(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    // --- INICIALIZANDO LAS NUEVAS PROPIEDADES ---
    this.borderRadius = BorderRadius.zero, // Por defecto, sin bordes redondeados
    this.boxShadow, // Por defecto, sin sombra
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = source.startsWith('http');
    
    // El widget Lottie
    final lottieWidget = isNetwork
        ? Lottie.network(
            source,
            fit: fit,
            repeat: repeat,
          )
        : Lottie.asset(
            source,
            fit: fit,
            repeat: repeat,
          );

    // Envolvemos el widget Lottie con un Container y ClipRRect
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      // ClipRRect es CRUCIAL para que el redondeo se aplique visualmente a la animación
      child: ClipRRect(
        borderRadius: borderRadius,
        child: lottieWidget,
      ),
    );
  }
}