import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_rush/core/constants/app_colors.dart';
import 'package:math_rush/core/services/consent_service.dart';
import 'package:math_rush/core/services/ad_service.dart';
import 'package:math_rush/features/game/bindings/game_binding.dart';
import 'package:math_rush/features/game/views/game_screen.dart';
import 'package:math_rush/features/home/bindings/home_binding.dart';
import 'package:math_rush/features/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() async {
    final consentService = ConsentService();
    await consentService.init();
    return consentService;
  });

  await Get.putAsync(() => AdService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Math Rush',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/game',
          page: () => const GameScreen(),
          binding: GameBinding(),
        ),
      ],
    );
  }
}
