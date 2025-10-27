import 'package:flutter/material.dart';

/// Widget para el avatar del usuario con botón de edición
class UserAvatarSection extends StatelessWidget {
  final String userName;
  final VoidCallback onEditPhoto;

  const UserAvatarSection({
    super.key,
    required this.userName,
    required this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            userName.substring(0, 2).toUpperCase(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: onEditPhoto,
            ),
          ),
        ),
      ],
    );
  }
}
