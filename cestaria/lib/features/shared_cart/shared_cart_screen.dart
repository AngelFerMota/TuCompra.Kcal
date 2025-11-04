import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_cart_provider.dart';
import 'package:cestaria/models/cart.dart';

class SharedCartScreen extends StatelessWidget {
  const SharedCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartIdController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito compartido'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(sharedCartProvider);
              final canSave = state is AsyncData<Cart>;
              return IconButton(
                tooltip: 'Guardar carrito',
                onPressed: canSave
                    ? () async {
                        final cart = state.value;
                        await ref.read(sharedCartProvider.notifier).save(cart);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Carrito guardado (placeholder)')),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cartIdController,
                    decoration: const InputDecoration(
                      hintText: 'ID del carrito (Firestore doc id)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, _) => FilledButton(
                    onPressed: () async {
                      final id = cartIdController.text.trim();
                      if (id.isEmpty) return;
                      await ref.read(sharedCartProvider.notifier).subscribe(id);
                    },
                    child: const Text('Suscribirse'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final asyncCart = ref.watch(sharedCartProvider);
                  return asyncCart.when(
                    data: (cart) => _CartDetails(cart: cart),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartDetails extends StatelessWidget {
  const _CartDetails({required this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(cart.name),
          subtitle: Text('ID: ${cart.id} • Owner: ${cart.ownerId}'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.group_outlined),
          title: const Text('Participantes'),
          subtitle: Text(cart.participantIds.join(', ')),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shopping_basket_outlined),
          title: const Text('Items'),
          subtitle: Text('Total: ${cart.items.length}'),
        ),
      ],
    );
  }
}
