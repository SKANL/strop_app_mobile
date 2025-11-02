import 'package:flutter/material.dart';
import '../../../../../core/core_ui/theme/app_colors.dart';

/// Widget para buscar y seleccionar un material de una lista
class MaterialSearchSelector extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredMaterials;
  final String? selectedMaterial;
  final String? selectedUnit;
  final Function(String material, String unit) onMaterialSelected;
  final VoidCallback onClearSearch;

  const MaterialSearchSelector({
    super.key,
    required this.searchController,
    required this.filteredMaterials,
    required this.selectedMaterial,
    required this.selectedUnit,
    required this.onMaterialSelected,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insumo Solicitado *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Buscar insumo...',
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClearSearch,
                  )
                : null,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Lista de resultados
        if (searchController.text.isNotEmpty && filteredMaterials.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = filteredMaterials[index];
                return ListTile(
                  title: Text(material['name']!),
                  subtitle: Text('Unidad: ${material['unit']}'),
                  trailing: selectedMaterial == material['name']
                      ? Icon(Icons.check_circle, color: AppColors.materialRequestColor)
                      : null,
                  onTap: () {
                    onMaterialSelected(material['name']!, material['unit']!);
                  },
                );
              },
            ),
          ),
        
        if (selectedMaterial != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lighten(AppColors.materialRequestColor, 0.95),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lighten(AppColors.materialRequestColor, 0.7)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.materialRequestColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seleccionado: $selectedMaterial',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
