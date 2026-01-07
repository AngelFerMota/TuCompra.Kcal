import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app.dart';
import 'core/firebase/firebase_init.dart';
import 'core/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await FirebaseBootstrapper.ensureInitialized();
  
  // Inicializar push notifications cuando el usuario esté autenticado
  if (FirebaseBootstrapper.isInitialized) {
    final pushService = PushNotificationService();
    
    // Listener de cambios de autenticación
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Usuario autenticado: inicializar push notifications
        pushService.initialize(userId: user.uid);
      } else {
        // Usuario cerró sesión: limpiar token
        pushService.clearUserId();
      }
    });
  }
  
  runApp(const ProviderScope(child: App()));
}
