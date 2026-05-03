import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../controllers/game_controller.dart';

class GameOverOverlay extends GetView<GameController> {
  const GameOverOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "GAME OVER",
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.isNewHighScore.value) {
                      return Column(
                        children: [
                          const Text(
                            "NEW HIGH SCORE!",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${controller.score.value}",
                            style: const TextStyle(
                              color: AppColors.textMain,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        "Final Score: ${controller.score.value}",
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 24,
                        ),
                      );
                    }
                  }),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: controller.startGame,
                    icon: const Icon(Icons.replay),
                    label: const Text("PLAY AGAIN"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => Get.offAllNamed('/'),
                    icon: const Icon(Icons.home),
                    label: const Text("HOME"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(child: BannerAdWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
