import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../shared/components/app_scaffold.dart';
import '../../shared/components/loading_widget.dart';
import '../../shared/storage/storage_service.dart';
import '../../home/repositories/storage_repository.dart';
import '../controller/history_controller.dart';
import '../../home/components/address_list_item.dart';

class HistoryPageWrapper extends StatefulWidget {
  const HistoryPageWrapper({super.key});

  @override
  State<HistoryPageWrapper> createState() => _HistoryPageWrapperState();
}

class _HistoryPageWrapperState extends State<HistoryPageWrapper> {
  late final HistoryController controller;

  static const Color primaryBlue = Color.fromARGB(255, 1, 23, 170);
  static const Color bodyOrange = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    final storageService = StorageService();
    final storageRepo = StorageRepository(storage: storageService);
    controller = HistoryController(storageRepo: storageRepo);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Histórico',
      appBarColor: primaryBlue,
      titleColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white), // ✅ botão branco
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: Observer(
        builder: (_) {
          if (controller.loading.value) {
            return const LoadingWidget();
          }

          if (controller.items.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum histórico encontrado.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: Container(
              color: bodyOrange,
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (_, index) {
                  final item = controller.items[index];
                  return AddressListItem(
                    model: item,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    trailingWidget: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () async {
                        await controller.removeItem(item);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
