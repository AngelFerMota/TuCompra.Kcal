import 'package:flutter/material.dart';
import 'package:cestaria/models/product.dart';
import 'package:cestaria/core/widgets/nutriscore_badge.dart';

/// Pantalla de detalle del producto con información nutricional completa.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final nutrition = product.nutrition;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartir',
            onPressed: () {
              // TODO: implementar compartir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartir (TODO)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            if (product.imageUrl != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl!,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood_outlined, size: 100),
                      ),
                    ),
                  ),
                ),
              ),

            // Nombre y marca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.quantity != null)
                        Chip(
                          label: Text(product.quantity!),
                          avatar: const Icon(Icons.straighten, size: 18),
                        ),
                      const SizedBox(width: 8),
                      if (product.price != null)
                        Chip(
                          label: Text('${product.price!.toStringAsFixed(2)} €'),
                          backgroundColor: Colors.green[100],
                          labelStyle: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // NutriScore
            if (product.nutriScore != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calidad Nutricional',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        NutriScoreBar(grade: product.nutriScore!),
                        const SizedBox(height: 8),
                        Text(
                          _getNutriScoreDescription(product.nutriScore!),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Información nutricional
            if (nutrition != null && nutrition.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información Nutricional',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Por 100g/ml',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Divider(height: 24),
                        _buildNutritionRow(
                          'Energía',
                          _formatEnergy(nutrition),
                          isHeader: true,
                        ),
                        const SizedBox(height: 8),
                        _buildNutritionRow(
                          'Grasas',
                          _formatValue(nutrition, 'fat'),
                        ),
                        _buildNutritionRow(
                          '  Saturadas',
                          _formatValue(nutrition, 'saturated-fat'),
                          isIndented: true,
                        ),
                        const SizedBox(height: 8),
                        _buildNutritionRow(
                          'Hidratos de carbono',
                          _formatValue(nutrition, 'carbohydrates'),
                        ),
                        _buildNutritionRow(
                          '  Azúcares',
                          _formatValue(nutrition, 'sugars'),
                          isIndented: true,
                        ),
                        const SizedBox(height: 8),
                        _buildNutritionRow(
                          'Fibra',
                          _formatValue(nutrition, 'fiber'),
                        ),
                        const SizedBox(height: 8),
                        _buildNutritionRow(
                          'Proteínas',
                          _formatValue(nutrition, 'proteins'),
                        ),
                        const SizedBox(height: 8),
                        _buildNutritionRow(
                          'Sal',
                          _formatValue(nutrition, 'salt'),
                        ),
                        if (nutrition.containsKey('sodium_100g'))
                          _buildNutritionRow(
                            '  Sodio',
                            _formatValue(nutrition, 'sodium'),
                            isIndented: true,
                          ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Información nutricional no disponible',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(
    String label,
    String value, {
    bool isHeader = false,
    bool isIndented = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: isIndented ? 16.0 : 0,
        bottom: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isIndented ? Colors.grey[700] : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatEnergy(Map<String, dynamic> nutrition) {
    final kcal = nutrition['energy-kcal_100g'];
    final kj = nutrition['energy-kj_100g'];
    
    if (kcal != null && kj != null) {
      return '${kcal.toStringAsFixed(0)} kcal / ${kj.toStringAsFixed(0)} kJ';
    } else if (kcal != null) {
      return '${kcal.toStringAsFixed(0)} kcal';
    } else if (kj != null) {
      return '${kj.toStringAsFixed(0)} kJ';
    }
    return '-';
  }

  String _formatValue(Map<String, dynamic> nutrition, String key) {
    final value = nutrition['${key}_100g'];
    if (value == null) return '-';
    
    if (value is num) {
      // Sal y sodio en mg, resto en g
      if (key == 'sodium') {
        return '${(value * 1000).toStringAsFixed(0)} mg';
      }
      return '${value.toStringAsFixed(1)} g';
    }
    return value.toString();
  }

  String _getNutriScoreDescription(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return 'Muy buena calidad nutricional. Producto recomendado para consumo frecuente.';
      case 'B':
        return 'Buena calidad nutricional. Producto de consumo habitual.';
      case 'C':
        return 'Calidad nutricional aceptable. Consumir con moderación.';
      case 'D':
        return 'Baja calidad nutricional. Limitar su consumo.';
      case 'E':
        return 'Muy baja calidad nutricional. Evitar consumo frecuente.';
      default:
        return '';
    }
  }
}
