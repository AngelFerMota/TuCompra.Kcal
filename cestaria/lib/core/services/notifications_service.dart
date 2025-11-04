/// Notifications Service: permisos e interacción con notificaciones.
///
/// Recomendación: combinar `firebase_messaging` (push) + `flutter_local_notifications`
/// (locales). Para "notificaciones inteligentes", añade lógica de segmentación/trigger
/// en otra capa y usa este servicio sólo como mecanismo de entrega.
class NotificationsService {
  /// Inicialización básica (tokens, canales, etc.).
  Future<void> initialize() async {}

  /// Solicita permisos al usuario (iOS/macOS y Android 13+).
  Future<void> requestPermissions() async {}

  /// Programa un recordatorio básico (placeholder; no implementa scheduling real).
  Future<void> scheduleSmartReminder() async {}
}
