import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'user_service.dart';

/// Servicio para gestionar notificaciones push con Firebase Cloud Messaging.
///
/// Maneja:
/// - Solicitud de permisos de notificación
/// - Obtención de token FCM
/// - Escucha de mensajes en foreground
/// - Envío de notificaciones locales
/// - Guardado de tokens en Firestore
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final UserService _userService = UserService();
  String? _fcmToken;
  String? _currentUserId;

  /// Token FCM del dispositivo actual
  String? get fcmToken => _fcmToken;

  /// Inicializa el servicio de notificaciones push.
  ///
  /// Solicita permisos y obtiene el token FCM.
  Future<void> initialize({String? userId}) async {
    _currentUserId = userId;
    
    try {
      // Solicitar permisos de notificación (iOS principalmente)
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('[OK] Permisos de notificación concedidos');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('[INFO] Permisos de notificación provisionales');
      } else {
        debugPrint('[ERROR] Permisos de notificación denegados');
        return;
      }

      // Obtener token FCM
      _fcmToken = await _messaging.getToken();
      debugPrint('[FCM] Token: $_fcmToken');

      // Guardar token en Firestore si hay usuario
      if (_fcmToken != null && userId != null) {
        await _userService.saveFcmToken(userId, _fcmToken!);
      }

      // Escuchar cambios en el token
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('[FCM] Token actualizado: $newToken');
        
        // Actualizar en Firestore
        if (_currentUserId != null) {
          _userService.saveFcmToken(_currentUserId!, newToken);
        }
      });

      // Configurar listeners para mensajes
      _setupMessageListeners();
    } catch (e) {
      debugPrint('[ERROR] Error inicializando push notifications: $e');
    }
  }

  /// Actualiza el userId cuando el usuario inicia sesión
  Future<void> setUserId(String userId) async {
    _currentUserId = userId;
    if (_fcmToken != null) {
      await _userService.saveFcmToken(userId, _fcmToken!);
    }
  }

  /// Limpia el token cuando el usuario cierra sesión
  Future<void> clearUserId() async {
    if (_currentUserId != null && _fcmToken != null) {
      await _userService.removeFcmToken(_currentUserId!);
    }
    _currentUserId = null;
  }

  /// Configura listeners para mensajes en foreground y background.
  void _setupMessageListeners() {
    // Mensajes cuando la app está en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[PUSH] Mensaje recibido en foreground: ${message.notification?.title}');
      _handleMessage(message);
    });

    // Mensajes cuando el usuario toca la notificación (app en background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[PUSH] Notificación tocada: ${message.notification?.title}');
      _handleNotificationTap(message);
    });
  }

  /// Maneja un mensaje recibido en foreground.
  void _handleMessage(RemoteMessage message) {
    // Aquí podrías mostrar un diálogo, snackbar o notificación local
    if (message.notification != null) {
      debugPrint('Título: ${message.notification!.title}');
      debugPrint('Cuerpo: ${message.notification!.body}');
    }

    if (message.data.isNotEmpty) {
      debugPrint('Data: ${message.data}');
    }
  }

  /// Maneja cuando el usuario toca una notificación.
  void _handleNotificationTap(RemoteMessage message) {
    // Aquí podrías navegar a una pantalla específica según los datos
    final data = message.data;
    if (data.containsKey('cartId')) {
      debugPrint('[NAV] Navegar al carrito: ${data['cartId']}');
      // TODO: Usar GoRouter para navegar
    }
  }

  /// Suscribe al dispositivo a un topic para recibir notificaciones grupales.
  ///
  /// Útil para carritos compartidos donde todos los participantes
  /// reciben notificaciones del mismo topic.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('[TOPIC] Suscrito al topic: $topic');
    } catch (e) {
      debugPrint('[ERROR] Error suscribiendo al topic $topic: $e');
    }
  }

  /// Cancela la suscripción a un topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('[TOPIC] Desuscrito del topic: $topic');
    } catch (e) {
      debugPrint('[ERROR] Error desuscribiendo del topic $topic: $e');
    }
  }
}

/// Handler para mensajes en background.
///
/// Esta función debe estar en top-level (fuera de cualquier clase).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[PUSH] Mensaje recibido en background: ${message.notification?.title}');
}
