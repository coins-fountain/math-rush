import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/game_controller.dart';
import 'widgets/answer_button.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/pause_overlay.dart';
import 'widgets/question_display.dart';
import 'widgets/revive_countdown_dialog.dart';
import 'widgets/rush_timer_bar.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.06;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!controller.isGameOver.value && !controller.isPaused.value) {
          controller.pauseGame();
          _showQuitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            'Level: ${controller.difficultyLevel.value}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                '${controller.score.value}',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: controller.pauseGame,
                              icon: const Icon(Icons.pause_circle_filled, size: 32),
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Obx(
                      () => RushTimerBar(
                        progress: controller.currentTimerValue.value,
                      ),
                    ),

                    const Spacer(),

                    Obx(() {
                      final question = controller.currentQuestion.value;
                      if (question == null) return const SizedBox.shrink();
                      return QuestionDisplay(questionText: question.questionText);
                    }),

                    const Spacer(),

                    Obx(() {
                      final question = controller.currentQuestion.value;
                      if (question == null) return const SizedBox.shrink();

                      return Row(
                        children: [
                          AnswerButton(
                            label: question.leftButtonText,
                            onTap: () => controller.validateAnswer(true),
                          ),
                          const SizedBox(width: 16),
                          AnswerButton(
                            label: question.rightButtonText,
                            onTap: () => controller.validateAnswer(false),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              Obx(() {
                if (controller.isWatchingAd.value) {
                  return ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (controller.isReviveCountDown.value) {
                  return ReviveCountdownDialog(
                    onRevive: controller.watchReviveAd,
                    onSkip: controller.skipRevive,
                  );
                }

                if (controller.isGameOver.value &&
                    !controller.isReviveCountDown.value) {
                  return const GameOverOverlay();
                }

                if (controller.isPaused.value) {
                  return const PauseOverlay();
                }

                if (controller.startCountdown.value > 0) {
                  return _buildStartCountdown();
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartCountdown() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: Center(
            child: TweenAnimationBuilder<double>(
              key: ValueKey<int>(controller.startCountdown.value),
              tween: Tween(begin: 0.5, end: 1.5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Text(
                    '${controller.startCountdown.value}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 160,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          blurRadius: 30,
                        ),
                        const Shadow(
                          color: Colors.white,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Quit Game?"),
        content: const Text("Are you sure you want to quit this game? Your current progress will be lost."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              controller.resumeGame();
            },
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text("QUIT", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
