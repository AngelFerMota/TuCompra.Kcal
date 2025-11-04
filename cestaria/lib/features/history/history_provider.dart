import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cestaria/models/cart.dart';
import 'history_repository.dart';

final historyProvider = StateNotifierProvider<HistoryController, AsyncValue<List<Cart>>>(
  (ref) => HistoryController(ref.read(historyRepositoryProvider)),
);

class HistoryController extends StateNotifier<AsyncValue<List<Cart>>> {
  HistoryController(this._repo) : super(const AsyncValue.data(<Cart>[]));
  final HistoryRepository _repo;

  Future<void> load() async {
    state = const AsyncValue.loading();
    // TODO: use _repo.listArchived();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = AsyncValue.data(await _repo.listArchived());
  }
}
