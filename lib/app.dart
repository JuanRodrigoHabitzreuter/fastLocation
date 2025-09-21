import 'package:flutter/material.dart';

import 'package:fast_location/src/routes/app_routes.dart';
import 'package:fast_location/src/modules/initial/page/splash_page.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:fast_location/src/home/page/home_page.dart';
import 'package:fast_location/src/history/page/history_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fast_location',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => SplashPage(),
        AppRoutes.home: (_) => HomePageWrapper(),
        AppRoutes.history: (_) => HistoryPageWrapper(),
      },
    );
  }
}

