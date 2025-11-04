import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'package:cestaria/core/services/firestore_service.dart';

/// Orquesta la sincronización de carritos colaborativos con Firestore.
class SharedCartRepository {
  SharedCartRepository(this._firestore);
  final FirestoreService _firestore;

  Stream<Cart> watchCart(String cartId) {
    return _firestore.watchCart(cartId);
  }

  Future<void> updateCart(Cart cart) async {
    await _firestore.setCart(cart);
  }
}

final sharedCartRepositoryProvider = Provider<SharedCartRepository>((ref) {
  final fs = ref.read(firestoreServiceProvider);
  return SharedCartRepository(fs);
});
