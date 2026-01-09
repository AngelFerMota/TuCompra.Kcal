import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';
import 'package:cestaria/features/product_search/product_cache_provider.dart';
import 'package:cestaria/core/utils/export_utils.dart';
import 'package:cestaria/models/cart.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final Set<String> _selectedProducts = {};
  bool _isSelectionMode = false;

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedProducts.clear();
      }
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _deleteSelectedProducts() {
    if (_selectedProducts.isEmpty) return;

    final count = _selectedProducts.length;
    for (final productId in _selectedProducts.toList()) {
      ref.read(cartProvider.notifier).removeItem(productId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count producto${count > 1 ? 's eliminados' : ' eliminado'}'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _selectedProducts.clear();
      _isSelectionMode = false;
    });
  }

  Widget _buildProductImage(WidgetRef ref, String productId) {
    final product = ref.read(productCacheProvider)[productId];
    final imageUrl = product?.imageUrl;
    
    if (imageUrl == null) {
      return const Icon(Icons.fastfood_outlined, size: 40);
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_outlined, size: 40),
      ),
    );
  }

  double _extractQuantityInGrams(String? quantity) {
    if (quantity == null) return 100.0; // Default 100g if unknown
    
    final regex = RegExp(r'(\d+(?:\.\d+)?)\s*(g|kg|ml|l)', caseSensitive: false);
    final match = regex.firstMatch(quantity);
    
    if (match != null) {
      final value = double.tryParse(match.group(1) ?? '') ?? 100.0;
      final unit = match.group(2)?.toLowerCase() ?? 'g';
      
      // Convert to grams
      if (unit == 'kg') return value * 1000;
      if (unit == 'l') return value * 1000; // Assume 1L = 1000g for liquids
      return value; // g or ml
    }
    
    return 100.0; // Default
  }

  double _getCaloriesForProduct(WidgetRef ref, String productId, double quantity) {
    final product = ref.read(productCacheProvider)[productId];
    if (product?.nutrition == null) return 0.0;
    
    final caloriesPer100g = product!.nutrition!['energy-kcal_100g'] as num?;
    if (caloriesPer100g == null) return 0.0;
    
    final gramsPerUnit = _extractQuantityInGrams(product.quantity);
    final totalGrams = gramsPerUnit * quantity;
    
    return (caloriesPer100g * totalGrams) / 100.0;
  }

  double _getMacronutrientForProduct(WidgetRef ref, String productId, double quantity, String nutrientKey) {
    final product = ref.read(productCacheProvider)[productId];
    if (product?.nutrition == null) return 0.0;
    
    final nutrientPer100g = product!.nutrition![nutrientKey] as num?;
    if (nutrientPer100g == null) return 0.0;
    
    final gramsPerUnit = _extractQuantityInGrams(product.quantity);
    final totalGrams = gramsPerUnit * quantity;
    
    return (nutrientPer100g * totalGrams) / 100.0;
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    
    double total = 0;
    double totalCalories = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    
    for (final item in cart.items) {
      // Solo sumar precio si existe y es mayor que 0
      if (item.unitPrice != null && item.unitPrice! > 0) {
        total += item.unitPrice! * item.quantity;
      }
      totalCalories += _getCaloriesForProduct(ref, item.productId, item.quantity);
      totalProteins += _getMacronutrientForProduct(ref, item.productId, item.quantity, 'proteins_100g');
      totalCarbs += _getMacronutrientForProduct(ref, item.productId, item.quantity, 'carbohydrates_100g');
      totalFats += _getMacronutrientForProduct(ref, item.productId, item.quantity, 'fat_100g');
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedProducts.length} seleccionado${_selectedProducts.length != 1 ? 's' : ''}')
            : const Text('Mi Carrito'),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
        actions: [
          if (_isSelectionMode) ...[
            if (_selectedProducts.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Eliminar seleccionados',
                onPressed: _deleteSelectedProducts,
              ),
          ] else ...[
            if (cart.items.isNotEmpty) ...[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Exportar carrito',
                onPressed: () {
                  // Crear modelo Cart desde el estado actual
                  final cartModel = Cart(
                    id: 'local_cart',
                    name: 'Mi Carrito',
                    ownerId: 'local',
                    items: cart.items,
                    participantIds: [],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  ExportUtils.showExportDialog(context, cartModel);
                },
              ),
              IconButton(                icon: const Icon(Icons.checklist),
                tooltip: 'Seleccionar múltiples',
                onPressed: _toggleSelectionMode,
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Vaciar carrito',
                onPressed: () {
                  ref.read(cartProvider.notifier).clear();
                },
              ),
            ],
          ],
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Carrito vacío',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      final subtotal = (item.unitPrice ?? 0) * item.quantity;
                      final itemCalories = _getCaloriesForProduct(ref, item.productId, item.quantity);
                      
                      return Dismissible(
                        key: Key(item.productId),
                        direction: _isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref.read(cartProvider.notifier).removeItem(item.productId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${item.name}" eliminado del carrito'),
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'DESHACER',
                                onPressed: () {
                                  // TODO: Implementar undo
                                },
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          onTap: _isSelectionMode ? () => _toggleProductSelection(item.productId) : null,
                          selected: _selectedProducts.contains(item.productId),
                          selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isSelectionMode)
                                Checkbox(
                                  value: _selectedProducts.contains(item.productId),
                                  onChanged: (_) => _toggleProductSelection(item.productId),
                                )
                              else
                                Checkbox(
                                  value: item.isChecked,
                                  onChanged: (_) {
                                    ref.read(cartProvider.notifier).toggleChecked(item.productId);
                                  },
                                ),
                              _buildProductImage(ref, item.productId),
                            ],
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isChecked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.unitPrice != null && item.unitPrice! > 0
                                        ? '${item.unitPrice!.toStringAsFixed(2)} € × ${item.quantity.toStringAsFixed(0)} ${item.unit ?? 'ud'}'
                                        : 'Sin precio · ${item.quantity.toStringAsFixed(0)} ${item.unit ?? 'ud'}',
                                    style: TextStyle(
                                      fontStyle: item.unitPrice == null || item.unitPrice == 0 ? FontStyle.italic : null,
                                      color: item.unitPrice == null || item.unitPrice == 0 ? Colors.grey[600] : null,
                                    ),
                                  ),
                                ],
                              ),
                              if (itemCalories > 0)
                                Text(
                                  '${itemCalories.toStringAsFixed(0)} kcal',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    onPressed: item.quantity > 1
                                        ? () {
                                            ref.read(cartProvider.notifier)
                                                .updateQuantity(item.productId, item.quantity - 1);
                                          }
                                        : null,
                                  ),
                                  Text('${item.quantity.toStringAsFixed(0)}'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier)
                                          .updateQuantity(item.productId, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            subtotal > 0 ? '${subtotal.toStringAsFixed(2)} €' : 'Sin precio',
                            style: TextStyle(
                              fontWeight: subtotal > 0 ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                              color: subtotal > 0 ? null : Colors.grey[600],
                              fontStyle: subtotal > 0 ? null : FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Nutritional Summary Card
                if (totalCalories > 0)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información Nutricional Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNutrientColumn(
                              context,
                              'Calorías',
                              '${totalCalories.toStringAsFixed(0)} kcal',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            _buildNutrientColumn(
                              context,
                              'Proteínas',
                              '${totalProteins.toStringAsFixed(1)} g',
                              Icons.fitness_center,
                              Colors.red,
                            ),
                            _buildNutrientColumn(
                              context,
                              'Carbohidratos',
                              '${totalCarbs.toStringAsFixed(1)} g',
                              Icons.grain,
                              Colors.amber,
                            ),
                            _buildNutrientColumn(
                              context,
                              'Grasas',
                              '${totalFats.toStringAsFixed(1)} g',
                              Icons.opacity,
                              Colors.yellow[700]!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                // Price Total
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNutrientColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
