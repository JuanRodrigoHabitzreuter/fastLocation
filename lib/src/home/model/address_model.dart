import 'dart:convert';
import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String logradouro;

  @HiveField(2)
  final String complemento;

  @HiveField(3)
  final String bairro;

  @HiveField(4)
  final String localidade;

  @HiveField(5)
  final String estado;

  @HiveField(6)
  final bool erro;

  AddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.estado,
    this.erro = false,
  });

  /// Construtor a partir de Map
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      cep: _parseCep(map['cep']),
      logradouro: map['logradouro']?.toString() ?? '',
      complemento: map['complemento']?.toString() ?? '',
      bairro: map['bairro']?.toString() ?? '',
      localidade: map['localidade']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
      erro: map['erro'] == true,
    );
  }

  /// Construtor a partir de JSON string
  factory AddressModel.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return AddressModel.fromMap(map);
  }

  /// Normaliza o CEP (remove caracteres não numéricos)
  static String _parseCep(dynamic cepValue) {
    if (cepValue == null) return '';
    return cepValue.toString().replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'estado': estado,
      'erro': erro,
    };
  }

  /// Converte para JSON string
  String toJson() => jsonEncode(toMap());

  /// Endereço completo formatado
  String get fullAddress {
    final parts = [
      logradouro,
      if (complemento.isNotEmpty) 'Complemento: $complemento',
      bairro,
      '$localidade/$estado'
    ].where((part) => part.isNotEmpty).toList();

    return parts.join(' - ');
  }

  /// Endereço resumido (para listas)
  String get shortAddress => '$logradouro, $bairro - $localidade/$estado';

  /// Verifica se o endereço é válido
  bool get isValid => !erro && cep.isNotEmpty;

  /// CEP formatado (XXXXX-XXX)
  String get formattedCep {
    if (cep.length != 8) return cep;
    return '${cep.substring(0, 5)}-${cep.substring(5)}';
  }

  /// Cópia do objeto com campos opcionais para alteração
  AddressModel copyWith({
    String? cep,
    String? logradouro,
    String? complemento,
    String? bairro,
    String? localidade,
    String? estado,
    bool? erro,
  }) {
    return AddressModel(
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      localidade: localidade ?? this.localidade,
      estado: estado ?? this.estado,
      erro: erro ?? this.erro,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressModel &&
        other.cep == cep &&
        other.logradouro == logradouro &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.localidade == localidade &&
        other.estado == estado &&
        other.erro == erro;
  }

  @override
  int get hashCode => Object.hash(cep, logradouro, complemento, bairro, localidade, estado, erro);

  @override
  String toString() {
    return 'AddressModel(cep: $cep, logradouro: $logradouro, complemento: $complemento, bairro: $bairro, localidade: $localidade, estado: $estado, erro: $erro)';
  }
}
