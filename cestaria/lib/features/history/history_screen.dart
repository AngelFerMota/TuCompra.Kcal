import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: Consumer(
        builder: (context, ref, _) {
          final history = ref.watch(historyProvider);
          return history.when(
            data: (carts) => ListView.builder(
              itemCount: carts.length,
              itemBuilder: (_, i) => const ListTile(
                title: Text('Carrito archivado'),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
      ),
    );
  }
}
