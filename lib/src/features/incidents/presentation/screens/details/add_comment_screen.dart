import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/incident_comments_provider.dart';

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
                      // Capture values derived from the BuildContext before the async gap
                      final commentsProvider =
                          Provider.of<IncidentCommentsProvider>(context, listen: false);
                      final incidentId = widget.incidentId;
                      final text = _controller.text;
                      final navigator = Navigator.of(context);

                      final success = await commentsProvider.addComment(
                        incidentId,
                        text,
                      );

                      // Ensure the State is still mounted before using `context`-dependent objects
                      if (!mounted) return;
                      if (success) {
                        navigator.pop(true);
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
