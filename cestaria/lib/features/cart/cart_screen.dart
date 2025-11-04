import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: Consumer(
        builder: (context, ref, _) {
          final _ = ref.watch(cartProvider); // watch state; avoid field access before codegen
          return const Center(
            child: Text('Carrito listo (placeholder)'),
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) => FloatingActionButton(
          onPressed: () {
            // Example: ref.read(cartProvider.notifier).clear();
          },
          child: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}
