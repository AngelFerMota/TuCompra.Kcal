import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/product.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';

/// Capa de persistencia local con SQLite
///
/// Maneja:
/// - Caché de productos consultados
/// - Carritos locales y borradores
/// - Historial de compras
/// - Sincronización offline
class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  /// Inicializa la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos y crea las tablas
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cestaria.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crea las tablas iniciales
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('[DB] Creando base de datos local v$version');

    // Tabla de productos (caché)
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT,
        quantity TEXT,
        price REAL,
        image_url TEXT,
        nutrition TEXT,
        nutri_score TEXT,
        last_updated INTEGER,
        cached_at INTEGER NOT NULL
      )
    ''');

    // Tabla de carritos locales
    await db.execute('''
      CREATE TABLE carts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        participant_ids TEXT,
        created_at INTEGER,
        updated_at INTEGER,
        last_modified_by TEXT,
        store TEXT,
        is_archived INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Tabla de items del carrito
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cart_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity REAL DEFAULT 1.0,
        unit TEXT,
        unit_price REAL,
        notes TEXT,
        is_checked INTEGER DEFAULT 0,
        is_purchased INTEGER DEFAULT 0,
        purchased_by TEXT,
        purchased_at INTEGER,
        FOREIGN KEY (cart_id) REFERENCES carts (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de historial de compras
    await db.execute('''
      CREATE TABLE purchase_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cart_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT,
        unit_price REAL,
        total_price REAL,
        purchased_at INTEGER NOT NULL,
        purchased_by TEXT,
        store TEXT
      )
    ''');

    // Índices para mejorar el rendimiento
    await db.execute('CREATE INDEX idx_products_name ON products(name)');
    await db.execute('CREATE INDEX idx_cart_items_cart_id ON cart_items(cart_id)');
    await db.execute('CREATE INDEX idx_cart_items_product_id ON cart_items(product_id)');
    await db.execute('CREATE INDEX idx_purchase_history_date ON purchase_history(purchased_at)');

    debugPrint('[DB] Base de datos creada correctamente');
  }

  /// Maneja las migraciones de versiones futuras
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('[DB] Migrando base de datos de v$oldVersion a v$newVersion');

    // Ejemplo de migración futura:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE products ADD COLUMN new_field TEXT');
    // }
  }

  // ==================== PRODUCTOS (CACHÉ) ====================

  /// Guarda o actualiza un producto en caché
  Future<void> cacheProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      {
        'id': product.id,
        'name': product.name,
        'brand': product.brand,
        'quantity': product.quantity,
        'price': product.price,
        'image_url': product.imageUrl,
        'nutrition': product.nutrition != null ? jsonEncode(product.nutrition) : null,
        'nutri_score': product.nutriScore,
        'last_updated': product.lastUpdated?.millisecondsSinceEpoch,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('[DB] Producto cacheado: ${product.name}');
  }

  /// Obtiene un producto del caché por ID
  Future<Product?> getCachedProduct(String productId) async {
    final db = await database;
    final results = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return Product(
      id: row['id'] as String,
      name: row['name'] as String,
      brand: row['brand'] as String?,
      quantity: row['quantity'] as String?,
      price: row['price'] as double?,
      imageUrl: row['image_url'] as String?,
      nutrition: row['nutrition'] != null 
          ? jsonDecode(row['nutrition'] as String) as Map<String, dynamic>
          : null,
      nutriScore: row['nutri_score'] as String?,
      lastUpdated: row['last_updated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['last_updated'] as int)
          : null,
    );
  }

  /// Busca productos en caché por nombre
  Future<List<Product>> searchCachedProducts(String query) async {
    final db = await database;
    final results = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'cached_at DESC',
      limit: 20,
    );

    return results.map((row) {
      return Product(
        id: row['id'] as String,
        name: row['name'] as String,
        brand: row['brand'] as String?,
        quantity: row['quantity'] as String?,
        price: row['price'] as double?,
        imageUrl: row['image_url'] as String?,
        nutrition: row['nutrition'] != null 
            ? jsonDecode(row['nutrition'] as String) as Map<String, dynamic>
            : null,
        nutriScore: row['nutri_score'] as String?,
        lastUpdated: row['last_updated'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['last_updated'] as int)
            : null,
      );
    }).toList();
  }

  /// Limpia productos cacheados antiguos (más de 30 días)
  Future<void> clearOldCache() async {
    final db = await database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final deleted = await db.delete(
      'products',
      where: 'cached_at < ?',
      whereArgs: [thirtyDaysAgo.millisecondsSinceEpoch],
    );
    debugPrint('[DB] Productos eliminados del caché: $deleted');
  }

  // ==================== CARRITOS ====================

  /// Guarda o actualiza un carrito local
  Future<void> saveCart(Cart cart) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Guardar carrito
      await txn.insert(
        'carts',
        {
          'id': cart.id,
          'name': cart.name,
          'owner_id': cart.ownerId,
          'participant_ids': jsonEncode(cart.participantIds),
          'created_at': cart.createdAt?.millisecondsSinceEpoch,
          'updated_at': cart.updatedAt?.millisecondsSinceEpoch,
          'last_modified_by': cart.lastModifiedBy,
          'store': cart.store,
          'is_archived': cart.isArchived ? 1 : 0,
          'is_synced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Eliminar items antiguos
      await txn.delete('cart_items', where: 'cart_id = ?', whereArgs: [cart.id]);

      // Insertar items nuevos
      for (final item in cart.items) {
        await txn.insert('cart_items', {
          'cart_id': cart.id,
          'product_id': item.productId,
          'name': item.name,
          'quantity': item.quantity,
          'unit': item.unit,
          'unit_price': item.unitPrice,
          'notes': item.notes,
          'is_checked': item.isChecked ? 1 : 0,
          'is_purchased': item.isPurchased ? 1 : 0,
          'purchased_by': item.purchasedBy,
          'purchased_at': item.purchasedAt?.millisecondsSinceEpoch,
        });
      }
    });

    debugPrint('[DB] Carrito guardado: ${cart.name} (${cart.items.length} items)');
  }

  /// Obtiene un carrito por ID
  Future<Cart?> getCart(String cartId) async {
    final db = await database;
    
    // Obtener carrito
    final cartResults = await db.query(
      'carts',
      where: 'id = ?',
      whereArgs: [cartId],
      limit: 1,
    );

    if (cartResults.isEmpty) return null;

    final cartRow = cartResults.first;

    // Obtener items
    final itemResults = await db.query(
      'cart_items',
      where: 'cart_id = ?',
      whereArgs: [cartId],
    );

    final items = itemResults.map((row) {
      return CartItem(
        productId: row['product_id'] as String,
        name: row['name'] as String,
        quantity: row['quantity'] as double,
        unit: row['unit'] as String?,
        unitPrice: row['unit_price'] as double?,
        notes: row['notes'] as String?,
        isChecked: (row['is_checked'] as int) == 1,
        isPurchased: (row['is_purchased'] as int) == 1,
        purchasedBy: row['purchased_by'] as String?,
        purchasedAt: row['purchased_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['purchased_at'] as int)
            : null,
      );
    }).toList();

    return Cart(
      id: cartRow['id'] as String,
      name: cartRow['name'] as String,
      ownerId: cartRow['owner_id'] as String,
      participantIds: (jsonDecode(cartRow['participant_ids'] as String) as List)
          .cast<String>(),
      items: items,
      createdAt: cartRow['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(cartRow['created_at'] as int)
          : null,
      updatedAt: cartRow['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(cartRow['updated_at'] as int)
          : null,
      lastModifiedBy: cartRow['last_modified_by'] as String?,
      store: cartRow['store'] as String?,
      isArchived: (cartRow['is_archived'] as int) == 1,
    );
  }

  /// Obtiene todos los carritos del usuario
  Future<List<Cart>> getAllCarts({bool includeArchived = false}) async {
    final db = await database;
    final results = await db.query(
      'carts',
      where: includeArchived ? null : 'is_archived = ?',
      whereArgs: includeArchived ? null : [0],
      orderBy: 'updated_at DESC',
    );

    final List<Cart> carts = [];
    for (final row in results) {
      final cart = await getCart(row['id'] as String);
      if (cart != null) carts.add(cart);
    }

    return carts;
  }

  /// Elimina un carrito
  Future<void> deleteCart(String cartId) async {
    final db = await database;
    await db.delete('carts', where: 'id = ?', whereArgs: [cartId]);
    debugPrint('[DB] Carrito eliminado: $cartId');
  }

  /// Marca un carrito como archivado
  Future<void> archiveCart(String cartId) async {
    final db = await database;
    await db.update(
      'carts',
      {'is_archived': 1},
      where: 'id = ?',
      whereArgs: [cartId],
    );
    debugPrint('[DB] Carrito archivado: $cartId');
  }

  // ==================== HISTORIAL ====================

  /// Guarda items comprados en el historial
  Future<void> savePurchaseHistory(Cart cart) async {
    final db = await database;
    
    for (final item in cart.items.where((i) => i.isPurchased)) {
      await db.insert('purchase_history', {
        'cart_id': cart.id,
        'product_id': item.productId,
        'name': item.name,
        'quantity': item.quantity,
        'unit': item.unit,
        'unit_price': item.unitPrice,
        'total_price': (item.unitPrice ?? 0) * item.quantity,
        'purchased_at': item.purchasedAt?.millisecondsSinceEpoch ?? 
            DateTime.now().millisecondsSinceEpoch,
        'purchased_by': item.purchasedBy,
        'store': cart.store,
      });
    }
    debugPrint('[DB] Historial guardado: ${cart.items.where((i) => i.isPurchased).length} items');
  }

  /// Obtiene el historial de compras
  Future<List<Map<String, dynamic>>> getPurchaseHistory({
    int? limit,
    String? store,
    DateTime? since,
  }) async {
    final db = await database;
    
    String? whereClause;
    List<dynamic>? whereArgs;

    if (store != null || since != null) {
      final conditions = <String>[];
      whereArgs = [];

      if (store != null) {
        conditions.add('store = ?');
        whereArgs.add(store);
      }
      if (since != null) {
        conditions.add('purchased_at >= ?');
        whereArgs.add(since.millisecondsSinceEpoch);
      }
      whereClause = conditions.join(' AND ');
    }

    final results = await db.query(
      'purchase_history',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'purchased_at DESC',
      limit: limit,
    );

    return results.map((row) => {
      'id': row['id'],
      'cartId': row['cart_id'],
      'productId': row['product_id'],
      'name': row['name'],
      'quantity': row['quantity'],
      'unit': row['unit'],
      'unitPrice': row['unit_price'],
      'totalPrice': row['total_price'],
      'purchasedAt': row['purchased_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['purchased_at'] as int)
          : null,
      'purchasedBy': row['purchased_by'],
      'store': row['store'],
    }).toList();
  }

  /// Obtiene productos comprados con frecuencia
  Future<List<Map<String, dynamic>>> getFrequentlyPurchasedProducts({
    int limit = 10,
    int daysBack = 90,
  }) async {
    final db = await database;
    final since = DateTime.now().subtract(Duration(days: daysBack));

    final results = await db.rawQuery('''
      SELECT 
        product_id,
        name,
        COUNT(*) as purchase_count,
        AVG(unit_price) as avg_price,
        MAX(purchased_at) as last_purchased
      FROM purchase_history
      WHERE purchased_at >= ?
      GROUP BY product_id
      ORDER BY purchase_count DESC, last_purchased DESC
      LIMIT ?
    ''', [since.millisecondsSinceEpoch, limit]);

    return results.map((row) => {
      'productId': row['product_id'],
      'name': row['name'],
      'purchaseCount': row['purchase_count'],
      'avgPrice': row['avg_price'],
      'lastPurchased': row['last_purchased'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['last_purchased'] as int)
          : null,
    }).toList();
  }

  // ==================== UTILIDADES ====================

  /// Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    debugPrint('[DB] Base de datos cerrada');
  }

  /// Elimina toda la base de datos (solo para desarrollo/testing)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cestaria.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
    debugPrint('[DB] Base de datos eliminada');
  }

  /// Obtiene estadísticas de la base de datos
  Future<Map<String, int>> getStats() async {
    final db = await database;
    
    final productsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM products')
    ) ?? 0;
    
    final cartsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM carts')
    ) ?? 0;
    
    final historyCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM purchase_history')
    ) ?? 0;

    return {
      'products': productsCount,
      'carts': cartsCount,
      'history': historyCount,
    };
  }
}