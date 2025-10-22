// lib/src/features/auth/presentation/manager/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

/// Estados de autenticación
enum AuthStatus {
  unknown,        // Estado inicial
  authenticated,  // Usuario autenticado
  unauthenticated // Usuario no autenticado
}

/// Provider de autenticación
class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  
  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
  }) {
    _checkCurrentUser();
  }
  
  // Estado
  AuthStatus _status = AuthStatus.unknown;
  UserEntity? _user;
  String? _error;
  bool _isLoading = false;
  
  // Getters
  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  
  // Getters de conveniencia para roles
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isSuperintendent => _user?.isSuperintendent ?? false;
  bool get isResident => _user?.isResident ?? false;
  bool get isCabo => _user?.isCabo ?? false;
  bool get canRequestMaterial => _user?.canRequestMaterial ?? false;
  bool get canAssignTasks => _user?.canAssignTasks ?? false;
  
  /// Verificar si hay un usuario autenticado al iniciar
  Future<void> _checkCurrentUser() async {
    try {
      _user = await getCurrentUserUseCase.call();
      _status = _user != null 
          ? AuthStatus.authenticated 
          : AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }
  
  /// Iniciar sesión
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final params = LoginParams(email: email, password: password);
      _user = await loginUseCase.call(params);
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Cerrar sesión
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await logoutUseCase.call();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await resetPasswordUseCase.call(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
