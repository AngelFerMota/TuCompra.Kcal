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
    // Por ahora prioriza OpenFoodFacts. En el futuro combina con Mercadona.
    return openFoodFactsApi.search(query);
  }

  Future<Product?> getByBarcode(String barcode) async {
    // Por ahora OFF directo.
    return openFoodFactsApi.getByBarcode(barcode);
  }
}

final productSearchRepositoryProvider = Provider<ProductSearchRepository>((ref) {
  final mercadona = ref.read(mercadonaApiProvider);
  final off = ref.read(openFoodFactsApiProvider);
  return ProductSearchRepository(mercadonaApi: mercadona, openFoodFactsApi: off);
});
