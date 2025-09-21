// Tela inicial (splash) com animação simples e redirecionamento automático para home.
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Inicializa animação de escala
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);

    // Redireciona automaticamente após 2 segundos
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/fastlocation.png', // caminho correto da imagem
                width: 84,
                height: 84,
                color: Colors.white, // aplica cor branca
              ),
              const SizedBox(height: 12),
              const Text(
                'Consulta CEP',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
