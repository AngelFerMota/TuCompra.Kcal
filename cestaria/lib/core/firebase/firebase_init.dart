import 'package:firebase_core/firebase_core.dart';

/// Lightweight helper to initialize Firebase safely.
/// If platform config is missing, it catches and continues to keep the app running.
class FirebaseBootstrapper {
  FirebaseBootstrapper._();
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      // If DefaultFirebaseOptions is available, you can pass options here.
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await Firebase.initializeApp();
      _initialized = true;
    } catch (_) {
      // Swallow init errors so the app can run without Firebase configured.
      _initialized = false;
    }
  }
}
