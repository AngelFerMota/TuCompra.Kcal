import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Lightweight helper to initialize Firebase safely.
/// If platform config is missing, it catches and continues to keep the app running.
class FirebaseBootstrapper {
  FirebaseBootstrapper._();
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      debugPrint('✅ Firebase inicializado correctamente');
    } catch (e) {
      // Swallow init errors so the app can run without Firebase configured.
      _initialized = false;
      debugPrint('❌ Error al inicializar Firebase: $e');
    }
  }
}
