import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product.dart';

/// Servicio de integración con productos de Mercadona.
///
/// Utiliza la API: https://mrkdna.azurewebsites.net/api/Mercadona/
/// - Búsqueda por nombre: /Products?Search={query}
/// - Retorna productos con precio, imagen, packaging (gramos)
class MercadonaApi {
  static const String _baseUrl = 'https://mrkdna.azurewebsites.net/api/Mercadona';
  final http.Client _client;

  MercadonaApi({http.Client? client}) : _client = client ?? http.Client();

  /// Busca productos en Mercadona por nombre.
  ///
  /// Ejemplo: search('salsa fresca') retorna productos con precio e imagen.
  Future<List<Product>> search(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/Products?Search=$encodedQuery');
      
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['problemDetail'] != null) {
          // API retornó error
          return [];
        }

        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((item) => _mapToProduct(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Logging o manejo de errores silencioso para no romper la UI
      return [];
    }
  }

  /// Busca producto por ID de Mercadona.
  Future<Product?> getById(String productId) async {
    try {
      // La API no documenta endpoint /Products/{id}, usar search como fallback
      // Si existe endpoint específico, actualizar aquí
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mapea respuesta de Mercadona API a modelo Product.
  ///
  /// Extrae gramos/unidades del campo packaging (ej: "Paquete 140 g" → "140 g")
  Product _mapToProduct(Map<String, dynamic> json) {
    final String packaging = json['packaging'] ?? '';
    final String quantity = _extractQuantityFromPackaging(packaging);

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Producto sin nombre',
      brand: 'Mercadona', // Todos los productos son de Mercadona/Hacendado
      quantity: quantity,
      price: (json['unitPrice'] as num?)?.toDouble(),
      imageUrl: json['thumbnail'],
      lastUpdated: DateTime.now(),
    );
  }

  /// Extrae cantidad del campo packaging usando regex.
  ///
  /// Ejemplos:
  /// - "Paquete 140 g" → "140 g"
  /// - "Tarrina 200 g" → "200 g"
  /// - "Botella 1 l" → "1 l"
  String _extractQuantityFromPackaging(String packaging) {
    final regex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(g|kg|ml|l|ud|unidades?)', 
                         caseSensitive: false);
    final match = regex.firstMatch(packaging);
    
    if (match != null) {
      final number = match.group(1)?.replaceAll(',', '.');
      final unit = match.group(2)?.toLowerCase();
      return '$number $unit';
    }
    
    return packaging; // Si no se puede extraer, devolver completo
  }
}