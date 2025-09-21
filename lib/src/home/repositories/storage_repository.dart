// Repositório que salva e recupera histórico usando StorageService (Hive)
import '../../shared/storage/storage_service.dart';
import '../model/address_model.dart';

class StorageRepository {
  final StorageService storage;

  StorageRepository({required this.storage});

  /// Salva um endereço no histórico
  Future<void> save(AddressModel model) async {
    await storage.save({
      'cep': model.cep,
      'logradouro': model.logradouro,
      'complemento': model.complemento,
      'bairro': model.bairro,
      'localidade': model.localidade,
      'estado': model.estado,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Recupera todo o histórico
  List<AddressModel> getAll() {
    final list = storage.getAll();
    return list.map((m) => AddressModel.fromMap(m)).toList();
  }

  /// Recupera o último endereço consultado
  AddressModel? getLast() {
    final m = storage.getLast();
    if (m == null) return null;
    return AddressModel.fromMap(m);
  }

  /// Remove um item específico do histórico
  Future<void> remove(AddressModel model) async {
    try {
      await storage.removeWhere((m) =>
          m['cep'] == model.cep &&
          m['logradouro'] == model.logradouro &&
          m['bairro'] == model.bairro);
    } catch (e) {
      print('Erro ao remover item do histórico: $e');
    }
  }
}
