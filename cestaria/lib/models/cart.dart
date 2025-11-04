/// Carrito de la compra (colaborativo o local)
///
/// Freezed + json_serializable. No contiene lógica de negocio.
// ignore_for_file: invalid_annotation_target, uri_does_not_exist

import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id, // Firestore doc id / local UUID
    required String name,
    required String ownerId,
    @Default(<String>[]) List<String> participantIds,
    @Default(<CartItem>[]) List<CartItem> items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? store, // p.ej. "Mercadona"
    @Default(false) bool isArchived,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}