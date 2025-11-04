import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'shared_cart_repository.dart';

/// Shared cart synced with Firestore (to be wired later)
final sharedCartProvider = StateNotifierProvider<SharedCartController, AsyncValue<Cart>>(
  (ref) => SharedCartController(ref.read(sharedCartRepositoryProvider)),
);

class SharedCartController extends StateNotifier<AsyncValue<Cart>> {
  SharedCartController(this._repo) : super(const AsyncValue.loading());
  final SharedCartRepository _repo;
  StreamSubscription<Cart>? _sub;

  /// Subscribe to Firestore stream and emit updates.
  Future<void> subscribe(String cartId) async {
    _sub?.cancel();
    state = const AsyncValue.loading();
    _sub = _repo.watchCart(cartId).listen(
      (cart) => state = AsyncValue.data(cart),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  /// Save the current cart (when data is available) to Firestore.
  Future<void> save(Cart cart) async {
    await _repo.updateCart(cart);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
