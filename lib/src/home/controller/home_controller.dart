import 'package:mobx/mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/address_model.dart';
import '../service/home_service.dart';

/// Controller da tela Home, gerencia estado do endereço, histórico, loading e erros.
class HomeController {
  // ================================
  // Observables (estado reativo)
  // ================================
  final Observable<AddressModel?> _address = Observable(null);
  final ObservableList<AddressModel> _history = ObservableList<AddressModel>();
  final Observable<bool> _loading = Observable(false);
  final Observable<String?> _error = Observable(null);

  // ================================
  // Serviço responsável por buscar dados
  // ================================
  final HomeService service;

  // Caixa Hive (deve ser aberta no main.dart)
  final Box _historyBox = Hive.box('historyBox');

  HomeController({required this.service}) {
    // Inicializa o histórico a partir do Hive
    final stored = _historyBox.get('history', defaultValue: <AddressModel>[]);
    if (stored is List<AddressModel>) {
      _history.addAll(stored);
    }
  }

  // ================================
  // Getters reativos
  // ================================
  AddressModel? get address => _address.value;
  List<AddressModel> get history => _history.toList();
  bool get loading => _loading.value;
  String? get error => _error.value;

  // ================================
  // Actions
  // ================================
  late final AsyncAction _fetchAddressAction = AsyncAction('_fetchAddress');

  /// Consulta um endereço pelo CEP
  Future<void> fetchAddress(String cep) async {
    if (_loading.value) return; // evita múltiplas chamadas simultâneas
    await _fetchAddressAction.run(() => _fetchAddress(cep));
  }

  Future<void> _fetchAddress(String cep) async {
    _loading.value = true;
    _error.value = null;

    try {
      final result = await service.fetchAddress(cep);

      if (result.erro) {
        _address.value = null;
        _error.value = 'CEP não encontrado';
      } else {
        _address.value = result;
        _history.insert(0, result);

        // Salva no Hive
        _historyBox.put('history', _history.toList());
      }
    } catch (e) {
      _address.value = null;
      _error.value = 'Erro na consulta: ${e.toString()}';
    } finally {
      _loading.value = false;
    }
  }
}
