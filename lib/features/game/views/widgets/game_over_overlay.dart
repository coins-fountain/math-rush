import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../controllers/game_controller.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({super.key});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  late ConfettiController _confettiController;
  final GameController controller = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (controller.isNewHighScore.value) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  AppColors.gold,
                  AppColors.primary,
                  AppColors.accent,
                  Colors.white,
                ],
              ),
            ),
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
                      minimumSize: const Size(200, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Share.share(
                        'I just scored ${controller.score.value} on Math Rush! 🧠⚡ Can you beat my score?',
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("SHARE SCORE"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textMain,
                      minimumSize: const Size(200, 56),
                      side: const BorderSide(color: AppColors.textMuted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => Get.offAllNamed('/'),
                    icon: const Icon(Icons.home),
                    label: const Text("HOME"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
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
