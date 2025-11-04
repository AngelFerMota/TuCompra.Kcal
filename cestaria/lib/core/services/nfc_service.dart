/// NFC Service: encapsula lectura/escaneo de etiquetas NFC.
///
/// Recomendación: usar paquetes como `nfc_manager` o `flutter_nfc_kit`.
/// En iOS requiere hardware compatible; en Android puede requerir permisos.
/// Aquí solo se definen stubs sin lógica.
class NfcService {
  /// Inicializa/chequea disponibilidad de NFC.
  Future<void> initialize() async {}

  /// Inicia un escaneo simple y procesa el primer tag disponible.
  Future<void> startScan() async {}

  /// Stream de identificadores/valores leídos (placeholder vacío).
  Stream<String> get tagStream => const Stream<String>.empty();
}
