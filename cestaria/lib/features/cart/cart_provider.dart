import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';
import 'package:cestaria/core/utils/mock_data.dart';
import 'cart_repository.dart';

final cartProvider = StateNotifierProvider<CartController, Cart>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  // Inicializa con datos mock para visualizar UI
  return CartController(MockData.localCart, repo);
});

class CartController extends StateNotifier<Cart> {
  CartController(super.state, this._repo);
  // ignore: unused_field
  final CartRepository _repo;

  void addItem(CartItem item) {
    state = state.copyWith(
      items: [...state.items, item],
      updatedAt: DateTime.now(),
    );
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  void updateQuantity(String productId, double newQuantity) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.productId == productId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  void toggleChecked(String productId) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.productId == productId) {
          return item.copyWith(isChecked: !item.isChecked);
        }
        return item;
      }).toList(),
    );
  }

  void clear() {
    state = state.copyWith(items: [], updatedAt: DateTime.now());
  }
}
