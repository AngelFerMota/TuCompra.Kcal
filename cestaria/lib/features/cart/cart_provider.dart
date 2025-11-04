import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'cart_repository.dart';

final cartProvider = StateNotifierProvider<CartController, Cart>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  // Minimal initial state; could be replaced by repo.loadLocalCart()
  return CartController(
    const Cart(id: 'local', name: 'Carrito local', ownerId: 'local'),
    repo,
  );
});

class CartController extends StateNotifier<Cart> {
  CartController(super.state, this._repo);
  // ignore: unused_field
  final CartRepository _repo;

  // TODO: implement add/remove/update items using state.copyWith
  void clear() {
    // state = state.copyWith(items: []);
  }
}
