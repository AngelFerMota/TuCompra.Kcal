import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/product.dart';
import 'package:cestaria/core/services/mercadona_api.dart';
import 'package:cestaria/core/services/openfoodfacts_api.dart';
import 'package:cestaria/core/providers/services_providers.dart';

/// Orquesta la búsqueda de productos combinando fuentes (Mercadona/OFF).
class ProductSearchRepository {
  ProductSearchRepository({required this.mercadonaApi, required this.openFoodFactsApi});
  final MercadonaApi mercadonaApi;
  final OpenFoodFactsApi openFoodFactsApi;

  Future<List<Product>> search(String query) async {
    // Estrategia: priorizar Mercadona (productos españoles con precio)
    // y enriquecerlos con información nutricional de OpenFoodFacts
    
    try {
      // 1. Buscar en Mercadona primero (productos con precio)
      final mercadonaResults = await mercadonaApi.search(query);
      
      // 2. Buscar en OpenFoodFacts para complementar y enriquecer
      final offResults = await openFoodFactsApi.search(query);
      
      // 3. Enriquecer productos de Mercadona con datos nutricionales de OFF
      final enrichedMercadona = await _enrichMercadonaProducts(mercadonaResults, offResults);
      
      // 4. Añadir productos de OFF que no estén duplicados
      final combinedResults = <Product>[...enrichedMercadona];
      
      for (final offProduct in offResults) {
        // Evitar duplicados comparando nombres similares
        final isDuplicate = enrichedMercadona.any((m) =>
          _areProductsSimilar(m.name, offProduct.name)
        );
        
        if (!isDuplicate) {
          combinedResults.add(offProduct);
        }
      }
      
      return combinedResults;
    } catch (e) {
      // Si falla, intentar al menos una fuente
      try {
        return await mercadonaApi.search(query);
      } catch (_) {
        return await openFoodFactsApi.search(query);
      }
    }
  }

  /// Enriquece productos de Mercadona con información nutricional de OpenFoodFacts
  Future<List<Product>> _enrichMercadonaProducts(
    List<Product> mercadonaProducts,
    List<Product> offProducts,
  ) async {
    final enriched = <Product>[];
    
    for (final mercaProduct in mercadonaProducts) {
      // Buscar producto similar en OpenFoodFacts
      final matchingOff = offProducts.where((off) =>
        _areProductsSimilar(mercaProduct.name, off.name)
      ).firstOrNull;
      
      if (matchingOff != null && (matchingOff.nutrition != null || matchingOff.nutriScore != null)) {
        // Combinar: mantener precio de Mercadona, añadir nutrición de OFF
        enriched.add(mercaProduct.copyWith(
          nutrition: matchingOff.nutrition ?? mercaProduct.nutrition,
          nutriScore: matchingOff.nutriScore ?? mercaProduct.nutriScore,
        ));
      } else {
        // Sin match, mantener producto original de Mercadona
        enriched.add(mercaProduct);
      }
    }
    
    return enriched;
  }

  /// Determina si dos nombres de producto son similares
  bool _areProductsSimilar(String name1, String name2) {
    final normalized1 = name1.toLowerCase().trim();
    final normalized2 = name2.toLowerCase().trim();
    
    // Comparación básica: si uno contiene al otro (mínimo 5 caracteres)
    if (normalized1.length >= 5 && normalized2.length >= 5) {
      final shorter = normalized1.length < normalized2.length ? normalized1 : normalized2;
      final longer = normalized1.length >= normalized2.length ? normalized1 : normalized2;
      
      // Buscar palabras clave comunes
      final words1 = normalized1.split(' ').where((w) => w.length > 3).toSet();
      final words2 = normalized2.split(' ').where((w) => w.length > 3).toSet();
      final commonWords = words1.intersection(words2);
      
      // Considerar similares si comparten 2+ palabras o uno contiene al otro
      return commonWords.length >= 2 || longer.contains(shorter.substring(0, shorter.length > 10 ? 10 : shorter.length));
    }
    
    return false;
  }

  Future<Product?> getByBarcode(String barcode) async {
    // Los productos de Mercadona usan IDs internos, no códigos de barras EAN
    // Por ahora, usar solo OpenFoodFacts para escaneo de códigos
    return openFoodFactsApi.getByBarcode(barcode);
  }
}

final productSearchRepositoryProvider = Provider<ProductSearchRepository>((ref) {
  final mercadona = ref.read(mercadonaApiProvider);
  final off = ref.read(openFoodFactsApiProvider);
  return ProductSearchRepository(mercadonaApi: mercadona, openFoodFactsApi: off);
});
