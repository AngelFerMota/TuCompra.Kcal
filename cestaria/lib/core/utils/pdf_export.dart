import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../models/cart.dart';

/// Utilidades para exportar carritos/historial a PDF
class PdfExportUtils {
  static final _currencyFormat = NumberFormat.currency(symbol: '€', decimalDigits: 2);
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  /// Genera un PDF del carrito
  static Future<Uint8List> buildCartPdf(Cart cart) async {
    final pdf = pw.Document();
    
    // Calcular totales
    final totalPrice = cart.items.fold<double>(
      0.0,
      (sum, item) => sum + ((item.unitPrice ?? 0) * item.quantity),
    );
    
    final totalUnits = cart.items.fold<double>(
      0.0,
      (sum, item) => sum + item.quantity,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Cabecera
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Cestaria',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Lista de la compra',
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      cart.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _dateFormat.format(DateTime.now()),
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 20),
          
          // Tabla de productos
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Cabecera de tabla
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableHeader('Producto'),
                  _buildTableHeader('Cant.'),
                  _buildTableHeader('Unidad'),
                  _buildTableHeader('Precio'),
                  _buildTableHeader('Subtotal'),
                ],
              ),
              // Filas de productos
              ...cart.items.map((item) {
                final subtotal = (item.unitPrice ?? 0) * item.quantity;
                return pw.TableRow(
                  children: [
                    _buildTableCell(item.name),
                    _buildTableCell('${item.quantity}'),
                    _buildTableCell(item.unit ?? ''),
                    _buildTableCell(_currencyFormat.format(item.unitPrice ?? 0)),
                    _buildTableCell(_currencyFormat.format(subtotal)),
                  ],
                );
              }),
            ],
          ),
          
          pw.SizedBox(height: 20),
          
          // Resumen de totales
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _buildTotalRow('Total de productos:', '${cart.items.length}'),
                pw.SizedBox(height: 8),
                _buildTotalRow('Total unidades:', '${totalUnits.toStringAsFixed(0)}'),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOTAL:',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      _currencyFormat.format(totalPrice),
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Pie de página
          pw.Center(
            child: pw.Text(
              'Generado con Cestaria - Tu lista de la compra inteligente',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label),
        pw.Text(
          value,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  /// Previsualiza y comparte el PDF
  static Future<void> showPdfPreview(Cart cart) async {
    await Printing.layoutPdf(
      onLayout: (format) => buildCartPdf(cart),
    );
  }

  /// Comparte el PDF directamente
  static Future<void> sharePdf(Cart cart) async {
    final pdfData = await buildCartPdf(cart);
    await Printing.sharePdf(
      bytes: pdfData,
      filename: 'cestaria_${cart.name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
