import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../models/cart.dart';

/// Utilidades para exportar a CSV (compatibles con Excel/Sheets)
class CsvExportUtils {
  static final _currencyFormat = NumberFormat.currency(symbol: '€', decimalDigits: 2);
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  /// Genera CSV del carrito
  static String buildCartCsv(Cart cart) {
    final List<List<dynamic>> rows = [];
    
    // BOM para UTF-8 (para que Excel lo detecte correctamente)
    const String bom = '\uFEFF';
    
    // Cabecera del documento
    rows.add(['Cestaria - Lista de la compra']);
    rows.add(['Carrito:', cart.name]);
    rows.add(['Fecha:', _dateFormat.format(DateTime.now())]);
    rows.add([]); // Línea vacía
    
    // Cabecera de tabla
    rows.add([
      'Producto',
      'Cantidad',
      'Unidad',
      'Precio Unitario',
      'Subtotal',
      'Comprado',
      'Notas',
    ]);
    
    // Filas de productos
    for (final item in cart.items) {
      final subtotal = (item.unitPrice ?? 0) * item.quantity;
      rows.add([
        item.name,
        item.quantity,
        item.unit ?? '',
        _currencyFormat.format(item.unitPrice ?? 0),
        _currencyFormat.format(subtotal),
        item.isPurchased ? 'Sí' : 'No',
        item.notes ?? '',
      ]);
    }
    
    // Línea vacía antes de totales
    rows.add([]);
    
    // Totales
    final totalProducts = cart.items.length;
    final totalUnits = cart.items.fold<double>(0.0, (sum, item) => sum + item.quantity.toDouble());
    final totalPrice = cart.items.fold<double>(
      0.0,
      (sum, item) => sum + ((item.unitPrice ?? 0) * item.quantity),
    );
    
    rows.add(['RESUMEN']);
    rows.add(['Total de productos:', totalProducts]);
    rows.add(['Total de unidades:', totalUnits.toStringAsFixed(0)]);
    rows.add(['Total precio:', _currencyFormat.format(totalPrice)]);

    
    // Convertir a CSV
    final csvData = const ListToCsvConverter().convert(rows);
    
    return bom + csvData;
  }

  /// Guarda el CSV y lo comparte
  static Future<void> shareCsv(Cart cart) async {
    try {
      final csvString = buildCartCsv(cart);
      
      // Obtener directorio temporal
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/cestaria_${cart.name}_$timestamp.csv';
      
      // Guardar archivo
      final file = File(filePath);
      await file.writeAsString(csvString, encoding: utf8);
      
      // Compartir
      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'text/csv')],
        subject: 'Cestaria - ${cart.name}',
        text: 'Lista de la compra exportada desde Cestaria',
      );
    } catch (e) {
      throw Exception('Error al exportar CSV: $e');
    }
  }

  /// Guarda el CSV localmente
  static Future<File> saveCsvToFile(Cart cart, String filePath) async {
    final csvString = buildCartCsv(cart);
    final file = File(filePath);
    await file.writeAsString(csvString, encoding: utf8);
    return file;
  }
}