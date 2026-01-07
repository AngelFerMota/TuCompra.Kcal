/// Datos mock para previsualizar UI sin backend real.
/// Útil para desarrollo y testing visual.
import 'package:cestaria/models/product.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';

class MockData {
  static final products = [
    const Product(
      id: '17410',
      name: 'Salsa fresca Trufa Hacendado',
      brand: 'Mercadona',
      quantity: '140 g',
      price: 1.55,
      imageUrl: 'https://prod-mercadona.imgix.net/images/912baa300a06ed9f81d714338bda0d1d.jpg?fit=crop&h=300&w=300',
      nutriScore: 'C',
    ),
    const Product(
      id: '17409',
      name: 'Salsa fresca Queso Hacendado',
      brand: 'Mercadona',
      quantity: '180 g',
      price: 1.55,
      imageUrl: 'https://prod-mercadona.imgix.net/images/1e524f23891de8f06943ee50efcca5eb.jpg?fit=crop&h=300&w=300',
      nutriScore: 'B',
    ),
    const Product(
      id: '35186',
      name: 'Salsa fresca Pesto con albahaca Hacendado',
      brand: 'Mercadona',
      quantity: '150 g',
      price: 2.00,
      imageUrl: 'https://prod-mercadona.imgix.net/images/5f6f165b0afc47923dc34742a306ecdc.jpg?fit=crop&h=300&w=300',
      nutriScore: 'B',
    ),
    const Product(
      id: '7972',
      name: 'Salsa fresca Setas Hacendado',
      brand: 'Mercadona',
      quantity: '200 g',
      price: 1.55,
      imageUrl: 'https://prod-mercadona.imgix.net/images/98bdb6f997e29c2951aceb6e920e5515.jpg?fit=crop&h=300&w=300',
      nutriScore: 'C',
    ),
    const Product(
      id: '35183',
      name: 'Salsa fresca Carbonara Hacendado',
      brand: 'Mercadona',
      quantity: '200 g',
      price: 1.55,
      imageUrl: 'https://prod-mercadona.imgix.net/images/1a7017e1e7d2aef9f914dbbfbf0cddeb.jpg?fit=crop&h=300&w=300',
      nutriScore: 'D',
    ),
  ];

  static final cartItems = [
    CartItem(
      productId: products[0].id,
      name: products[0].name,
      quantity: 2,
      unitPrice: products[0].price,
      unit: 'ud',
    ),
    CartItem(
      productId: products[1].id,
      name: products[1].name,
      quantity: 1,
      unitPrice: products[1].price,
      unit: 'ud',
    ),
    CartItem(
      productId: products[2].id,
      name: products[2].name,
      quantity: 3,
      unitPrice: products[2].price,
      unit: 'ud',
    ),
  ];

  static final localCart = Cart(
    id: 'local-cart-001',
    name: 'Mi Carrito',
    ownerId: 'user-local',
    items: cartItems,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    updatedAt: DateTime.now(),
  );

  static final sharedCart = Cart(
    id: 'shared-cart-familia',
    name: 'Compra Familia',
    ownerId: 'user-001',
    participantIds: ['user-001', 'user-002', 'user-003'],
    items: [
      CartItem(
        productId: products[3].id,
        name: products[3].name,
        quantity: 1,
        unitPrice: products[3].price,
        unit: 'ud',
      ),
      CartItem(
        productId: products[4].id,
        name: products[4].name,
        quantity: 2,
        unitPrice: products[4].price,
        unit: 'ud',
      ),
      CartItem(
        productId: products[0].id,
        name: products[0].name,
        quantity: 4,
        unitPrice: products[0].price,
        unit: 'ud',
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
  );

  static final archivedCarts = [
    Cart(
      id: 'archived-001',
      name: 'Compra Semanal 04/11',
      ownerId: 'user-local',
      items: [
        CartItem(
          productId: products[0].id,
          name: products[0].name,
          quantity: 3,
          unitPrice: products[0].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[2].id,
          name: products[2].name,
          quantity: 2,
          unitPrice: products[2].price,
          unit: 'ud',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Cart(
      id: 'archived-002',
      name: 'Compra Rápida 28/10',
      ownerId: 'user-local',
      items: [
        CartItem(
          productId: products[4].id,
          name: products[4].name,
          quantity: 1,
          unitPrice: products[4].price,
          unit: 'ud',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    Cart(
      id: 'archived-003',
      name: 'Compra Mensual Octubre',
      ownerId: 'user-local',
      items: [
        CartItem(
          productId: products[3].id,
          name: products[3].name,
          quantity: 2,
          unitPrice: products[3].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[1].id,
          name: products[1].name,
          quantity: 2,
          unitPrice: products[1].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[0].id,
          name: products[0].name,
          quantity: 5,
          unitPrice: products[0].price,
          unit: 'ud',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];
}
