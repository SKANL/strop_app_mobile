# 🎨 Cookbook: Ejemplos Prácticos de Widgets Reutilizables

## 📚 Guía Rápida de Uso

Esta guía muestra ejemplos prácticos y copiar-pegar de cómo usar los widgets reutilizables en diferentes escenarios.

---

## 🎯 Escenario 1: Pantalla de Detalles de Incidencia

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';
import '../widgets/incident_header.dart';
import '../widgets/timeline_event.dart';

class IncidentDetailScreen extends StatelessWidget {
  final String incidentId;

  const IncidentDetailScreen({required this.incidentId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Incidencia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header con información inalterable
            IncidentHeader(
              type: 'Avance',
              title: 'Avance de Obra - Piso 3',
              description: 'Se completó el 80% del piso 3 según cronograma',
              authorName: 'Juan Pérez',
              reportedDate: DateTime.now(),
              location: 'Torre A, Piso 3',
              isCritical: false,
            ),

            const SizedBox(height: 24),

            // 2. Estado visual
            StatusBadge.incidentStatus('En Progreso', isCritical: false),

            const SizedBox(height: 24),

            // 3. Sección de evidencia
            SectionCard(
              title: 'Evidencia Fotográfica',
              icon: Icons.photo_camera,
              child: Column(
                children: [
                  // Aquí van las fotos
                  Image.network('https://...'),
                ],
              ),
            ),

            // 4. Timeline de actividad
            SectionCard(
              title: 'Historial de Actividad',
              icon: Icons.history,
              child: Timeline(
                events: [
                  TimelineEvent.assignment(
                    assignedBy: 'Residente García',
                    assignedTo: 'Cabo Pérez',
                    timestamp: DateTime.now().subtract(const Duration(days: 2)),
                  ),
                  TimelineEvent.comment(
                    author: 'Cabo Pérez',
                    comment: 'Iniciando trabajos en zona norte',
                    timestamp: DateTime.now().subtract(const Duration(days: 1)),
                  ),
                  TimelineEvent.comment(
                    author: 'Residente García',
                    comment: 'Excelente progreso',
                    timestamp: DateTime.now(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🏢 Escenario 2: Pantalla de Equipo del Proyecto

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';
import '../widgets/team_member_card.dart';

class ProjectTeamScreen extends StatelessWidget {
  const ProjectTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipo del Proyecto')),
      body: ListView(
        children: [
          // 1. Superintendentes
          RoleSection(
            roleTitle: 'Superintendentes',
            roleColor: Colors.purple,
            members: [
              TeamMemberCard(
                name: 'Ing. Carlos Superintendente',
                email: 'super@strop.com',
                role: 'Superintendente',
                phone: '+52 123 456 7890',
                onCall: () => _makeCall('+52 123 456 7890'),
              ),
            ],
          ),

          // 2. Residentes
          RoleSection(
            roleTitle: 'Residentes',
            roleColor: Colors.blue,
            members: [
              TeamMemberCard(
                name: 'Ing. Ana Residente',
                email: 'residente1@strop.com',
                role: 'Residente',
                onCall: () => _makeCall('+52 111 222 3333'),
              ),
              TeamMemberCard(
                name: 'Ing. Luis Residente',
                email: 'residente2@strop.com',
                role: 'Residente',
              ),
            ],
          ),

          // 3. Cabos
          RoleSection(
            roleTitle: 'Cabos de Obra',
            roleColor: Colors.green,
            members: [
              TeamMemberCard(
                name: 'Pedro Cabo',
                email: 'cabo1@strop.com',
                role: 'Cabo',
              ),
              TeamMemberCard(
                name: 'María Cabo',
                email: 'cabo2@strop.com',
                role: 'Cabo',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _makeCall(String phone) {
    // Implementar llamada
  }
}
```

---

## 📋 Escenario 3: Pantalla de Lista con Estados

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/core_ui/widgets/widgets.dart';
import '../widgets/incident_list_item.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tareas')),
      body: Consumer<TasksProvider>(
        builder: (context, provider, _) {
          // Estado 1: Loading
          if (provider.isLoading) {
            return const AppLoading(
              message: 'Cargando tareas...',
            );
          }

          // Estado 2: Error
          if (provider.error != null) {
            return AppError(
              message: provider.error!,
              onRetry: () => provider.loadTasks(),
            );
          }

          final tasks = provider.tasks;

          // Estado 3: Empty
          if (tasks.isEmpty) {
            return EmptyState.noTasks();
          }

          // Estado 4: Data
          return RefreshIndicator(
            onRefresh: () => provider.loadTasks(),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return IncidentListItem(
                  title: task.title,
                  type: task.type,
                  author: task.authorName,
                  assignedTo: task.assignedToName,
                  reportedDate: task.reportedDate,
                  status: task.status,
                  isCritical: task.isCritical,
                  onTap: () => context.push('/incident/${task.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

---

## 👤 Escenario 4: Pantalla de Perfil de Usuario

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/core_ui/widgets/widgets.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar grande
            Center(
              child: Stack(
                children: [
                  AvatarWithInitials.forRole(
                    name: user?.name ?? 'Usuario',
                    role: user?.role ?? 'Cabo',
                    radius: 60,
                    showBorder: true,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        color: Colors.white,
                        onPressed: () => _changePhoto(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Información personal
            SectionCard(
              title: 'Información Personal',
              icon: Icons.person,
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.badge,
                    label: 'Nombre',
                    value: user?.name ?? 'No disponible',
                    isValueBold: true,
                  ),
                  const Divider(),
                  InfoRow(
                    icon: Icons.email,
                    label: 'Correo Electrónico',
                    value: user?.email ?? 'No disponible',
                  ),
                  const Divider(),
                  InfoRow(
                    icon: Icons.work,
                    label: 'Rol',
                    value: user?.role ?? 'No disponible',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Acciones
            SectionCardList(
              title: 'Acciones',
              icon: Icons.settings,
              items: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Cambiar Contraseña'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/change-password'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changePhoto() {
    // Implementar cambio de foto
  }

  void _logout(BuildContext context) {
    // Implementar logout
  }
}
```

---

## 📱 Escenario 5: Pantalla Responsive (Phone vs Tablet)

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';

class ProjectBitacoraScreen extends StatelessWidget {
  const ProjectBitacoraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora del Proyecto')),
      body: ResponsiveLayout(
        // Layout para teléfonos (portrait)
        mobileBody: _buildMobileLayout(),

        // Layout para tablets (landscape o pantallas grandes)
        tabletBody: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Filtros en la parte superior
        _buildFiltersRow(),
        const Divider(height: 1),
        // Lista de incidencias
        Expanded(child: _buildIncidentsList()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Panel lateral con filtros
        SizedBox(
          width: 300,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: _buildFiltersPanel(),
          ),
        ),
        // Lista de incidencias (más ancha)
        Expanded(child: _buildIncidentsList()),
      ],
    );
  }

  Widget _buildFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          FilterChip(label: const Text('Todos'), onSelected: (_) {}),
          const SizedBox(width: 8),
          FilterChip(label: const Text('Avance'), onSelected: (_) {}),
          const SizedBox(width: 8),
          FilterChip(label: const Text('Problema'), onSelected: (_) {}),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Filtros', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )),
        const SizedBox(height: 16),
        // Filtros verticales
        CheckboxListTile(
          title: const Text('Avance'),
          value: true,
          onChanged: (_) {},
        ),
        CheckboxListTile(
          title: const Text('Problema'),
          value: false,
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _buildIncidentsList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return IncidentListItem(
          title: 'Incidencia $index',
          type: 'Avance',
          reportedDate: DateTime.now(),
          status: 'Abierta',
          onTap: () {},
        );
      },
    );
  }
}
```

---

## 🎨 Escenario 6: Badges y Estados Visuales

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';

class IncidentCardExample extends StatelessWidget {
  const IncidentCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con badges
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Reparar fuga en tubería',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // Badge de tipo
                StatusBadge.incidentType('Problema'),
              ],
            ),

            const SizedBox(height: 12),

            // Badges de estado
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Estado de la incidencia
                StatusBadge.incidentStatus('Abierta', isCritical: true),
                
                // Estado de aprobación (si aplica)
                StatusBadge.approvalStatus('Pendiente'),
              ],
            ),

            const SizedBox(height: 12),

            // Información compacta
            Column(
              children: [
                InfoRowCompact(
                  icon: Icons.person,
                  text: 'Reportado por: Juan Pérez',
                ),
                const SizedBox(height: 4),
                InfoRowCompact(
                  icon: Icons.assignment_ind,
                  text: 'Asignado a: Pedro López',
                ),
                const SizedBox(height: 4),
                InfoRowCompact(
                  icon: Icons.calendar_today,
                  text: '15/10/2025 14:30',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔍 Escenario 7: Búsqueda con Estados

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';

class SearchIncidentsScreen extends StatefulWidget {
  const SearchIncidentsScreen({super.key});

  @override
  State<SearchIncidentsScreen> createState() => _SearchIncidentsScreenState();
}

class _SearchIncidentsScreenState extends State<SearchIncidentsScreen> {
  final _searchController = TextEditingController();
  List<Incident> _results = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar incidencias...',
            border: InputBorder.none,
          ),
          onChanged: (query) => _search(query),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Estado: Buscando
    if (_isSearching) {
      return const AppLoading(message: 'Buscando...');
    }

    // Estado: Sin búsqueda aún
    if (_searchController.text.isEmpty) {
      return EmptyState(
        icon: Icons.search,
        title: 'Busca incidencias',
        message: 'Escribe en el campo superior para buscar',
      );
    }

    // Estado: Sin resultados
    if (_results.isEmpty) {
      return EmptyState.noResults(
        query: _searchController.text,
      );
    }

    // Estado: Resultados
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return IncidentListItem(
          title: _results[index].title,
          type: _results[index].type,
          reportedDate: _results[index].reportedDate,
          status: _results[index].status,
          onTap: () {},
        );
      },
    );
  }

  void _search(String query) {
    setState(() => _isSearching = true);
    
    // Simular búsqueda
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = false;
        _results = []; // Resultados de la búsqueda
      });
    });
  }
}
```

---

## 👥 Escenario 8: Avatares en Grupo

```dart
import 'package:flutter/material.dart';
import '../../../core/core_ui/widgets/widgets.dart';

class ProjectHeaderExample extends StatelessWidget {
  const ProjectHeaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Torre Reforma Centro',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Construcción de torre residencial de 15 pisos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Mostrar equipo con avatares
            Row(
              children: [
                Text(
                  'Equipo:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                AvatarGroup(
                  names: [
                    'Carlos Super',
                    'Ana Residente',
                    'Luis Residente',
                    'Pedro Cabo',
                    'María Cabo',
                    'José Cabo',
                  ],
                  maxVisible: 4, // Muestra 4 + "+2"
                  radius: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 Tips de Performance

### 1. Usar Const Constructors
```dart
// ❌ MAL (reconstruye en cada build)
StatusBadge.incidentStatus(status)

// ✅ BIEN (si los datos no cambian)
const StatusBadge(
  label: 'Abierta',
  backgroundColor: Colors.blue,
  icon: Icons.circle,
)
```

### 2. Cachear Widgets Complejos
```dart
class MyScreen extends StatelessWidget {
  // ✅ BIEN: Widget estático se cachea
  static const _emptyState = EmptyState.noTasks();

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty ? _emptyState : ListView(...);
  }
}
```

### 3. Evitar Reconstrucciones Innecesarias
```dart
// ❌ MAL: Todo el Consumer se reconstruye
Consumer<Provider>(
  builder: (context, provider, _) {
    return Column(
      children: [
        Header(), // Se reconstruye sin necesidad
        StatusBadge.incidentStatus(provider.status), // Solo esto cambia
      ],
    );
  },
)

// ✅ BIEN: Solo StatusBadge se reconstruye
Column(
  children: [
    const Header(), // const = no se reconstruye
    Consumer<Provider>(
      builder: (context, provider, _) {
        return StatusBadge.incidentStatus(provider.status);
      },
    ),
  ],
)
```

---

## 🎯 Patterns Recomendados

### Pattern 1: Detalles con Secciones
```dart
SingleChildScrollView(
  child: Column(
    children: [
      HeaderWidget(),
      SizedBox(height: 24),
      SectionCard(title: 'Sección 1', child: ...),
      SectionCard(title: 'Sección 2', child: ...),
      SectionCard(title: 'Sección 3', child: ...),
    ],
  ),
)
```

### Pattern 2: Lista con Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () => provider.reload(),
  child: ListView.builder(
    itemBuilder: (context, index) => ListItem(...),
  ),
)
```

### Pattern 3: Estados de Carga
```dart
if (isLoading) return AppLoading();
if (hasError) return AppError(onRetry: ...);
if (isEmpty) return EmptyState.noData();
return DataView();
```

---

**Última actualización**: Octubre 2025  
**Widgets Documentados**: 13  
**Ejemplos de Código**: 8 escenarios completos
