// lib/src/core/core_domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

/// Entidad de Usuario - Core Domain
/// 
/// Esta es la entidad compartida entre features.
/// Representa un usuario en el sistema Strop.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;
  
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
  });
  
  /// Verifica si el usuario es administrador/dueño
  bool get isAdmin => role == UserRole.owner || role == UserRole.superadmin;
  
  /// Verifica si el usuario es superintendente
  bool get isSuperintendent => role == UserRole.superintendent;
  
  /// Verifica si el usuario es residente
  bool get isResident => role == UserRole.resident;
  
  /// Verifica si el usuario es cabo
  bool get isCabo => role == UserRole.cabo;
  
  /// Puede crear solicitudes de material
  bool get canRequestMaterial => isResident || isSuperintendent || isAdmin;
  
  /// Puede asignar tareas
  bool get canAssignTasks => isResident || isSuperintendent || isAdmin;
  
  @override
  List<Object?> get props => [id, name, email, role, photoUrl];
}

/// Roles de usuario en el sistema
enum UserRole {
  superadmin,     // Acceso total al sistema
  owner,          // Dueño de la constructora
  superintendent, // Superintendente de obra
  resident,       // Residente de obra
  cabo            // Cabo/Trabajador de campo
}

/// Extensión para convertir roles a/desde string
extension UserRoleX on UserRole {
  String toJson() => name;
  
  static UserRole fromJson(String json) {
    return UserRole.values.firstWhere(
      (role) => role.name == json,
      orElse: () => UserRole.cabo,
    );
  }
  
  /// Nombre legible del rol
  String get displayName {
    switch (this) {
      case UserRole.superadmin:
        return 'Super Admin';
      case UserRole.owner:
        return 'Dueño';
      case UserRole.superintendent:
        return 'Superintendente';
      case UserRole.resident:
        return 'Residente';
      case UserRole.cabo:
        return 'Cabo';
    }
  }
}
