import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/services/user_service.dart';
import '../../core/services/push_notification_service.dart';

/// Provider del usuario actual autenticado
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Servicio de autenticación con Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn? _googleSignIn = kIsWeb ? null : GoogleSignIn();
  final UserService _userService = UserService();
  final PushNotificationService _pushService = PushNotificationService();

  /// Usuario actual
  User? get currentUser => _auth.currentUser;

  /// Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Registra un nuevo usuario con email y contraseña
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar displayName si se proporcionó
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      // Crear documento de usuario en Firestore
      if (credential.user != null) {
        await _userService.createOrUpdateUser(
          userId: credential.user!.uid,
          email: email,
          displayName: displayName ?? email.split('@')[0],
        );

        // Inicializar servicio de notificaciones
        await _pushService.initialize(userId: credential.user!.uid);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Inicia sesión con email y contraseña
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar información del usuario en Firestore
      if (credential.user != null) {
        await _userService.createOrUpdateUser(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          displayName: credential.user!.displayName,
          photoUrl: credential.user!.photoURL,
        );

        // Inicializar servicio de notificaciones
        await _pushService.initialize(userId: credential.user!.uid);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Inicia sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    // Google Sign-In no disponible en web sin configurar Client ID
    if (kIsWeb) {
      throw Exception('Google Sign-In no disponible en web. Usa email/password.');
    }
    
    try {
      // Desconectar sesión anterior si existe
      await _googleSignIn?.signOut();

      // Iniciar flujo de autenticación
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      
      if (googleUser == null) {
        throw Exception('Inicio de sesión cancelado');
      }

      // Obtener credenciales
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Crear o actualizar usuario en Firestore
      if (userCredential.user != null) {
        await _userService.createOrUpdateUser(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL,
        );

        // Inicializar servicio de notificaciones
        await _pushService.initialize(userId: userCredential.user!.uid);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  /// Cierra la sesión actual
  Future<void> signOut() async {
    try {
      // Limpiar token FCM
      if (_auth.currentUser != null) {
        await _pushService.clearUserId();
      }

      // Cerrar sesión en Firebase y Google
      await _auth.signOut();
      if (!kIsWeb) {
        await _googleSignIn?.signOut();
      }
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Envía email de verificación
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Error al enviar email de verificación: $e');
    }
  }

  /// Envía email para restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Actualiza el nombre de usuario
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      await user.updateDisplayName(displayName);
      await user.reload();
      
      // Actualizar en Firestore
      await _userService.updateDisplayName(user.uid, displayName);
    } catch (e) {
      throw Exception('Error al actualizar nombre: $e');
    }
  }

  /// Actualiza la foto de perfil
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      await user.updatePhotoURL(photoURL);
      await user.reload();
      
      // Actualizar en Firestore
      await _userService.updatePhotoUrl(user.uid, photoURL);
    } catch (e) {
      throw Exception('Error al actualizar foto: $e');
    }
  }

  /// Cambia la contraseña del usuario
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');
      if (user.email == null) throw Exception('Usuario sin email');

      // Re-autenticar usuario
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Cambiar contraseña
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Elimina la cuenta del usuario
  Future<void> deleteAccount(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      // Re-autenticar si tiene email/password
      if (user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Eliminar token FCM
      await _pushService.clearUserId();

      // Eliminar cuenta
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Maneja las excepciones de Firebase Auth y las convierte en mensajes legibles
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'user-not-found':
        return 'No se encontró ninguna cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'invalid-credential':
        return 'Credenciales inválidas';
      case 'requires-recent-login':
        return 'Por seguridad, necesitas volver a iniciar sesión';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
