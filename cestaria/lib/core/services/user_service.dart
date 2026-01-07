import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Modelo de usuario para Firestore
class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

/// Servicio para gestionar usuarios en Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crea o actualiza un usuario en Firestore
  Future<void> createOrUpdateUser({
    required String userId,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final doc = await userRef.get();

      if (doc.exists) {
        // Actualizar usuario existente
        await userRef.update({
          'email': email,
          'displayName': displayName,
          'photoUrl': photoUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('[USER] Usuario actualizado: $userId');
      } else {
        // Crear nuevo usuario
        await userRef.set({
          'email': email,
          'displayName': displayName,
          'photoUrl': photoUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('[USER] Usuario creado: $userId');
      }
    } catch (e) {
      debugPrint('[ERROR] Error creando/actualizando usuario: $e');
      rethrow;
    }
  }

  /// Guarda el token FCM del usuario en Firestore
  Future<void> saveFcmToken(String userId, String fcmToken) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[USER] Token FCM guardado para usuario: $userId');
    } catch (e) {
      debugPrint('[ERROR] Error guardando token FCM: $e');
      // Si el documento no existe, crearlo
      try {
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('[USER] Token FCM guardado (documento creado): $userId');
      } catch (e2) {
        debugPrint('[ERROR] Error creando documento para token: $e2');
      }
    }
  }

  /// Elimina el token FCM del usuario (logout)
  Future<void> removeFcmToken(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[USER] Token FCM eliminado para usuario: $userId');
    } catch (e) {
      debugPrint('[ERROR] Error eliminando token FCM: $e');
    }
  }

  /// Obtiene un usuario de Firestore
  Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('[ERROR] Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Stream de un usuario
  Stream<AppUser?> watchUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  /// Actualiza el nombre de usuario
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[USER] Nombre actualizado: $displayName');
    } catch (e) {
      debugPrint('[ERROR] Error actualizando nombre: $e');
      rethrow;
    }
  }

  /// Actualiza la foto de perfil
  Future<void> updatePhotoUrl(String userId, String photoUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[USER] Foto actualizada');
    } catch (e) {
      debugPrint('[ERROR] Error actualizando foto: $e');
      rethrow;
    }
  }
}
