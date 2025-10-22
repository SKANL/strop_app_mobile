import 'package:flutter/material.dart';

class DetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;

  const DetailInfoRow({
    super.key,
    required this.label,
    this.value = '',
    this.valueWidget,
  }) : assert(valueWidget != null || value != '', 'Debe proveer un valor o un valueWidget');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          valueWidget ?? Text(value, style: Theme.of(context).textTheme.titleMedium),
          const Divider(height: 16),
        ],
      ),
    );
  }
}