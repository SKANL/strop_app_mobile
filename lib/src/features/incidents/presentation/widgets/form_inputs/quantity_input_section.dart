import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget para ingresar cantidad y mostrar unidad de medida
class QuantityInputSection extends StatelessWidget {
  final TextEditingController quantityController;
  final String? selectedUnit;

  const QuantityInputSection({
    super.key,
    required this.quantityController,
    required this.selectedUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: quantityController,
            decoration: const InputDecoration(
              labelText: 'Cantidad *',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: FormValidators.positiveNumber('La cantidad'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            initialValue: selectedUnit ?? '',
            decoration: const InputDecoration(
              labelText: 'Unidad',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
        ),
      ],
    );
  }
}
