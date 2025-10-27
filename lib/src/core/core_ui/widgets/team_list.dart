// lib/src/core/core_ui/widgets/team_list.dart

import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'empty_state.dart';

/// Widget para lista completa de equipo con filtrado opcional
/// 
/// **Uso:**
/// ```dart
/// TeamList(
///   members: teamMembers,
///   emptyMessage: 'No hay miembros',
/// )
/// ```
class TeamList extends StatefulWidget {
  final List<TeamMember> members;
  final String? emptyMessage;
  final bool enableSearch;
  final bool groupByRole;
  final Function(TeamMember)? onMemberTap;

  const TeamList({
    super.key,
    required this.members,
    this.emptyMessage,
    this.enableSearch = false,
    this.groupByRole = false,
    this.onMemberTap,
  });

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  String _searchQuery = '';
  
  List<TeamMember> get _filteredMembers {
    if (_searchQuery.isEmpty) return widget.members;
    
    return widget.members.where((member) {
      final query = _searchQuery.toLowerCase();
      return member.name.toLowerCase().contains(query) ||
             member.email.toLowerCase().contains(query) ||
             member.role.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.members.isEmpty) {
      return EmptyState(
        icon: Icons.group_outlined,
        title: widget.emptyMessage ?? 'No hay miembros en el equipo',
      );
    }

    return Column(
      children: [
        if (widget.enableSearch)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar miembro...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        
        Expanded(
          child: _filteredMembers.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  title: 'No se encontraron miembros',
                )
              : widget.groupByRole
                  ? _buildGroupedList()
                  : _buildSimpleList(),
        ),
      ],
    );
  }

  Widget _buildSimpleList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredMembers.length,
      itemBuilder: (context, index) {
        final member = _filteredMembers[index];
        return TeamMemberCard(
          name: member.name,
          email: member.email,
          role: member.role,
          phone: member.phone,
          imageUrl: member.imageUrl,
          onTap: widget.onMemberTap != null 
              ? () => widget.onMemberTap!(member)
              : null,
        );
      },
    );
  }

  Widget _buildGroupedList() {
    final grouped = <String, List<TeamMember>>{};
    
    for (final member in _filteredMembers) {
      grouped.putIfAbsent(member.role, () => []).add(member);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: grouped.entries.map((entry) {
        return RoleSection(
          roleTitle: _getRoleTitle(entry.key),
          roleColor: _getRoleColor(entry.key),
          members: entry.value.map((member) => TeamMemberCard(
            name: member.name,
            email: member.email,
            role: member.role,
            phone: member.phone,
            imageUrl: member.imageUrl,
            onTap: widget.onMemberTap != null 
                ? () => widget.onMemberTap!(member)
                : null,
          )).toList(),
        );
      }).toList(),
    );
  }

  String _getRoleTitle(String role) {
    switch (role.toLowerCase()) {
      case 'superintendent':
        return 'Superintendente';
      case 'resident':
        return 'Residente';
      case 'cabo':
      case 'foreman':
        return 'Cabo';
      case 'worker':
        return 'Trabajador';
      default:
        return role;
    }
  }

  Color _getRoleColor(String role) {
    // Importamos desde app_colors si es necesario
    switch (role.toLowerCase()) {
      case 'superintendent':
        return const Color(0xFF9C27B0);
      case 'resident':
        return const Color(0xFF1976D2);
      case 'cabo':
      case 'foreman':
        return const Color(0xFFFF9800);
      case 'worker':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF757575);
    }
  }
}

/// Modelo simple para miembro del equipo
class TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? imageUrl;

  const TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.imageUrl,
  });
}
