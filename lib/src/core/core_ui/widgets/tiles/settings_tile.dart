import 'package:flutter/material.dart';

/// Widget reutilizable para items de configuración.
/// 
/// Proporciona variantes estandarizadas para diferentes tipos de opciones:
/// - `.navigation`: Para navegar a otra pantalla
/// - `.switch`: Para opciones booleanas con switch
/// - `.info`: Para mostrar información sin acción
/// 
/// Ejemplo de uso:
/// ```dart
/// // Item con navegación
/// SettingsTile.navigation(
///   icon: Icons.person,
///   title: 'Perfil',
///   subtitle: 'Editar información personal',
///   onTap: () => context.push('/profile'),
/// )
/// 
/// // Item con switch
/// SettingsTile.switch(
///   icon: Icons.notifications,
///   title: 'Notificaciones',
///   subtitle: 'Recibir notificaciones push',
///   value: true,
///   onChanged: (value) => updateSettings(value),
/// )
/// 
/// // Item solo informativo
/// SettingsTile.info(
///   icon: Icons.info,
///   title: 'Versión',
///   subtitle: '1.0.0',
/// )
/// ```
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  /// Constructor para item con navegación (flecha derecha).
  const SettingsTile.navigation({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.enabled = true,
  }) : trailing = const Icon(Icons.arrow_forward_ios, size: 16);

  /// Constructor para item con switch.
  factory SettingsTile.withSwitch({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return _SettingsTileSwitch(
      key: key,
      iconData: icon,
      titleText: title,
      subtitleText: subtitle,
      value: value,
      onChanged: onChanged,
      enabledSwitch: enabled,
    );
  }

  /// Constructor para item solo informativo (sin acción).
  const SettingsTile.info({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  })  : onTap = null,
        enabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      enabled: enabled,
      leading: Icon(
        icon,
        color: enabled ? colorScheme.primary : theme.disabledColor,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: enabled ? null : theme.disabledColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: enabled ? null : theme.disabledColor,
              ),
            )
          : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
    );
  }
}

/// Implementación interna para SettingsTile con switch.
class _SettingsTileSwitch extends SettingsTile {
  const _SettingsTileSwitch({
    super.key,
    required this.iconData,
    required this.titleText,
    this.subtitleText,
    required this.value,
    required this.onChanged,
    this.enabledSwitch = true,
  }) : super(
          icon: iconData,
          title: titleText,
          subtitle: subtitleText,
          enabled: enabledSwitch,
        );

  final IconData iconData;
  final String titleText;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabledSwitch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SwitchListTile(
      secondary: Icon(
        iconData,
        color: enabledSwitch ? colorScheme.primary : theme.disabledColor,
      ),
      title: Text(
        titleText,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: enabledSwitch ? null : theme.disabledColor,
        ),
      ),
      subtitle: subtitleText != null
          ? Text(
              subtitleText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: enabledSwitch ? null : theme.disabledColor,
              ),
            )
          : null,
      value: value,
      onChanged: enabledSwitch ? onChanged : null,
    );
  }
}
