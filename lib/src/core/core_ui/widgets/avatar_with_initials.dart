// lib/src/core/core_ui/widgets/avatar_with_initials.dart
import 'package:flutter/material.dart';

/// Widget reutilizable para avatares con iniciales
/// Usado en: Listas de usuarios, equipos, asignaciones
class AvatarWithInitials extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;
  final Color? borderColor;

  const AvatarWithInitials({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
    this.borderColor,
  });

  /// Constructor para rol específico (aplica color según rol)
  factory AvatarWithInitials.forRole({
    required String name,
    required String role,
    String? imageUrl,
    double radius = 20,
    bool showBorder = false,
  }) {
    final roleLower = role.toLowerCase();
    Color backgroundColor;

    if (roleLower.contains('superintendente')) {
      backgroundColor = Colors.purple;
    } else if (roleLower.contains('residente')) {
      backgroundColor = Colors.blue;
    } else if (roleLower.contains('cabo')) {
      backgroundColor = Colors.green;
    } else {
      backgroundColor = Colors.grey;
    }

    return AvatarWithInitials(
      name: name,
      imageUrl: imageUrl,
      radius: radius,
      backgroundColor: backgroundColor,
      showBorder: showBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final effectiveBackgroundColor = backgroundColor ?? 
      Theme.of(context).colorScheme.primary;
    final effectiveTextColor = textColor ?? Colors.white;

    Widget avatar;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Avatar con imagen
      avatar = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: effectiveBackgroundColor,
        onBackgroundImageError: (_, __) {
          // Fallback a iniciales si la imagen falla
        },
      );
    } else {
      // Avatar con iniciales
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: effectiveBackgroundColor,
        child: Text(
          initials,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: radius * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (showBorder) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? Colors.white,
            width: 2,
          ),
        ),
        child: avatar,
      );
    }

    return avatar;
  }

  /// Extrae las iniciales del nombre (máximo 2 letras)
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

/// Widget para grupo de avatares superpuestos
class AvatarGroup extends StatelessWidget {
  final List<String> names;
  final List<String>? imageUrls;
  final double radius;
  final int maxVisible;
  final double overlap;

  const AvatarGroup({
    super.key,
    required this.names,
    this.imageUrls,
    this.radius = 20,
    this.maxVisible = 3,
    this.overlap = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = names.length > maxVisible ? maxVisible : names.length;
    final remaining = names.length - maxVisible;

    return SizedBox(
      width: (radius * 2 * overlap) * visibleCount + radius * 2,
      height: radius * 2,
      child: Stack(
        children: [
          // Avatares visibles
          for (var i = 0; i < visibleCount; i++)
            Positioned(
              left: (radius * 2 * overlap) * i,
              child: AvatarWithInitials(
                name: names[i],
                imageUrl: imageUrls != null && i < imageUrls!.length 
                  ? imageUrls![i] 
                  : null,
                radius: radius,
                showBorder: true,
              ),
            ),

          // Badge con cantidad restante
          if (remaining > 0)
            Positioned(
              left: (radius * 2 * overlap) * visibleCount,
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Colors.grey[300],
                child: Text(
                  '+$remaining',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: radius * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
