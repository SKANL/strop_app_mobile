import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget reutilizable para seleccionar fecha/hora con picker integrado.
/// 
/// Proporciona variantes para date, time y datetime con formato automático.
/// Incluye validación y estilo consistente con FormFieldWithLabel.
/// 
/// Ejemplo de uso:
/// ```dart
/// // Solo fecha
/// DateTimePickerField.date(
///   label: 'Fecha del incidente',
///   value: _selectedDate,
///   onChanged: (date) => setState(() => _selectedDate = date),
///   isRequired: true,
/// )
/// 
/// // Solo hora
/// DateTimePickerField.time(
///   label: 'Hora',
///   value: _selectedTime,
///   onChanged: (time) => setState(() => _selectedTime = time),
/// )
/// 
/// // Fecha y hora
/// DateTimePickerField(
///   label: 'Fecha y hora',
///   value: _selectedDateTime,
///   onChanged: (dateTime) => setState(() => _selectedDateTime = dateTime),
/// )
/// ```
class DateTimePickerField extends StatelessWidget {
  const DateTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.mode = DateTimePickerMode.dateTime,
    this.validator,
    this.helpText,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool isRequired;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTimePickerMode mode;
  final String? Function(DateTime?)? validator;
  final String? helpText;

  /// Constructor para solo seleccionar fecha.
  const DateTimePickerField.date({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.helpText,
  }) : mode = DateTimePickerMode.date;

  /// Constructor para solo seleccionar hora.
  const DateTimePickerField.time({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.enabled = true,
    this.validator,
    this.helpText,
  })  : mode = DateTimePickerMode.time,
        firstDate = null,
        lastDate = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con indicador de requerido
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Campo clickable
        InkWell(
          onTap: enabled ? () => _showPicker(context) : null,
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabled: enabled,
              suffixIcon: Icon(_getIcon()),
              errorText: validator != null ? validator!(value) : null,
            ),
            child: Text(
              _getFormattedValue(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: value == null
                        ? Theme.of(context).hintColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
          ),
        ),

        // Texto de ayuda
        if (helpText != null) ...[
          const SizedBox(height: 4),
          Text(
            helpText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ],
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    switch (mode) {
      case DateTimePickerMode.date:
        await _showDatePicker(context);
        break;
      case DateTimePickerMode.time:
        await _showTimePicker(context);
        break;
      case DateTimePickerMode.dateTime:
        await _showDateTimePicker(context);
        break;
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      // Mantener la hora si ya existía
      if (value != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          value!.hour,
          value!.minute,
        );
        onChanged(newDateTime);
      } else {
        onChanged(pickedDate);
      }
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: value != null
          ? TimeOfDay(hour: value!.hour, minute: value!.minute)
          : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final newDateTime = DateTime(
        value?.year ?? now.year,
        value?.month ?? now.month,
        value?.day ?? now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      onChanged(newDateTime);
    }
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    // Primero seleccionar fecha
    await _showDatePicker(context);

    // Si se seleccionó fecha, mostrar selector de hora
    if (value != null && context.mounted) {
      await _showTimePicker(context);
    }
  }

  String _getFormattedValue() {
    if (value == null) {
      return _getPlaceholder();
    }

    switch (mode) {
      case DateTimePickerMode.date:
        return DateFormat('dd/MM/yyyy').format(value!);
      case DateTimePickerMode.time:
        return DateFormat('HH:mm').format(value!);
      case DateTimePickerMode.dateTime:
        return DateFormat('dd/MM/yyyy HH:mm').format(value!);
    }
  }

  String _getPlaceholder() {
    switch (mode) {
      case DateTimePickerMode.date:
        return 'Seleccionar fecha';
      case DateTimePickerMode.time:
        return 'Seleccionar hora';
      case DateTimePickerMode.dateTime:
        return 'Seleccionar fecha y hora';
    }
  }

  IconData _getIcon() {
    switch (mode) {
      case DateTimePickerMode.date:
      case DateTimePickerMode.dateTime:
        return Icons.calendar_today;
      case DateTimePickerMode.time:
        return Icons.access_time;
    }
  }
}

enum DateTimePickerMode {
  date,
  time,
  dateTime,
}
