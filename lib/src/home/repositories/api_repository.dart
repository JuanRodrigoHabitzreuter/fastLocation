// Repositório que consulta a API externa via HttpService.
// Import: http_service.dart, address_model.dart
import '../../http/http_service.dart';
import '../model/address_model.dart';

class ApiRepository {
  final HttpService http;

  ApiRepository({required this.http});

  // Consulta ViaCEP: /{cep}/json
  Future<AddressModel> getAddressByCep(String cep) async {
    // Normaliza apenas números
    final normalized = cep.replaceAll(RegExp(r'\D'), '');
    final response = await http.get('/$normalized/json/');
    final data = response.data;
    if (data == null) {
      throw Exception('Resposta vazia da API');
    }
    final map = Map<String, dynamic>.from(data);
    if (map.containsKey('erro') && map['erro'] == true) {
      return AddressModel(cep: normalized, logradouro: '', complemento: '', bairro: '', localidade: '', estado: '', erro: true);
    }
    return AddressModel.fromMap(map);
  }
}
