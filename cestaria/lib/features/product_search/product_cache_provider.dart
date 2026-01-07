import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/product.dart';
import 'package:cestaria/core/utils/mock_data.dart';

/// Provider que almacena productos en memoria para acceso rápido.
/// 
/// Útil para mantener información nutricional de productos añadidos al carrito
/// desde APIs (Mercadona, OpenFoodFacts) sin perder los datos.
final productCacheProvider = StateNotifierProvider<ProductCacheController, Map<String, Product>>((ref) {
  // Inicializa con productos mock
  final initialCache = <String, Product>{};
  for (final product in MockData.products) {
    initialCache[product.id] = product;
  }
  return ProductCacheController(initialCache);
});

class ProductCacheController extends StateNotifier<Map<String, Product>> {
  ProductCacheController(super.initialState);

  /// Añade o actualiza un producto en el cache
  void addProduct(Product product) {
    state = {...state, product.id: product};
  }

  /// Añade múltiples productos al cache
  void addProducts(List<Product> products) {
    final newState = {...state};
    for (final product in products) {
      newState[product.id] = product;
    }
    state = newState;
  }

  /// Obtiene un producto por ID
  Product? getProduct(String productId) {
    return state[productId];
  }

  /// Limpia el cache (mantiene solo productos mock)
  void clear() {
    final mockCache = <String, Product>{};
    for (final product in MockData.products) {
      mockCache[product.id] = product;
    }
    state = mockCache;
  }
}
