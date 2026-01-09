# LocalDatabase - Guía de Uso

## Implementado

Base de datos SQLite completa con:

### Tablas
1. **products** - Caché de productos consultados
2. **carts** - Carritos locales y borradores
3. **cart_items** - Items de cada carrito
4. **purchase_history** - Historial de compras

### Funcionalidades

#### Productos (Caché)
```dart
final db = LocalDatabase();

// Cachear un producto
await db.cacheProduct(product);

// Obtener producto del caché
final cachedProduct = await db.getCachedProduct('8410000012345');

// Buscar productos en caché
final results = await db.searchCachedProducts('leche');

// Limpiar caché antiguo (>30 días)
await db.clearOldCache();
```

#### Carritos
```dart
// Guardar carrito localmente
await db.saveCart(cart);

// Obtener carrito por ID
final cart = await db.getCart('cart-123');

// Listar todos los carritos
final carts = await db.getAllCarts();

// Incluir archivados
final allCarts = await db.getAllCarts(includeArchived: true);

// Archivar carrito
await db.archiveCart('cart-123');

// Eliminar carrito
await db.deleteCart('cart-123');
```

#### Historial
```dart
// Guardar compra en historial
await db.savePurchaseHistory(cart);

// Obtener historial completo
final history = await db.getPurchaseHistory(limit: 100);

// Filtrar por tienda
final mercadonaHistory = await db.getPurchaseHistory(
  store: 'Mercadona',
  limit: 50,
);

// Filtrar por fecha
final recentHistory = await db.getPurchaseHistory(
  since: DateTime.now().subtract(Duration(days: 30)),
);

// Productos comprados frecuentemente
final frequent = await db.getFrequentlyPurchasedProducts(
  limit: 10,
  daysBack: 90,
);
```

#### Estadísticas
```dart
// Obtener estadísticas de uso
final stats = await db.getStats();
// {'products': 150, 'carts': 5, 'history': 2500}
```

## Casos de Uso

### 1. **Modo Offline**
Cuando no hay internet, la app puede:
- Buscar productos en caché
- Crear y editar carritos localmente
- Consultar historial de compras

### 2. **Sincronización**
Cuando se recupera la conexión:
- Subir carritos locales a Firestore
- Actualizar caché de productos
- Marcar carritos como sincronizados

### 3. **Rendimiento**
- Búsqueda rápida sin red
- Sugerencias de productos frecuentes
- Historial de compras instantáneo

## Integración con Providers

### CartRepository
```dart
class CartRepository {
  final FirestoreService _firestore = FirestoreService();
  final LocalDatabase _localDb = LocalDatabase();

  Future<Cart?> getCart(String cartId) async {
    try {
      // Intentar desde Firestore
      return await _firestore.getCart(cartId);
    } catch (e) {
      // Si falla, usar caché local
      return await _localDb.getCart(cartId);
    }
  }

  Future<void> saveCart(Cart cart) async {
    // Guardar localmente primero
    await _localDb.saveCart(cart);
    
    try {
      // Intentar sincronizar con Firestore
      await _firestore.saveCart(cart);
    } catch (e) {
      debugPrint('Sin conexión, guardado solo localmente');
    }
  }
}
```

### ProductSearchRepository
```dart
class ProductSearchRepository {
  final MercadonaApi _api = MercadonaApi();
  final LocalDatabase _localDb = LocalDatabase();

  Future<Product?> searchByBarcode(String barcode) async {
    // 1. Buscar en caché local
    final cached = await _localDb.getCachedProduct(barcode);
    if (cached != null) {
      debugPrint('Producto encontrado en caché');
      return cached;
    }

    // 2. Buscar en API
    try {
      final product = await _api.searchByBarcode(barcode);
      if (product != null) {
        // Cachear para próxima vez
        await _localDb.cacheProduct(product);
      }
      return product;
    } catch (e) {
      return null;
    }
  }
}
```

## Inicialización

Inicializar en el `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar base de datos
  final db = LocalDatabase();
  await db.database; // Fuerza inicialización
  
  // Limpiar caché antiguo
  await db.clearOldCache();
  
  runApp(MyApp());
}
```

## Migraciones Futuras

Para añadir campos en versiones futuras, actualizar `_onUpgrade`:

```dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE products ADD COLUMN allergens TEXT');
  }
  if (oldVersion < 3) {
    await db.execute('ALTER TABLE carts ADD COLUMN budget REAL');
  }
}
```

##  Testing

```dart
// Resetear base de datos en tests
await LocalDatabase().deleteDatabase();
```
