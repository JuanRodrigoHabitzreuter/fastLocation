// Entrypoint do app Flutter
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart'; //  importa MyApp

Future<void> main() async {
  // Garante que os bindings do Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive para armazenamento local
  await Hive.initFlutter();

  // Abre a caixa que vai armazenar histórico de CEPs
  await Hive.openBox('historyBox');

  // Inicializa o app
  runApp(const MyApp());
}
