// lib/src/features/home/presentation/widgets/settings/about_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra información "Acerca de" en la pantalla de configuración.
/// 
/// Incluye:
/// - Versión de la app
/// - Ayuda y soporte
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Acerca de',
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versión de la App'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ayuda y Soporte'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Abrir pantalla de ayuda
            },
          ),
        ],
      ),
    );
  }
}
