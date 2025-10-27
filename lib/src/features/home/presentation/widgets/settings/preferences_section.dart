// lib/src/features/home/presentation/widgets/settings/preferences_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra las preferencias de la app en la pantalla de configuración.
/// 
/// Incluye:
/// - Toggle de notificaciones push
/// - Toggle de modo oscuro
class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Preferencias',
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recibir notificaciones de la app'),
            value: true,
            onChanged: (value) {
              // TODO: Implementar toggle de notificaciones
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Cambiar apariencia de la app'),
            value: false,
            onChanged: (value) {
              // TODO: Implementar toggle de tema
            },
          ),
        ],
      ),
    );
  }
}
