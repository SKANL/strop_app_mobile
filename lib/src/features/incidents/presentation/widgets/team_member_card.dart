// lib/src/features/incidents/presentation/widgets/team_member_card.dart
import 'package:flutter/material.dart';
import '../../../../core/core_ui/widgets/avatar_with_initials.dart';

/// Widget reutilizable para mostrar un miembro del equipo
class TeamMemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onCall;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.imageUrl,
    this.onTap,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: AvatarWithInitials.forRole(
          name: name,
          role: role,
          imageUrl: imageUrl,
          radius: 24,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.email, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (phone != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(phone!),
                ],
              ),
            ],
          ],
        ),
        trailing: onCall != null
            ? IconButton(
                icon: const Icon(Icons.phone),
                color: Theme.of(context).colorScheme.primary,
                onPressed: onCall,
              )
            : null,
      ),
    );
  }
}

/// Widget para sección de roles en equipo
class RoleSection extends StatelessWidget {
  final String roleTitle;
  final Color roleColor;
  final List<Widget> members;

  const RoleSection({
    super.key,
    required this.roleTitle,
    required this.roleColor,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header del rol
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: roleColor.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.group, color: roleColor, size: 20),
              const SizedBox(width: 8),
              Text(
                roleTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                ),
              ),
            ],
          ),
        ),

        // Lista de miembros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: members,
          ),
        ),
      ],
    );
  }
}
