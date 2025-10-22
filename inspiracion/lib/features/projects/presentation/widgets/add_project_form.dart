// lib/features/projects/presentation/widgets/add_project_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_date_picker_form_field.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../domain/entities/project_entity.dart';
import '../providers/project_provider.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({super.key});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  // TU LÓGICA DE ESTADO (COPIADA DIRECTAMENTE)
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // TU LÓGICA PARA GUARDAR (COPIADA DIRECTAMENTE)
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Llama a los 'onSaved'

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La fecha de fin no puede ser anterior a la de inicio.'),
          ),
        );
        return;
      }

      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        location: _locationController.text,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      context.read<ProjectProvider>().createProject(newProject).then((success) {
        if (success && mounted) {
          // Cambiamos context.pop() por una navegación más explícita
          // para asegurar que siempre volvemos a la lista, sin importar
          // cómo se haya presentado esta pantalla (diálogo, push, etc.)
          context.go('/projects');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProjectProvider>().isCreating;

    // TU UI DEL FORMULARIO (COPIADA DIRECTAMENTE)
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _nameController,
            labelText: 'Nombre del Proyecto',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _locationController,
            labelText: 'Ubicación',
          ),
          const SizedBox(height: 16),
          CustomDatePickerFormField(
            labelText: 'Fecha de Inicio',
            onSaved: (date) => _startDate = date,
          ),
          const SizedBox(height: 16),
          CustomDatePickerFormField(
            labelText: 'Fecha de Fin',
            onSaved: (date) => _endDate = date,
          ),
          const SizedBox(height: 30),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Guardar Proyecto'),
                ),
        ],
      ),
    );
  }
}