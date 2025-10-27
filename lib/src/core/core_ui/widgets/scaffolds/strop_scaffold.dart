// lib/src/core/core_ui/widgets/scaffolds/strop_scaffold.dart
import 'package:flutter/material.dart';

/// Scaffold reutilizable con AppBar estándar de la aplicación.
///
/// Este widget elimina la duplicación de ~50 líneas de código repetido
/// en más de 18 screens que tienen exactamente el mismo patrón de Scaffold.
///
/// **Beneficios**:
/// - Consistencia visual en toda la app
/// - Reduce código boilerplate
/// - Facilita cambios globales de UI
///
/// **Ejemplo de uso**:
/// ```dart
/// StropScaffold(
///   title: 'Mi Pantalla',
///   body: MiContenido(),
/// )
/// ```
///
/// **Con acciones**:
/// ```dart
/// StropScaffold(
///   title: 'Configuración',
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.save),
///       onPressed: () => _save(),
///     ),
///   ],
///   body: ConfigForm(),
/// )
/// ```
///
/// **Con FAB**:
/// ```dart
/// StropScaffold(
///   title: 'Lista',
///   floatingActionButton: FloatingActionButton(
///     onPressed: () => _add(),
///     child: const Icon(Icons.add),
///   ),
///   body: MiLista(),
/// )
/// ```
class StropScaffold extends StatelessWidget {
  /// El widget que se mostrará en el body del Scaffold
  final Widget body;

  /// Título que aparece en el AppBar
  final String title;

  /// Lista de widgets de acción en el AppBar (opcional)
  final List<Widget>? actions;

  /// Leading widget del AppBar (opcional, por defecto se muestra back button)
  final Widget? leading;

  /// Si mostrar o no el botón de back automático
  final bool automaticallyImplyLeading;

  /// FloatingActionButton (opcional)
  final Widget? floatingActionButton;

  /// Posición del FAB
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom navigation bar (opcional)
  final Widget? bottomNavigationBar;

  /// Si el body puede desplazarse detrás del AppBar
  final bool extendBodyBehindAppBar;

  /// Color de fondo del body
  final Color? backgroundColor;

  /// Si mostrar un drawer
  final Widget? drawer;

  /// Si mostrar un end drawer
  final Widget? endDrawer;

  const StropScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.drawer,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }
}
