/// Datos mock para previsualizar UI sin backend real.
/// Útil para desarrollo y testing visual.
import 'package:cestaria/models/product.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/models/cart_item.dart';

class MockData {
  static final products = [
    const Product(
      id: '3017620422003', // Código de barras real de Nutella
      name: 'Nutella Crema de Cacao con Avellanas',
      brand: 'Ferrero',
      quantity: '400 g',
      price: 3.95,
      imageUrl: 'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_es.180.400.jpg',
      nutriScore: 'E',
      nutrition: {
        'energy-kcal_100g': 539.0,
        'proteins_100g': 6.3,
        'carbohydrates_100g': 57.5,
        'fat_100g': 30.9,
        'sugars_100g': 56.3,
        'salt_100g': 0.107,
        'serving_size': '15 g',
      },
    ),
    const Product(
      id: '5449000000996', // Código de barras de Coca-Cola
      name: 'Coca-Cola',
      brand: 'Coca-Cola',
      quantity: '2 L',
      price: 2.50,
      imageUrl: 'https://images.openfoodfacts.org/images/products/544/900/000/0996/front_es.188.400.jpg',
      nutriScore: 'E',
      nutrition: {
        'energy-kcal_100g': 42.0,
        'proteins_100g': 0.0,
        'carbohydrates_100g': 10.6,
        'fat_100g': 0.0,
        'sugars_100g': 10.6,
        'salt_100g': 0.0,
        'serving_size': '250 ml',
      },
    ),
    const Product(
      id: '8410076470959',
      name: 'Leche entera Hacendado',
      brand: 'Hacendado',
      quantity: '1 L',
      price: 0.95,
      imageUrl: 'https://prod-mercadona.imgix.net/images/4f1e86baa4cdcaa42396e45d7a07b72f.jpg?fit=crop&h=300&w=300',
      nutriScore: 'B',
      nutrition: {
        'energy-kcal_100g': 64.0,
        'proteins_100g': 3.2,
        'carbohydrates_100g': 4.7,
        'fat_100g': 3.6,
        'sugars_100g': 4.7,
        'salt_100g': 0.13,
        'serving_size': '250 ml',
      },
    ),
    const Product(
      id: '8480000571847',
      name: 'Pan de molde integral Hacendado',
      brand: 'Hacendado',
      quantity: '450 g',
      price: 1.20,
      imageUrl: 'https://prod-mercadona.imgix.net/images/25ba9b5df01c7a26b1e8f65eeb01cc9a.jpg?fit=crop&h=300&w=300',
      nutriScore: 'B',
      nutrition: {
        'energy-kcal_100g': 237.0,
        'proteins_100g': 9.5,
        'carbohydrates_100g': 38.0,
        'fat_100g': 4.2,
        'sugars_100g': 3.5,
        'salt_100g': 1.1,
        'fiber_100g': 6.5,
        'serving_size': '50 g',
      },
    ),
    const Product(
      id: '8480000573544',
      name: 'Aceite de oliva virgen extra Hacendado',
      brand: 'Hacendado',
      quantity: '1 L',
      price: 5.50,
      imageUrl: 'https://prod-mercadona.imgix.net/images/c6e6ef95ab34aad2f64e7c3e6e4b5f43.jpg?fit=crop&h=300&w=300',
      nutriScore: 'C',
      nutrition: {
        'energy-kcal_100g': 899.0,
        'proteins_100g': 0.0,
        'carbohydrates_100g': 0.0,
        'fat_100g': 99.9,
        'saturated-fat_100g': 14.0,
        'salt_100g': 0.0,
        'serving_size': '10 ml',
      },
    ),
    const Product(
      id: '8480000570758',
      name: 'Yogur natural Hacendado',
      brand: 'Hacendado',
      quantity: '4 x 125 g',
      price: 0.75,
      imageUrl: 'https://prod-mercadona.imgix.net/images/f3e8f5c7b2a4d9e1c8b6a3f5e2d1c9b8.jpg?fit=crop&h=300&w=300',
      nutriScore: 'A',
      nutrition: {
        'energy-kcal_100g': 63.0,
        'proteins_100g': 4.3,
        'carbohydrates_100g': 5.6,
        'fat_100g': 2.7,
        'sugars_100g': 5.6,
        'calcium_100g': 0.15,
        'salt_100g': 0.13,
        'serving_size': '125 g',
      },
    ),
  ];

  static final cartItems = [
    CartItem(
      productId: products[0].id, // Nutella
      name: products[0].name,
      quantity: 2,
      unitPrice: products[0].price,
      unit: 'ud',
    ),
    CartItem(
      productId: products[1].id, // Coca-Cola
      name: products[1].name,
      quantity: 1,
      unitPrice: products[1].price,
      unit: 'ud',
    ),
    CartItem(
      productId: products[2].id, // Leche
      name: products[2].name,
      quantity: 2,
      unitPrice: products[2].price,
      unit: 'ud',
    ),
    CartItem(
      productId: products[3].id, // Pan integral
      name: products[3].name,
      quantity: 1,
      unitPrice: products[3].price,
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
        productId: products[4].id, // Aceite de oliva
        name: products[4].name,
        quantity: 1,
        unitPrice: products[4].price,
        unit: 'ud',
      ),
      CartItem(
        productId: products[5].id, // Yogur
        name: products[5].name,
        quantity: 3,
        unitPrice: products[5].price,
        unit: 'ud',
      ),
      CartItem(
        productId: products[2].id, // Leche
        name: products[2].name,
        quantity: 4,
        unitPrice: products[2].price,
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
          quantity: 1,
          unitPrice: products[0].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[3].id,
          name: products[3].name,
          quantity: 2,
          unitPrice: products[3].price,
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
          productId: products[1].id,
          name: products[1].name,
          quantity: 2,
          unitPrice: products[1].price,
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
          productId: products[2].id,
          name: products[2].name,
          quantity: 3,
          unitPrice: products[2].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[5].id,
          name: products[5].name,
          quantity: 4,
          unitPrice: products[5].price,
          unit: 'ud',
        ),
        CartItem(
          productId: products[3].id,
          name: products[3].name,
          quantity: 2,
          unitPrice: products[3].price,
          unit: 'ud',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];
}
