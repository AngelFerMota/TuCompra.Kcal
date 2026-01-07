import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/product.dart';
import 'product_search_repository.dart';
import 'product_cache_provider.dart';

/// Product search state holds the async result list.
final productSearchProvider = StateNotifierProvider<ProductSearchController, AsyncValue<List<Product>>>(
  (ref) => ProductSearchController(
    ref.read(productSearchRepositoryProvider),
    ref,
  ),
);

class ProductSearchController extends StateNotifier<AsyncValue<List<Product>>> {
  ProductSearchController(this._repo, this._ref) : super(const AsyncValue.data(<Product>[]));
  final ProductSearchRepository _repo;
  final Ref _ref;
  Timer? _debounce;

  /// Example action: search products (wire to API later)
  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    // TODO: connect to repository
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final results = await _repo.search(query);
    
    // Guardar productos en cache para mantener información nutricional
    _ref.read(productCacheProvider.notifier).addProducts(results);
    
    state = AsyncValue.data(results);
  }

  /// Search a single product by barcode and present it as a one-item list.
  Future<void> searchByBarcode(String barcode) async {
    state = const AsyncValue.loading();
    final product = await _repo.getByBarcode(barcode);
    
    // Guardar en cache si se encontró
    if (product != null) {
      _ref.read(productCacheProvider.notifier).addProduct(product);
    }
    
    state = AsyncValue.data(product == null ? <Product>[] : <Product>[product]);
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      // Lanza búsqueda sólo si hay texto suficiente
      if (query.trim().length >= 2) {
        unawaited(search(query));
      } else {
        state = const AsyncValue.data(<Product>[]);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
