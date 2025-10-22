// lib/features/projects/presentation/screens/add_project_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../widgets/add_project_form.dart'; // <-- IMPORTAMOS EL NUEVO WIDGET

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _AddProjectMobileView(),
      desktopBody: _AddProjectWebView(),
    );
  }
}

// --- VISTA PRIVADA PARA MÓVIL ---
class _AddProjectMobileView extends StatelessWidget {
  const _AddProjectMobileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Nuevo Proyecto',
        showBack: true,
      ),
      // Usamos ListView para que sea scrollable, como en tu código original
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          AddProjectForm(), // Usamos el widget del formulario
        ],
      ),
    );
  }
}

// --- VISTA PRIVADA PARA WEB/TABLET ---
class _AddProjectWebView extends StatelessWidget {
  const _AddProjectWebView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear un Nuevo Proyecto'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Límite de ancho
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(32.0),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              // Usamos ListView para consistencia con la versión móvil
              child: ListView(
                shrinkWrap: true, // Se adapta al tamaño del contenido
                children: const [
                  AddProjectForm(), // Reutilizamos el mismo widget
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}