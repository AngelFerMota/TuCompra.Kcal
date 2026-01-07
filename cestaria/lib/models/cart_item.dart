/// Representa una línea del carrito (producto + cantidad + precio)
///
/// Freezed + json_serializable (sin cálculos aquí).
// ignore_for_file: invalid_annotation_target, uri_does_not_exist

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String productId, // referencia a Product.id
    required String name, // denormalizado para mostrar rápido
    @Default(1.0) double quantity,
    String? unit, // ud, kg, g, L, etc.
    double? unitPrice,
    String? notes,
    @Default(false) bool isChecked,
    @Default(false) bool isPurchased, // Marcado como comprado (carritos compartidos)
    String? purchasedBy, // ID del usuario que lo compró
    DateTime? purchasedAt, // Fecha de compra
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}