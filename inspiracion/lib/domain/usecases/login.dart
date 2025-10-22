import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(String email, String password) async {
    // Aquí irían validaciones, como el formato del email.
    if (!email.contains('@')) {
      throw ArgumentError('Formato de email inválido.');
    }
    return await repository.login(email, password);
  }
}