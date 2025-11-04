import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'package:cestaria/core/services/local_database.dart';

/// Maneja el carrito local (persistencia opcional con SQLite)
class CartRepository {
  CartRepository(this._db);
  // ignore: unused_field
  final LocalDatabase _db;

  Future<Cart> loadLocalCart() async {
    // TODO: cargar carrito local (o crear uno por defecto)
    return const Cart(id: 'local', name: 'Carrito local', ownerId: 'local');
  }

  Future<void> saveCart(Cart cart) async {
    // TODO: persistir carrito
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final db = ref.read(localDatabaseProvider);
  return CartRepository(db);
});
