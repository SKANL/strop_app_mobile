// lib/src/features/auth/data/models/user_model.dart
import '../../../../core/core_domain/entities/user_entity.dart';

/// Modelo de usuario para serialización JSON
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.photoUrl,
  });
  
  /// Crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRoleX.fromJson(json['role'] as String),
      photoUrl: json['photoUrl'] as String?,
    );
  }
  
  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toJson(),
      'photoUrl': photoUrl,
    };
  }
  
  /// Convertir a entidad
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      photoUrl: photoUrl,
    );
  }
  
  /// Crear desde entidad
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      photoUrl: entity.photoUrl,
    );
  }
}
