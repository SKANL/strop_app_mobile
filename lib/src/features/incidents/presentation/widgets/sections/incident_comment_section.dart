// lib/src/features/incidents/presentation/widgets/sections/incident_comment_section.dart
import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

/// Widget that displays the comment input section for incidents
class IncidentCommentSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const IncidentCommentSection({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agregar comentario',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Escribe tu comentario aquí...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
          ),
          maxLines: 3,
          enabled: !isSubmitting,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : onSubmit,
            icon: isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(isSubmitting ? 'Enviando...' : 'Enviar Comentario'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
