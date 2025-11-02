// lib/src/features/home/presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/sections/user_info_section.dart';
import '../../widgets/sections/sync_status_section.dart';
import '../../widgets/sections/preferences_section.dart';
import '../../widgets/sections/about_section.dart';
import '../../widgets/sections/logout_button.dart';

/// Pantalla de configuración de la aplicación.
/// 
/// Refactorizada para usar widgets modulares independientes:
/// - [UserInfoSection]: Información del usuario y perfil
/// - [SyncStatusSection]: Estado de sincronización
/// - [PreferencesSection]: Preferencias de la app
/// - [AboutSection]: Información de la app
/// - [LogoutButton]: Botón para cerrar sesión
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: const [
          UserInfoSection(),
          Divider(height: 32),
          SyncStatusSection(),
          Divider(height: 32),
          PreferencesSection(),
          Divider(height: 32),
          AboutSection(),
          Divider(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LogoutButton(),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
