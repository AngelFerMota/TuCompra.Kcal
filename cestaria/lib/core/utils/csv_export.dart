/// Utilidades para exportar a CSV (compatibles con Excel/Sheets).
///
/// Paquetes útiles:
/// - `csv` para generar/parsear CSV
/// - `file_saver` o `path_provider` + IO para guardar localmente
/// - `share_plus` para compartir el archivo
///
/// Recomendaciones:
/// - Definir separador y codificación (UTF-8 con BOM si lo requiere Excel)
/// - Escapar comillas y comas correctamente
/// - Incluir cabeceras y filas con items del carrito/historial
///
/// No implementar lógica aquí; añade funciones cuando toque.
class CsvExportUtils {
  // Ej.: Future<String> buildCartCsv(Cart cart);
}