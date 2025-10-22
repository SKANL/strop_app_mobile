import 'package:equatable/equatable.dart';

// Definimos los roles de usuario como un enum para seguridad y claridad.
enum UserRole { admin, superintendent, resident, cabo }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Un getter de conveniencia para saber si el usuario es administrador.
  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [id, name, email, role];
}