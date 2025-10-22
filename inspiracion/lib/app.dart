import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injector.dart';
import 'core/navigation/app_router.dart';
import 'core/sync/sync_service.dart';
import 'core/utils/network_info.dart';
import 'core/utils/platform_helper.dart';
import 'features/incidents/presentation/providers/incident_provider.dart';
import 'features/projects/presentation/providers/project_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

class StropApp extends StatelessWidget {
  const StropApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Convertimos a MultiProvider para manejar múltiples providers.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProjectProvider>()),
        ChangeNotifierProvider(create: (_) => sl<IncidentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<DashboardProvider>()),
        // Providers de sincronización (SOLO para plataformas móviles)
        // Web y Desktop usan solo API remota, no necesitan SyncService
        if (PlatformHelper.isMobile) ...[
          Provider.value(value: sl<NetworkInfo>()),
          ChangeNotifierProvider.value(value: sl<SyncService>()),
        ],
      ],
      child: MaterialApp.router(
        title: 'Strop',
        theme: AppTheme.theme, // Usamos nuestro tema personalizado
        debugShowCheckedModeBanner: false, // Desactivamos el banner de depuración
        routerConfig: router,
      ),
    );
  }
}