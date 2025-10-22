// Archivo: kpicard.dart (versión modificada)

import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String? value; // 1. El valor ahora es opcional (puede ser nulo)
  final IconData icon;
  final Color color;
  final VoidCallback? onTap; // 2. Añadimos una función para el clic

  const KpiCard({
    super.key,
    required this.title,
    this.value, // Ya no es 'required'
    required this.icon,
    required this.color,
    this.onTap, // Nuevo parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // 3. Lo envolvemos en InkWell para que sea pulsable
      child: InkWell( 
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0), // Para que la onda del clic sea redondeada
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
            children: [
              Icon(icon, size: 25, color: color),
              const Spacer(), // Usa el espacio disponible para empujar el texto hacia abajo
              // 4. Solo mostramos el valor si no es nulo
              if (value != null)
                Text(
                  value!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              if (value != null) const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}