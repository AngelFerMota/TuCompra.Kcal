import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

/// NFC Service: encapsula lectura/escaneo de etiquetas NFC.
///
/// Usa `nfc_manager` para leer tags NFC y extraer códigos de barras/IDs.
/// Compatible con Android e iOS (requiere permisos y hardware NFC).
class NfcService {
  final _tagController = StreamController<String>.broadcast();
  bool _isScanning = false;

  /// Stream de identificadores/valores leídos desde tags NFC.
  Stream<String> get tagStream => _tagController.stream;

  /// Inicializa y verifica disponibilidad de NFC.
  Future<bool> initialize() async {
    try {
      final isAvailable = await NfcManager.instance.isAvailable();
      return isAvailable;
    } catch (e) {
      return false;
    }
  }

  /// Inicia un escaneo de tag NFC.
  /// 
  /// Lee el tag y extrae texto/identificador (NDEF, código de barras, etc.)
  /// Emite el resultado por el stream tagStream.
  Future<void> startScan() async {
    if (_isScanning) return;
    
    _isScanning = true;
    
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          // Intentar leer diferentes tipos de datos del tag
          String? data;

          // 1. Intentar leer NDEF (NFC Data Exchange Format)
          final ndef = Ndef.from(tag);
          if (ndef != null && ndef.cachedMessage != null) {
            for (final record in ndef.cachedMessage!.records) {
              // Decodificar payload como texto
              if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
                final payload = record.payload;
                if (payload.isNotEmpty) {
                  // Saltar primer byte (código de idioma) y convertir a String
                  final text = String.fromCharCodes(payload.skip(3));
                  data = text;
                  break;
                }
              }
            }
          }

          // 2-4. Usar identificador genérico del tag
          if (data == null) {
            // Intentar diferentes formas de obtener el ID del tag
            dynamic identifier = tag.data['nfca']?['identifier'] ??
                tag.data['nfcb']?['identifier'] ??
                tag.data['nfcf']?['identifier'] ??
                tag.data['nfcv']?['identifier'] ??
                tag.data['isodep']?['identifier'] ??
                tag.data['mifareclassic']?['identifier'] ??
                tag.data['mifareultralight']?['identifier'];

            if (identifier != null && identifier is List) {
              data = identifier
                  .map((e) => e.toRadixString(16).padLeft(2, '0'))
                  .join(':')
                  .toUpperCase();
            }
          }

          // Emitir el dato leído
          if (data != null && data.isNotEmpty) {
            _tagController.add(data);
          }

          // Detener sesión después de lectura exitosa
          await NfcManager.instance.stopSession();
          _isScanning = false;
        },
        onError: (error) async {
          _isScanning = false;
          await NfcManager.instance.stopSession(errorMessage: 'Error al leer NFC');
        },
      );
    } catch (e) {
      _isScanning = false;
      await NfcManager.instance.stopSession(errorMessage: 'Error: $e');
    }
  }

  /// Detiene el escaneo NFC actual.
  Future<void> stopScan() async {
    if (_isScanning) {
      await NfcManager.instance.stopSession();
      _isScanning = false;
    }
  }

  /// Escribe datos en un tag NFC (opcional, para funciones futuras).
  Future<bool> writeNdef(String text) async {
    bool success = false;

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            await NfcManager.instance.stopSession(
              errorMessage: 'Tag no es escribible',
            );
            return;
          }

          // Crear mensaje NDEF con el texto
          final message = NdefMessage([
            NdefRecord.createText(text),
          ]);

          try {
            await ndef.write(message);
            success = true;
            await NfcManager.instance.stopSession();
          } catch (e) {
            await NfcManager.instance.stopSession(
              errorMessage: 'Error al escribir: $e',
            );
          }
        },
      );
    } catch (e) {
      await NfcManager.instance.stopSession(errorMessage: 'Error: $e');
    }

    return success;
  }

  /// Liberar recursos.
  void dispose() {
    _tagController.close();
    stopScan();
  }
}
