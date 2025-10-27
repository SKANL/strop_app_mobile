import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incident_comments_provider.dart';

/// Simple screen to add a comment to an incident.
class AddCommentScreen extends StatefulWidget {
  final String incidentId;

  const AddCommentScreen({super.key, required this.incidentId});

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentCommentsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar comentario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                errorText: provider.commentError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.isAddingComment
                  ? null
                  : () async {
                      final success = await provider.addComment(
                        widget.incidentId,
                        _controller.text,
                      );
                      if (success && mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              child: provider.isAddingComment
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
