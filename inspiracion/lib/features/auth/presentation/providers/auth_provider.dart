import 'package:flutter/foundation.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/get_current_user.dart';
import '../../../../domain/usecases/login.dart';
import '../../../../domain/usecases/logout.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final Login _login;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;

  AuthProvider(this._login, this._logout, this._getCurrentUser) {
    _checkCurrentUser(); // Comprobar el estado al iniciar
  }

  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _error;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<void> _checkCurrentUser() async {
    _user = await _getCurrentUser.call();
    _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    try {
      _user = await _login.call(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logout.call();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
