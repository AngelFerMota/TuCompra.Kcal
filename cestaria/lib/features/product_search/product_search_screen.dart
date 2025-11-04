import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_search_provider.dart';
import 'package:cestaria/models/product.dart';

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
              tooltip: 'Buscar por código de barras',
              icon: const Icon(Icons.qr_code_scanner_outlined),
              onPressed: () async {
                final code = await _promptBarcode(context);
                if (code != null && code.trim().isNotEmpty && context.mounted) {
                  await ref.read(productSearchProvider.notifier).searchByBarcode(code.trim());
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
                    data: (items) => _ResultsList(items: items),
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
  const _ResultsList({required this.items});
  final List<Product> items;

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
        return ListTile(
          leading: p.imageUrl != null
              ? Image.network(p.imageUrl!, width: 48, height: 48, fit: BoxFit.cover)
              : const Icon(Icons.fastfood_outlined),
          title: Text(p.name),
          subtitle: Text(p.brand ?? ''),
        );
      },
    );
  }
}
