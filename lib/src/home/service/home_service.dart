// Implementa regras de negócio usando os repositórios.
// Import: api_repository, storage_repository, address_model
import '../repositories/api_repository.dart';
import '../repositories/storage_repository.dart';
import '../model/address_model.dart';

class HomeService {
  final ApiRepository apiRepo;
  final StorageRepository storageRepo;

  HomeService({required this.apiRepo, required this.storageRepo});

  Future<AddressModel> fetchAddress(String cep) async {
    final addr = await apiRepo.getAddressByCep(cep);
    if (!addr.erro && addr.cep.isNotEmpty) {
      await storageRepo.save(addr); // salva histórico
    }
    return addr;
  }

  List<AddressModel> getHistory() {
    return storageRepo.getAll();
  }

  AddressModel? getLast() {
    return storageRepo.getLast();
  }
}
