import 'package:mobx/mobx.dart';
import '../../home/repositories/storage_repository.dart';
import '../../home/model/address_model.dart';

class HistoryController {
  final StorageRepository storageRepo;

  /// Lista reativa de endereços históricos
  final ObservableList<AddressModel> items = ObservableList<AddressModel>();

  /// Estado de carregamento reativo
  final Observable<bool> loading = Observable(false);

  HistoryController({required this.storageRepo}) {
    loadHistory();
  }

  /// Carrega todo o histórico do storage
  Future<void> loadHistory() async {
    runInAction(() => loading.value = true);
    try {
      final storedItems = await storageRepo.getAll();
      runInAction(() {
        items
          ..clear()
          ..addAll(storedItems);
      });
    } catch (e) {
      runInAction(() {
        items.clear();
      });
      print('Erro ao carregar histórico: $e');
    } finally {
      runInAction(() => loading.value = false);
    }
  }

  /// Atualiza o histórico (para RefreshIndicator)
  Future<void> refresh() async => loadHistory();

  /// Remove um item do histórico
  Future<void> removeItem(AddressModel item) async {
    try {
      await storageRepo.remove(item); // remove do cache
      runInAction(() {
        items.remove(item); // remove da lista reativa
      });
    } catch (e) {
      print('Erro ao remover item: $e');
    }
  }
}
