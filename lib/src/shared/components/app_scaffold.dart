import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? leading; // ✅ novo parâmetro opcional
  final Color appBarColor; // cor de fundo do AppBar
  final Color titleColor; // cor do título

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.leading, // ✅ aceitando leading
    this.appBarColor = const Color.fromARGB(255, 1, 23, 170), // azul padrão
    this.titleColor = Colors.white, // branco padrão
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        leading: leading, // ✅ repassado para o AppBar
        iconTheme: IconThemeData(color: titleColor), // ícones brancos por padrão
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
