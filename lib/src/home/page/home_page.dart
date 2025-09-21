import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../shared/components/app_scaffold.dart';
import '../../shared/components/loading_widget.dart';
import '../../shared/metrics/metrics.dart';
import '../components/address_list_item.dart';
import '../components/last_address_card.dart';
import '../controller/home_controller.dart';
import '../../http/http_service.dart';
import '../repositories/api_repository.dart';
import '../repositories/storage_repository.dart';
import '../../shared/storage/storage_service.dart';
import '../service/home_service.dart';
import '../../routes/app_routes.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({super.key});
  @override
  State<HomePageWrapper> createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  late final HomeController controller;
  final TextEditingController _cepCtrl = TextEditingController();

  static const Color primaryBlue = Color.fromARGB(255, 1, 23, 170);
  static const Color primary = Colors.deepOrange; // laranja padrão

  @override
  void initState() {
    super.initState();
    final http = HttpService();
    final apiRepo = ApiRepository(http: http);
    final storageService = StorageService();
    final storageRepo = StorageRepository(storage: storageService);
    final service = HomeService(apiRepo: apiRepo, storageRepo: storageRepo);
    controller = HomeController(service: service);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '📌fastLocation💨',
      appBarColor: primaryBlue,
      titleColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.history),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
      ),
      body: Container(
        color: primary, // body laranja
        padding: const EdgeInsets.all(Metrics.padding),
        child: Column(
          children: [
            // Campo de busca por CEP
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cepCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Informe apenas os números',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: primary,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Metrics.small),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final cep = _cepCtrl.text.trim();
                    if (cep.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe o CEP'),
                        ),
                      );
                      return;
                    }
                    controller.fetchAddress(cep);
                  },
                  child: const Text('Pesquisar🔎'),
                ),
              ],
            ),
            const SizedBox(height: Metrics.small),

            // Observer para reatividade do MobX
            Expanded(
              child: Observer(
                builder: (_) {
                  if (controller.loading) {
                    return const LoadingWidget(message: 'Buscando CEP...');
                  }
                  if (controller.error != null) {
                    return Center(
                      child: Text(
                        controller.error!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final addr = controller.address;
                  if (addr == null) {
                    final last = controller.history.isNotEmpty
                        ? controller.history.first
                        : null;
                    if (last != null) {
                      return ListView(
                        children: [
                          const SizedBox(height: Metrics.small),
                          const Text(
                            'Último endereço consultado:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          LastAddressCard(model: last),
                          const SizedBox(height: Metrics.big),
                          const Text(
                            'Histórico:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          ...controller.history
                              .map((m) => AddressListItem(model: m)),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Nenhum endereço encontrado. Faça uma busca por CEP.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Card azul com letras brancas
                          Card(
                            color: primaryBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(Metrics.padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CEP: ${addr.cep}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Logradouro: ${addr.logradouro}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text('Complemento: ${addr.complemento}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text('Bairro: ${addr.bairro}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text('Cidade: ${addr.localidade}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text('Estado: ${addr.estado}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Metrics.big),
                          const Text(
                            'Histórico recente:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          ...controller.history.map(
                            (m) => AddressListItem(
                              model: m,
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              trailingWidget: TextButton(
                                onPressed: () {
                                  // ação ao clicar no pino, se necessário
                                },
                                child: const Text(
                                  '📌',
                                  style: TextStyle(
                                      fontSize:
                                          20), // aumenta o tamanho se quiser
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
