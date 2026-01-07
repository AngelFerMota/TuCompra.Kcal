import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_provider.dart';
import 'package:cestaria/core/utils/mock_data.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(historyProvider.notifier).load();
            },
          ),
        ],
      ),
      body: history.when(
        data: (carts) {
          if (carts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Sin carritos archivados',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: carts.length,
            itemBuilder: (context, index) {
              final cart = carts[index];
              final itemCount = cart.items.length;
              double total = 0;
              for (final item in cart.items) {
                total += (item.unitPrice ?? 0) * item.quantity;
              }
              
              final dateStr = _formatDate(cart.createdAt);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: Text(
                    cart.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('$dateStr • $itemCount productos • ${total.toStringAsFixed(2)} €'),
                  children: [
                    ...cart.items.map((item) {
                      final subtotal = (item.unitPrice ?? 0) * item.quantity;
                      final product = MockData.products.where((p) => p.id == item.productId).firstOrNull;
                      
                      return ListTile(
                        dense: true,
                        leading: product?.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  product!.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_outlined, size: 32),
                                ),
                              )
                            : const Icon(Icons.fastfood_outlined, size: 32),
                        title: Text(item.name),
                        subtitle: Text(
                          '${item.quantity.toStringAsFixed(0)} ${item.unit ?? 'ud'} × ${item.unitPrice?.toStringAsFixed(2) ?? '?'} €',
                        ),
                        trailing: Text(
                          '${subtotal.toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // TODO: restaurar carrito
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Restaurar carrito (TODO)')),
                              );
                            },
                            icon: const Icon(Icons.restore),
                            label: const Text('Restaurar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e'),
            ],
          ),
        ),
      ),
    );
  }
}
