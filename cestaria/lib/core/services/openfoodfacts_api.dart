/// Servicio para consultar OpenFoodFacts (OFF) por código de barras o búsqueda.
/// Implementación ligera basada en REST (http) y mapeo a `Product`.
///
/// Endpoints usados:
/// - Search: https://world.openfoodfacts.org/cgi/search.pl?search_simple=1&action=process&json=1&fields=...
/// - Product by barcode: https://world.openfoodfacts.org/api/v2/product/{barcode}.json?fields=...
///
/// Nota: simplificado; añade cabeceras/user-agent y localización si lo necesitas.
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cestaria/models/product.dart';

class OpenFoodFactsApi {
  OpenFoodFactsApi({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const _base = 'https://world.openfoodfacts.org';
  static const _searchFields = 'code,product_name,brands,quantity,image_url,nutriments';

  Future<List<Product>> search(String query) async {
    if (query.trim().isEmpty) return <Product>[];
    final uri = Uri.parse('$_base/cgi/search.pl').replace(queryParameters: {
      'search_terms': query,
      'search_simple': '1',
      'action': 'process',
      'json': '1',
      'fields': _searchFields,
      // 'lc': 'es' // puedes forzar idioma si lo prefieres
    });
    try {
      final res = await _client.get(uri);
      if (res.statusCode != 200) return <Product>[];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (data['products'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(_fromOffJson)
          .whereType<Product>()
          .toList(growable: false);
      return list;
    } catch (_) {
      return <Product>[];
    }
  }

  Future<Product?> getByBarcode(String barcode) async {
    if (barcode.trim().isEmpty) return null;
    final uri = Uri.parse('$_base/api/v2/product/$barcode.json')
        .replace(queryParameters: {'fields': _searchFields});
    try {
      final res = await _client.get(uri);
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final p = data['product'];
      if (p is Map<String, dynamic>) {
        return _fromOffJson(p);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Product? _fromOffJson(Map<String, dynamic> p) {
    final id = (p['code'] as String?)?.trim();
    final name = (p['product_name'] as String?)?.trim();
    if (id == null || id.isEmpty || name == null || name.isEmpty) return null;
    return Product(
      id: id,
      name: name,
      brand: (p['brands'] as String?)?.trim(),
      quantity: (p['quantity'] as String?)?.trim(),
      imageUrl: (p['image_url'] as String?)?.trim(),
      nutrition: (p['nutriments'] is Map<String, dynamic>) ? p['nutriments'] as Map<String, dynamic> : null,
      lastUpdated: null,
    );
  }
}