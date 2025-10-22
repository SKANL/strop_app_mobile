import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerFormField extends StatelessWidget {
  final String labelText;
  final DateTime? initialValue;
  final void Function(DateTime?) onSaved;

  const CustomDatePickerFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: (date) {
        if (date == null) {
          return 'Por favor, seleccione una fecha';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  state.didChange(picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  errorText: state.errorText,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.value == null
                          ? 'No seleccionada'
                          : DateFormat('dd/MM/yyyy').format(state.value!),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}