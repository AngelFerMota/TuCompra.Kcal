import 'package:flutter/material.dart';
import '../../models/cart.dart';
import 'pdf_export.dart';
import 'csv_export.dart';

/// Export utilities (PDF & CSV) for carts/history
class ExportUtils {
  /// Muestra un diálogo para elegir formato de exportación
  static Future<void> showExportDialog(BuildContext context, Cart cart) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar carrito'),
        content: const Text('Elige el formato de exportación:'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await PdfExportUtils.showPdfPreview(cart);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al exportar PDF: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.table_chart),
            label: const Text('CSV'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await CsvExportUtils.shareCsv(cart);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('CSV exportado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al exportar CSV: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  /// Exporta directamente a PDF
  static Future<void> exportToPdf(Cart cart) async {
    await PdfExportUtils.sharePdf(cart);
  }

  /// Exporta directamente a CSV
  static Future<void> exportToCsv(Cart cart) async {
    await CsvExportUtils.shareCsv(cart);
  }
}
