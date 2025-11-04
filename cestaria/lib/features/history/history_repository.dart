import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/core/providers/services_providers.dart';
import 'package:cestaria/core/services/local_database.dart';

/// Acceso al histórico de carritos en SQLite.
class HistoryRepository {
  HistoryRepository(this._db);
  // ignore: unused_field
  final LocalDatabase _db;

  Future<List<Cart>> listArchived() async {
    // TODO: leer carritos archivados
    return <Cart>[];
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final db = ref.read(localDatabaseProvider);
  return HistoryRepository(db);
});
