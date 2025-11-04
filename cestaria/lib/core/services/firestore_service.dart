/// Servicio para carritos colaborativos en tiempo real con Firebase.
/// Implementación mínima y segura (no falla si Firebase no está inicializado).
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cestaria/core/firebase/firebase_init.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Escucha un carrito en tiempo real.
  Stream<Cart> watchCart(String cartId) {
    if (!FirebaseBootstrapper.isInitialized) {
      return const Stream<Cart>.empty();
    }
    final doc = _db.collection('carts').doc(cartId);
    return doc.snapshots().map((snap) {
      final data = snap.data();
      if (data == null) {
        return Cart(id: cartId, name: 'Nuevo carrito', ownerId: 'unknown');
      }
      final mapped = _fromFirestore(data, cartId);
      return mapped;
    });
  }

  /// Crea/actualiza un carrito.
  Future<void> setCart(Cart cart) async {
    if (!FirebaseBootstrapper.isInitialized) return;
    await _db.collection('carts').doc(cart.id).set(_toFirestore(cart), SetOptions(merge: true));
  }

  // --- Mapeo simple (DateTime <-> Timestamp, items anidados) ---
  Cart _fromFirestore(Map<String, dynamic> data, String id) {
    DateTime? _asDate(dynamic v) => v is Timestamp ? v.toDate() : (v is String ? DateTime.tryParse(v) : null);
    List<CartItem> _asItems(dynamic v) {
      final list = (v as List?) ?? const [];
      return list.whereType<Map<String, dynamic>>().map((e) => CartItem.fromJson(_normalize(e))).toList();
    }

    final norm = _normalize(data);
    return Cart(
      id: id,
      name: (norm['name'] as String?) ?? 'Carrito',
      ownerId: (norm['ownerId'] as String?) ?? 'unknown',
      participantIds: (norm['participantIds'] as List?)?.whereType<String>().toList() ?? const [],
      items: _asItems(norm['items']),
      createdAt: _asDate(norm['createdAt']),
      updatedAt: _asDate(norm['updatedAt']),
      store: norm['store'] as String?,
      isArchived: (norm['isArchived'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> _toFirestore(Cart cart) {
    Map<String, dynamic> itemToJson(CartItem i) => i.toJson();
    return {
      'name': cart.name,
      'ownerId': cart.ownerId,
      'participantIds': cart.participantIds,
      'items': cart.items.map(itemToJson).toList(),
      'createdAt': cart.createdAt != null ? Timestamp.fromDate(cart.createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'store': cart.store,
      'isArchived': cart.isArchived,
    };
  }

  Map<String, dynamic> _normalize(Map<String, dynamic> src) {
    // Convierte posibles valores dinámicos a tipos esperados por fromJson
    final out = <String, dynamic>{};
    src.forEach((k, v) {
      if (v is Timestamp) {
        out[k] = v.toDate().toIso8601String();
      } else if (v is List) {
        out[k] = v.map((e) => e is Timestamp ? e.toDate().toIso8601String() : e).toList();
      } else if (v is Map) {
        out[k] = _normalize(Map<String, dynamic>.from(v));
      } else {
        out[k] = v;
      }
    });
    return out;
  }
}