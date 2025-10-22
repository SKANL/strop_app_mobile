// lib/src/core/core_network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';

/// Servicio para verificar el estado de la red
class NetworkInfo {
  final Connectivity connectivity;
  
  NetworkInfo(this.connectivity);
  
  /// Verifica si hay conexión a internet
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);
  }
  
  /// Stream de cambios en la conectividad
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      return results.isNotEmpty &&
          !results.contains(ConnectivityResult.none);
    });
  }
}
