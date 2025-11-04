/// Modelo base para un producto del supermercado (Mercadona/OpenFoodFacts)
///
/// Freezed + json_serializable (sin lógica de negocio).
/// Ejecuta generación cuando toque:
///   flutter pub run build_runner build --delete-conflicting-outputs
// ignore_for_file: invalid_annotation_target, uri_does_not_exist

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id, // EAN/código de barras u otro identificador
    required String name,
    String? brand,
    String? quantity, // p.ej. "500 g"
    double? price,
    String? imageUrl,
    Map<String, dynamic>? nutrition,
    DateTime? lastUpdated,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}