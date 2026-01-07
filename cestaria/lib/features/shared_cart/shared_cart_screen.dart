import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shared_cart_provider.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';
import 'package:cestaria/features/product_search/product_cache_provider.dart';

class SharedCartScreen extends StatefulWidget {
  const SharedCartScreen({super.key});

  @override
  State<SharedCartScreen> createState() => _SharedCartScreenState();
}

class _SharedCartScreenState extends State<SharedCartScreen> {
  final Set<String> _selectedProducts = {};
  bool _isSelectionMode = false;

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedProducts.clear();
      }
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartIdController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedProducts.length} seleccionado${_selectedProducts.length != 1 ? 's' : ''}')
            : const Text('Carrito compartido'),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
        actions: [
          if (_isSelectionMode) ...[
            if (_selectedProducts.isNotEmpty)
              Consumer(
                builder: (context, ref, _) => IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Eliminar seleccionados',
                  onPressed: () {
                    final count = _selectedProducts.length;
                    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                    for (final productId in _selectedProducts.toList()) {
                      ref.read(sharedCartProvider.notifier).removeItem(
                        productId,
                        userId,
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$count producto${count > 1 ? 's eliminados' : ' eliminado'}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      _selectedProducts.clear();
                      _isSelectionMode = false;
                    });
                  },
                ),
              ),
          ] else
            Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(sharedCartProvider);
                final canSave = state is AsyncData<Cart>;
                final hasItems = canSave && state.value.items.isNotEmpty;
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasItems)
                      IconButton(
                        icon: const Icon(Icons.checklist),
                        tooltip: 'Seleccionar múltiples',
                        onPressed: _toggleSelectionMode,
                      ),
                    IconButton(
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
                    ),
                  ],
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
                    data: (cart) => _CartDetails(
                      cart: cart,
                      selectedProducts: _selectedProducts,
                      isSelectionMode: _isSelectionMode,
                      onToggleSelection: _toggleProductSelection,
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        tooltip: 'Añadir producto',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController();
    final unitController = TextEditingController(text: 'ud');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  hintText: 'Ej: Leche entera',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidad',
                        hintText: 'ud, kg, L',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio unitario (€)',
                  hintText: 'Ej: 1.50',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          Consumer(
            builder: (context, ref, _) => FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El nombre es obligatorio')),
                  );
                  return;
                }

                final quantity = double.tryParse(quantityController.text) ?? 1.0;
                final price = double.tryParse(priceController.text);
                final unit = unitController.text.trim().isEmpty ? 'ud' : unitController.text.trim();

                final newItem = CartItem(
                  productId: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  quantity: quantity,
                  unit: unit,
                  unitPrice: price,
                );

                final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                ref.read(sharedCartProvider.notifier).addItem(newItem, userId);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name añadido al carrito')),
                );
              },
              child: const Text('Añadir'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartDetails extends ConsumerWidget {
  const _CartDetails({
    required this.cart,
    required this.selectedProducts,
    required this.isSelectionMode,
    required this.onToggleSelection,
  });
  
  final Cart cart;
  final Set<String> selectedProducts;
  final bool isSelectionMode;
  final Function(String) onToggleSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double total = 0;
    for (final item in cart.items) {
      total += (item.unitPrice ?? 0) * item.quantity;
    }

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('ID: ${cart.id}'),
                Text('Propietario: ${cart.ownerId}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.group, size: 16),
                    const SizedBox(width: 4),
                    Text('${cart.participantIds.length} participantes'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Productos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (cart.items.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Sin productos', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...cart.items.map((item) {
            final subtotal = (item.unitPrice ?? 0) * item.quantity;
            final product = ref.read(productCacheProvider)[item.productId];
            
            return Dismissible(
              key: Key(item.productId),
              direction: isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                ref.read(sharedCartProvider.notifier).removeItem(
                  item.productId,
                  userId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${item.name}" eliminado del carrito'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'DESHACER',
                      onPressed: () {
                        // TODO: Implementar undo
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                onTap: isSelectionMode ? () => onToggleSelection(item.productId) : null,
                selected: selectedProducts.contains(item.productId),
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelectionMode)
                      Checkbox(
                        value: selectedProducts.contains(item.productId),
                        onChanged: (_) => onToggleSelection(item.productId),
                      )
                    else
                      Checkbox(
                        value: item.isChecked,
                        onChanged: (_) {
                          ref.read(sharedCartProvider.notifier).toggleChecked(item.productId);
                        },
                      ),
                    if (product?.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          product!.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.fastfood_outlined, size: 32),
                        ),
                      )
                    else
                      const Icon(Icons.fastfood_outlined, size: 32),
                  ],
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                          color: item.isPurchased ? Colors.grey : null,
                        ),
                      ),
                    ),
                    if (item.isPurchased)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Comprado',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.quantity.toStringAsFixed(0)} ${item.unit ?? 'ud'} × ${item.unitPrice != null && item.unitPrice! > 0 ? '${item.unitPrice!.toStringAsFixed(2)} €' : 'Sin precio'}',
                    ),
                    if (item.isPurchased && item.purchasedBy != null)
                      Text(
                        'Por: ${item.purchasedBy}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!item.isPurchased)
                      IconButton(
                        icon: Icon(Icons.shopping_bag, color: Colors.green[700]),
                        tooltip: 'Marcar como comprado',
                        onPressed: () {
                          final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                          ref.read(sharedCartProvider.notifier).markAsPurchased(
                            item.productId,
                            userId,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('[COMPRADO] "${item.name}" marcado como comprado'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    const SizedBox(width: 8),
                    Text(
                      subtotal > 0 ? '${subtotal.toStringAsFixed(2)} €' : 'Sin precio',
                      style: TextStyle(
                        fontWeight: subtotal > 0 ? FontWeight.bold : FontWeight.normal,
                        color: item.isPurchased ? Colors.grey : null,
                        fontStyle: subtotal == 0 ? FontStyle.italic : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
