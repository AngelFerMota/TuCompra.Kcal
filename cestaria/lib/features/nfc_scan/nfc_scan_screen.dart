import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'package:cestaria/features/product_search/product_search_repository.dart';
import 'package:cestaria/features/product_search/product_cache_provider.dart';
import 'package:cestaria/features/cart/cart_provider.dart';
import 'package:cestaria/models/product.dart';
import 'package:cestaria/models/cart_item.dart';

/// Pantalla para escanear productos usando NFC.
/// 
/// Permite acercar el móvil a tags NFC para leer códigos de barras o IDs,
/// buscar el producto y añadirlo automáticamente al carrito.
class NfcScanScreen extends ConsumerStatefulWidget {
  const NfcScanScreen({super.key});

  @override
  ConsumerState<NfcScanScreen> createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends ConsumerState<NfcScanScreen> {
  bool _isNfcAvailable = false;
  bool _isScanning = false;
  String? _lastScannedData;
  Product? _lastProduct;

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
    _listenToNfcTags();
  }

  Future<void> _checkNfcAvailability() async {
    final nfcService = ref.read(nfcServiceProvider);
    final available = await nfcService.initialize();
    if (mounted) {
      setState(() {
        _isNfcAvailable = available;
      });
    }
  }

  void _listenToNfcTags() {
    final nfcService = ref.read(nfcServiceProvider);
    nfcService.tagStream.listen((data) {
      setState(() {
        _lastScannedData = data;
        _isScanning = false;
      });
      _searchAndAddProduct(data);
    });
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _lastScannedData = null;
      _lastProduct = null;
    });

    final nfcService = ref.read(nfcServiceProvider);
    await nfcService.startScan();
  }

  Future<void> _searchAndAddProduct(String code) async {
    try {
      // Buscar producto por código de barras
      final repository = ref.read(productSearchRepositoryProvider);
      final product = await repository.getByBarcode(code);

      if (product != null && mounted) {
        setState(() {
          _lastProduct = product;
        });

        // Guardar producto en cache para mantener información nutricional
        ref.read(productCacheProvider.notifier).addProduct(product);

        // Añadir automáticamente al carrito
        final cartItem = CartItem(
          productId: product.id,
          name: product.name,
          quantity: 1.0,
          unit: product.quantity,
          unitPrice: product.price ?? 0.0,
          isChecked: false,
        );

        ref.read(cartProvider.notifier).addItem(cartItem);

        // Mostrar confirmación
        if (mounted) {
          _showProductAddedDialog(product);
        }
      } else {
        if (mounted) {
          _showErrorDialog('Producto no encontrado con código: $code');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error al buscar producto: $e');
      }
    }
  }

  void _showProductAddedDialog(Product product) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.nfc,
                    color: Colors.green[700],
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Producto escaneado!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (product.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.fastfood_outlined, size: 50),
                        ),
                      )
                    else
                      const Icon(Icons.fastfood_outlined, size: 50),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (product.price != null)
                            Text(
                              '${product.price!.toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear NFC'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isNfcAvailable)
                Column(
                  children: [
                    Icon(
                      Icons.nfc_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NFC no disponible',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este dispositivo no tiene NFC o está desactivado',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Abrir configuración del sistema (platform específico)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Activa NFC en Ajustes > Conexiones > NFC',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Cómo activar NFC'),
                    ),
                  ],
                )
              else ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isScanning ? Colors.blue[50] : Colors.grey[100],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isScanning ? Colors.blue : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.nfc,
                    size: 100,
                    color: _isScanning ? Colors.blue : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  _isScanning
                      ? 'Acerca tu dispositivo al tag NFC...'
                      : 'Toca el botón para comenzar',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!_isScanning)
                  FilledButton.icon(
                    onPressed: _startScan,
                    icon: const Icon(Icons.nfc),
                    label: const Text('Escanear tag NFC'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      final nfcService = ref.read(nfcServiceProvider);
                      await nfcService.stopScan();
                      setState(() {
                        _isScanning = false;
                      });
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                if (_lastScannedData != null) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Último escaneo:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastScannedData!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
                if (_lastProduct != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: _lastProduct!.imageUrl != null
                          ? Image.network(
                              _lastProduct!.imageUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.fastfood_outlined),
                      title: Text(_lastProduct!.name),
                      subtitle: Text(_lastProduct!.brand ?? ''),
                      trailing: Icon(Icons.check_circle, color: Colors.green[700]),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final nfcService = ref.read(nfcServiceProvider);
    nfcService.stopScan();
    super.dispose();
  }
}
