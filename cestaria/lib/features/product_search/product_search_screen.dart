import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_search_provider.dart';
import 'product_cache_provider.dart';
import 'barcode_scanner_screen.dart';
import 'package:cestaria/models/product.dart';
import 'package:cestaria/models/cart_item.dart';
import 'package:cestaria/features/cart/cart_provider.dart';
import 'package:cestaria/features/shared_cart/shared_cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cestaria/core/widgets/nutriscore_badge.dart';
import 'package:cestaria/features/product_detail/product_detail_screen.dart';

/// Stateless screen using Riverpod inside a Consumer for state access.
class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar productos'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(productSearchProvider);
              final count = state.maybeWhen(data: (items) => items.length, orElse: () => null);
              return count == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
            },
          ),
          Consumer(
            builder: (context, ref, _) => IconButton(
              tooltip: 'Escanear código de barras',
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () async {
                // Navegar a la pantalla de escaneo
                final code = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerScreen(),
                  ),
                );
                
                if (code != null && code.trim().isNotEmpty && context.mounted) {
                  // Buscar el producto por código de barras
                  await ref.read(productSearchProvider.notifier).searchByBarcode(code.trim());
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Buscando producto con código: $code'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, _) => TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre o código de barras',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (q) => ref.read(productSearchProvider.notifier).search(q),
                onChanged: (q) => ref.read(productSearchProvider.notifier).onQueryChanged(q),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final results = ref.watch(productSearchProvider);
                  return results.when(
                    data: (items) => _ResultsList(items: items, ref: ref),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/nfc'),
        icon: const Icon(Icons.nfc),
        label: const Text('Escanear NFC'),
        tooltip: 'Escanear tag NFC',
      ),
    );
  }
}

Future<String?> _promptBarcode(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Introducir código de barras'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'EAN/Barcode'),
        keyboardType: TextInputType.number,
        autofocus: true,
        onSubmitted: (_) => Navigator.of(ctx).pop(controller.text),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: const Text('Buscar')),
      ],
    ),
  );
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.items, required this.ref});
  final List<Product> items;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Sin resultados'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = items[i];
        final isMercadona = p.brand == 'Mercadona';
        
        return ListTile(
          onTap: () {
            // Navegar a la pantalla de detalle del producto
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: p),
              ),
            );
          },
          leading: p.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    p.imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_outlined, size: 40),
                  ),
                )
              : const Icon(Icons.fastfood_outlined, size: 40),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (p.nutriScore != null) ...[
                const SizedBox(width: 8),
                NutriScoreBadge(
                  grade: p.nutriScore!,
                  size: NutriScoreSize.small,
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (p.brand != null)
                Text(
                  p.brand!,
                  style: TextStyle(
                    color: isMercadona ? Colors.green[700] : null,
                    fontWeight: isMercadona ? FontWeight.w600 : null,
                  ),
                ),
              if (p.quantity != null)
                Text(
                  p.quantity!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              Text(
                p.price != null ? '${p.price!.toStringAsFixed(2)} €' : 'Sin precio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: p.price != null ? FontWeight.bold : FontWeight.normal,
                  color: p.price != null ? Colors.green[700] : Colors.grey[600],
                  fontStyle: p.price == null ? FontStyle.italic : null,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.add_shopping_cart),
            tooltip: 'Añadir al carrito',
            onSelected: (value) {
              if (value == 'local') {
                _addToCart(context, p, isShared: false);
              } else if (value == 'shared') {
                _addToCart(context, p, isShared: true);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'local',
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text('Mi carrito'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'shared',
                child: Row(
                  children: [
                    Icon(Icons.people, size: 20),
                    SizedBox(width: 8),
                    Text('Carrito compartido'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, Product product, {required bool isShared}) {
    // Guardar producto en cache para mantener información nutricional
    ref.read(productCacheProvider.notifier).addProduct(product);
    
    // Crear CartItem desde Product
    final cartItem = CartItem(
      productId: product.id,
      name: product.name,
      quantity: 1.0,
      unit: product.quantity,
      unitPrice: product.price ?? 0.0,
      isChecked: false,
    );

    // Añadir al carrito correspondiente
    if (isShared) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      ref.read(sharedCartProvider.notifier).addItem(cartItem, userId);
    } else {
      ref.read(cartProvider.notifier).addItem(cartItem);
    }

    // Mostrar popup animado con confirmación
    _showAddedToCartPopup(context, product, cartItem, isShared);
  }

  void _showAddedToCartPopup(BuildContext context, Product product, CartItem cartItem, bool isShared) {
    // Dialog animado con confirmación visual
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
                // Ícono de éxito animado
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isShared ? Icons.people : Icons.check_circle,
                    color: Colors.green[700],
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Título
                Text(
                  isShared ? '¡Añadido al carrito compartido!' : '¡Añadido al carrito!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Información del producto
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
                          errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_outlined, size: 50),
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
                          if (product.quantity != null)
                            Text(
                              product.quantity!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).removeItem(cartItem.productId);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Producto eliminado del carrito'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Deshacer'),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Aceptar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // Cerrar automáticamente después de 3 segundos si no hay interacción
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}
