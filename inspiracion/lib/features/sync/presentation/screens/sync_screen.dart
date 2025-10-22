import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../core/utils/platform_helper.dart';

/// Pantalla que muestra los items pendientes de sincronización
/// y permite sincronizar manualmente.
class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta pantalla solo está disponible en plataformas móviles con sincronización local
    if (!PlatformHelper.isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sincronización'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Sincronización no disponible',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'La sincronización local solo está disponible en dispositivos móviles. '
                  'Web y Desktop trabajan directamente con la API.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización'),
        actions: [
          // Botón de ayuda
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: Consumer<SyncService>(
        builder: (context, syncService, child) {
          return Column(
            children: [
              // Header con información de estado
              _buildStatusHeader(context, syncService),
              
              const Divider(height: 1),
              
              // Lista de items pendientes
              Expanded(
                child: syncService.hasPendingItems
                    ? _buildPendingList(context, syncService)
                    : _buildEmptyState(context),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<SyncService>(
        builder: (context, syncService, _) {
          if (syncService.isSyncing || !syncService.hasPendingItems) {
            return const SizedBox.shrink();
          }
          
          return FloatingActionButton.extended(
            onPressed: () => _syncAll(context, syncService),
            icon: const Icon(Icons.sync),
            label: const Text('Sincronizar Todo'),
          );
        },
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, SyncService syncService) {
    final networkInfo = context.watch<NetworkInfo>();
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado de conexión
          Row(
            children: [
              Icon(
                networkInfo.isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: networkInfo.isConnected ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                networkInfo.isConnected ? 'Conectado' : 'Sin conexión',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: networkInfo.isConnected ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (syncService.lastSyncTime != null)
                Flexible(
                  child: Text(
                    'Última sincronización: ${_formatRelativeTime(syncService.lastSyncTime!)}',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Contador de items pendientes
          Row(
            children: [
              Icon(
                Icons.pending_actions,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${syncService.pendingCount} ${syncService.pendingCount == 1 ? "item pendiente" : "items pendientes"}',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          
          // Barra de progreso si está sincronizando
          if (syncService.isSyncing) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              'Sincronizando...',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          
          // Resultado de última sincronización
          if (syncService.lastSyncResult != null && !syncService.isSyncing) ...[
            const SizedBox(height: 12),
            _buildSyncResultSummary(context, syncService.lastSyncResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncResultSummary(BuildContext context, SyncResult result) {
    final theme = Theme.of(context);
    
    Color color;
    IconData icon;
    String message;
    
    if (result.isFullySuccessful) {
      color = Colors.green;
      icon = Icons.check_circle;
      message = 'Todos los items sincronizados correctamente';
    } else if (result.hasConflicts) {
      color = Colors.orange;
      icon = Icons.warning;
      message = '${result.conflictItems} conflictos detectados';
    } else {
      color = Colors.red;
      icon = Icons.error;
      message = '${result.failedItems} items fallaron';
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingList(BuildContext context, SyncService syncService) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: syncService.pendingItems.length,
      itemBuilder: (context, index) {
        final item = syncService.pendingItems[index];
        return _buildPendingItemCard(context, item, syncService);
      },
    );
  }

  Widget _buildPendingItemCard(BuildContext context, SyncItem item, SyncService syncService) {
    final theme = Theme.of(context);
    
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (item.status) {
      case SyncItemStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pendiente';
        break;
      case SyncItemStatus.syncing:
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        statusText = 'Sincronizando...';
        break;
      case SyncItemStatus.synced:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Sincronizado';
        break;
      case SyncItemStatus.conflict:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        statusText = 'Conflicto';
        break;
      case SyncItemStatus.error:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Error';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(item.type).withAlpha(51),
          child: Icon(
            _getTypeIcon(item.type),
            color: _getTypeColor(item.type),
          ),
        ),
        title: Text(
          item.displayName,
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTypeLabel(item.type),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(color: statusColor),
                ),
              ],
            ),
            if (item.errorMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                'Error: ${item.errorMessage}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        trailing: item.status == SyncItemStatus.conflict
            ? IconButton(
                icon: const Icon(Icons.compare_arrows),
                onPressed: () => _showConflictDialog(context, item, syncService),
                tooltip: 'Resolver conflicto',
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_done,
            size: 80,
            color: theme.colorScheme.primary.withAlpha(76),
          ),
          const SizedBox(height: 16),
          Text(
            '¡Todo sincronizado!',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay items pendientes de sincronización',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(76),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  Color _getTypeColor(String type) {
    switch (type) {
      case 'project':
        return Colors.blue;
      case 'incident':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'project':
        return Icons.folder;
      case 'incident':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'project':
        return 'Proyecto';
      case 'incident':
        return 'Incidencia';
      default:
        return 'Desconocido';
    }
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(time);
    }
  }

  // Actions
  Future<void> _syncAll(BuildContext context, SyncService syncService) async {
    final networkInfo = context.read<NetworkInfo>();
    
    if (!networkInfo.isConnected) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay conexión a internet'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final result = await syncService.syncAll();
    
    if (!context.mounted) return;
    
    if (result.isFullySuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${result.syncedItems} items sincronizados correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (result.hasConflicts) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠ ${result.conflictItems} conflictos detectados'),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: 'Ver',
            onPressed: () {
              // Los conflictos ya se muestran en la lista
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✗ ${result.failedItems} items fallaron'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showConflictDialog(BuildContext context, SyncItem item, SyncService syncService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolver Conflicto'),
        content: const Text(
          'Hay diferencias entre los datos locales y del servidor. '
          '¿Qué versión deseas mantener?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              syncService.resolveConflictWithLocal(item);
            },
            child: const Text('Usar datos locales'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              syncService.resolveConflictWithServer(item);
            },
            child: const Text('Usar datos del servidor'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Sincronización'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sincronización Offline/Online',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Esta pantalla te muestra los datos que se crearon o modificaron '
                'sin conexión y están esperando sincronizarse con el servidor.',
              ),
              SizedBox(height: 16),
              Text(
                '🟢 Sincronización Automática',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Cuando se detecta conexión a internet, la app intenta '
                'sincronizar automáticamente los datos pendientes.',
              ),
              SizedBox(height: 16),
              Text(
                '🔵 Sincronización Manual',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'También puedes presionar el botón "Sincronizar Todo" para '
                'forzar una sincronización inmediata.',
              ),
              SizedBox(height: 16),
              Text(
                '⚠️ Conflictos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Si los datos locales y del servidor difieren, se te pedirá '
                'que elijas qué versión mantener.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
