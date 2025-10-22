import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app_logger.dart';

/// Servicio mejorado para detectar y monitorear la conectividad de red.
/// 
/// Características:
/// - Cache del estado de conectividad
/// - Stream observable para reaccionar a cambios
/// - Evita race conditions
/// - Logs detallados
class NetworkInfo {
  final Connectivity _connectivity;
  
  // Estado actual de conectividad (cached)
  ConnectivityResult _currentStatus = ConnectivityResult.none;
  
  // Stream controller para notificar cambios
  final _connectivityController = StreamController<bool>.broadcast();
  
  // Subscription al stream de connectivity_plus
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  NetworkInfo(this._connectivity) {
    _initialize();
  }

  /// Inicializa el servicio y comienza a escuchar cambios
  void _initialize() {
    AppLogger.network('Inicializando NetworkInfo...');
    
    // Obtener estado inicial
    _connectivity.checkConnectivity().then((results) {
      // checkConnectivity ahora retorna List<ConnectivityResult>
      _currentStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
      AppLogger.network('Estado inicial de red: $_currentStatus (${isConnected ? "ONLINE" : "OFFLINE"})');
      _connectivityController.add(isConnected);
    });
    
    // Escuchar cambios de conectividad
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final newStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
        if (newStatus != _currentStatus) {
          final wasConnected = isConnected;
          _currentStatus = newStatus;
          final nowConnected = isConnected;
          
          AppLogger.network(
            'Cambio de conectividad: $_currentStatus (${nowConnected ? "ONLINE" : "OFFLINE"})'
          );
          
          // Solo notificar si el estado online/offline realmente cambió
          if (wasConnected != nowConnected) {
            _connectivityController.add(nowConnected);
          }
        }
      },
      onError: (error) {
        AppLogger.network('Error al monitorear conectividad: $error', isError: true);
      },
    );
  }

  /// Retorna true si hay algún tipo de conectividad
  bool get isConnected {
    return _currentStatus != ConnectivityResult.none;
  }

  /// Retorna el estado actual de conectividad
  ConnectivityResult get currentStatus => _currentStatus;

  /// Stream que emite true cuando hay conexión, false cuando no
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  /// Verifica el estado de conectividad de forma asíncrona
  /// Útil para obtener el estado más reciente antes de una operación importante
  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _currentStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
      AppLogger.debug('Verificación de conectividad: $_currentStatus', category: AppLogger.categoryNetwork);
      return isConnected;
    } catch (e) {
      AppLogger.network('Error al verificar conectividad: $e', isError: true);
      return false;
    }
  }

  /// Limpia recursos
  void dispose() {
    AppLogger.debug('Disposing NetworkInfo', category: AppLogger.categoryNetwork);
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }

  /// Para debugging: obtiene descripción detallada del estado
  String getStatusDescription() {
    final status = switch (_currentStatus) {
      ConnectivityResult.mobile => 'Datos móviles',
      ConnectivityResult.wifi => 'WiFi',
      ConnectivityResult.ethernet => 'Ethernet',
      ConnectivityResult.bluetooth => 'Bluetooth',
      ConnectivityResult.vpn => 'VPN',
      ConnectivityResult.other => 'Otra conexión',
      ConnectivityResult.none => 'Sin conexión',
    };
    
    return '$status (${isConnected ? "ONLINE" : "OFFLINE"})';
  }
}
