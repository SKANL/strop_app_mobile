import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showLogout;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final VoidCallback? onLogout;

  const MainAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showLogout = false,
    this.actions,
    this.onBack,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final mergedActions = <Widget>[];

    // Logout opcional (usa AuthProvider por defecto)
    if (showLogout) {
      mergedActions.add(
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Cerrar Sesión',
          onPressed: onLogout ?? () => context.read<AuthProvider>().logout(),
        ),
      );
    }

    if (actions != null) mergedActions.addAll(actions!);

    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
      title: Text(title),
      actions: mergedActions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}