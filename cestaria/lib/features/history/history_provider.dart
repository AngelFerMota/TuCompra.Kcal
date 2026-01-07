import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'package:cestaria/core/utils/mock_data.dart';
import 'history_repository.dart';

final historyProvider = StateNotifierProvider<HistoryController, AsyncValue<List<Cart>>>(
  (ref) {
    final controller = HistoryController(ref.read(historyRepositoryProvider));
    // Carga automática con datos mock
    controller.load();
    return controller;
  },
);

class HistoryController extends StateNotifier<AsyncValue<List<Cart>>> {
  HistoryController(this._repo) : super(const AsyncValue.data(<Cart>[]));
  // ignore: unused_field
  final HistoryRepository _repo;

  Future<void> load() async {
    state = const AsyncValue.loading();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Usa datos mock para visualizar UI
    // TODO: reemplazar con _repo.listArchived() cuando esté implementado
    state = AsyncValue.data(MockData.archivedCarts);
  }
}
