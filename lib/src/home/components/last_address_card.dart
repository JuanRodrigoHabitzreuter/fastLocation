// Componente exibindo o último endereço consultado com ação de traçar rota.
// Import: flutter/material.dart, map_launcher, geocoding, address_model
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart';
import '../model/address_model.dart';

class LastAddressCard extends StatelessWidget {
  final AddressModel model;

  const LastAddressCard({super.key, required this.model});

  // Usa geocoding para obter lat/lng a partir do endereço completo e abre o Maps via map_launcher.
  Future<void> openRoute(BuildContext context) async {
    final address = model.fullAddress;
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Endereço inválido para traçar rota')));
      return;
    }

    try {
      final locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível obter coordenadas')));
        return;
      }
      final loc = locations.first;
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isNotEmpty) {
        // Abre o primeiro app de mapa disponível
        await availableMaps.first.showMarker(
          coords: Coords(loc.latitude, loc.longitude),
          title: model.fullAddress,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhum app de mapa disponível')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(model.fullAddress.isEmpty ? model.cep : model.fullAddress),
        subtitle: Text('${model.bairro} • ${model.localidade}-${model.estado}'),
        trailing: ElevatedButton.icon(
          icon: const Icon(Icons.map),
          label: const Text('Traçar Rota'),
          onPressed: () => openRoute(context),
        ),
      ),
    );
  }
}
