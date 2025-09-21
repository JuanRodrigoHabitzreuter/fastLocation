// Componente para mostrar quando não houve busca ou resultado vazio.
// Import: flutter/material.dart
import 'package:flutter/material.dart';

class EmptySearch extends StatelessWidget {
  final String message;
  const EmptySearch({super.key, this.message = 'Nenhum endereço encontrado. Faça uma busca por CEP.'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 72, color: Colors.white),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
