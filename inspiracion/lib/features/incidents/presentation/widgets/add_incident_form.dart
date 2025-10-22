// lib/features/incidents/presentation/widgets/add_incident_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../domain/entities/incident_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/incident_provider.dart';

class AddIncidentForm extends StatefulWidget {
  final String projectId;
  const AddIncidentForm({super.key, required this.projectId});

  @override
  State<AddIncidentForm> createState() => _AddIncidentFormState();
}

class _AddIncidentFormState extends State<AddIncidentForm> {
  // --- TODA TU LÓGICA DE ESTADO Y UI ESTÁ AQUÍ ---
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pueden añadir más de 5 imágenes.')),
      );
      return;
    }
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  void _saveIncident() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.user;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se ha encontrado un usuario válido.')),
        );
        return;
      }

      final newIncident = Incident(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: widget.projectId,
        description: _descriptionController.text,
        author: currentUser.name,
        reportedDate: DateTime.now(),
        status: IncidentStatus.open,
        imageUrls: _images.map((file) => file.path).toList(),
      );

      context.read<IncidentProvider>().createIncident(newIncident).then((success) {
        if (success && mounted) {
          context.pop();
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _descriptionController,
            labelText: 'Descripción de la Incidencia',
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          const Text(
            'Evidencia Fotográfica (Máx. 5)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildImagePicker(),
          const SizedBox(height: 8),
          _buildImagePreview(),
          const SizedBox(height: 20),
          provider.isCreating
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _saveIncident,
                  child: const Text('Guardar Incidencia'),
                ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Cámara'),
        ),
        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Galería'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_images.isEmpty) {
      return const Text(
        'No se han seleccionado imágenes.',
        textAlign: TextAlign.center,
      );
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.file(
              File(_images[index].path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}