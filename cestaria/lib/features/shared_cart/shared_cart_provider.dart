import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';
import 'package:cestaria/core/utils/mock_data.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'shared_cart_repository.dart';

/// Shared cart synced with Firestore (to be wired later)
final sharedCartProvider = StateNotifierProvider<SharedCartController, AsyncValue<Cart>>(
  (ref) {
    final controller = SharedCartController(
      ref.read(sharedCartRepositoryProvider),
      ref,
    );
    // Inicializa con datos mock para visualizar UI
    controller._initMock();
    return controller;
  },
);

class SharedCartController extends StateNotifier<AsyncValue<Cart>> {
  SharedCartController(this._repo, this._ref) : super(const AsyncValue.loading());
  final SharedCartRepository _repo;
  final Ref _ref;
  StreamSubscription<Cart>? _sub;

  void _initMock() {
    // Simula carga inicial con datos mock
    Future.delayed(const Duration(milliseconds: 300), () {
      state = AsyncValue.data(MockData.sharedCart);
    });
  }

  /// Subscribe to Firestore stream and emit updates.
  Future<void> subscribe(String cartId) async {
    _sub?.cancel();
    state = const AsyncValue.loading();
    _sub = _repo.watchCart(cartId).listen(
      (cart) => state = AsyncValue.data(cart),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );

    // Suscribirse al topic de notificaciones del carrito
    final pushService = _ref.read(pushNotificationServiceProvider);
    await pushService.subscribeToTopic('cart_$cartId');
  }

  /// Save the current cart (when data is available) to Firestore.
  Future<void> save(Cart cart) async {
    await _repo.updateCart(cart);
  }

  /// Marca un producto como comprado en el carrito compartido.
  ///
  /// Actualiza el estado local y en Firestore, luego envía notificación push.
  Future<void> markAsPurchased(String productId, String userId) async {
    final currentState = state;
    if (currentState is! AsyncData<Cart>) return;

    final cart = currentState.value;
    final updatedItems = cart.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(
          isPurchased: true,
          purchasedBy: userId,
          purchasedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    // Actualizar estado local
    state = AsyncValue.data(updatedCart);

    // Guardar en Firestore
    await _repo.updateCart(updatedCart);

    // Enviar notificación push
    final item = cart.items.firstWhere((i) => i.productId == productId);
    await _sendPurchaseNotification(cart.id, item.name, userId);
  }

  /// Elimina un producto del carrito compartido.
  ///
  /// Actualiza Firestore y envía notificación a todos los participantes.
  Future<void> removeItem(String productId, String userId) async {
    final currentState = state;
    if (currentState is! AsyncData<Cart>) return;

    final cart = currentState.value;
    final removedItem = cart.items.firstWhere((i) => i.productId == productId);
    
    final updatedItems = cart.items.where((item) => item.productId != productId).toList();
    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    // Actualizar estado local
    state = AsyncValue.data(updatedCart);

    // Guardar en Firestore
    await _repo.updateCart(updatedCart);

    // Enviar notificación push
    await _sendRemovalNotification(cart.id, removedItem.name, userId);
  }

  /// Añade un producto al carrito compartido.
  ///
  /// Actualiza Firestore y envía notificación a todos los participantes.
  Future<void> addItem(CartItem item, String userId) async {
    final currentState = state;
    if (currentState is! AsyncData<Cart>) return;

    final cart = currentState.value;
    
    // Verificar si el producto ya existe
    final existingIndex = cart.items.indexWhere((i) => i.productId == item.productId);
    
    List<CartItem> updatedItems;
    if (existingIndex != -1) {
      // Si existe, incrementar cantidad
      updatedItems = List.from(cart.items);
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    } else {
      // Si no existe, añadir nuevo
      updatedItems = [...cart.items, item];
    }

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    // Actualizar estado local
    state = AsyncValue.data(updatedCart);

    // Guardar en Firestore
    await _repo.updateCart(updatedCart);

    // Enviar notificación push
    await _sendAddNotification(cart.id, item.name, userId);
  }

  /// Alterna el estado de "checked" de un producto.
  Future<void> toggleChecked(String productId) async {
    final currentState = state;
    if (currentState is! AsyncData<Cart>) return;

    final cart = currentState.value;
    final updatedItems = cart.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(isChecked: !item.isChecked);
      }
      return item;
    }).toList();

    final updatedCart = cart.copyWith(items: updatedItems);
    state = AsyncValue.data(updatedCart);
    await _repo.updateCart(updatedCart);
  }

  /// Envía notificación push cuando se compra un producto.
  Future<void> _sendPurchaseNotification(String cartId, String productName, String userId) async {
    // TODO: Implementar con Cloud Functions o API backend
    // Por ahora solo log
    debugPrint('[NOTIF] Notificación: $userId compró "$productName" del carrito $cartId');
  }

  /// Envía notificación push cuando se añade un producto.
  Future<void> _sendAddNotification(String cartId, String productName, String userId) async {
    // TODO: Implementar con Cloud Functions o API backend
    debugPrint('[NOTIF] Notificación: $userId añadió "$productName" al carrito $cartId');
  }

  /// Envía notificación push cuando se elimina un producto.
  Future<void> _sendRemovalNotification(String cartId, String productName, String userId) async {
    // TODO: Implementar con Cloud Functions o API backend
    debugPrint('[NOTIF] Notificación: $userId eliminó "$productName" del carrito $cartId');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
