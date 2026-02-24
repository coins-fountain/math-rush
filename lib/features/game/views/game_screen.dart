import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../controllers/game_controller.dart';
import 'widgets/answer_button.dart';
import 'widgets/question_display.dart';
import 'widgets/revive_countdown_dialog.dart';
import 'widgets/rush_timer_bar.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                      Obx(
                        () => Text(
                          'Score: ${controller.score.value}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                              if (controller.isNewHighScore.value) ...[
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
                              ] else ...[
                                Text(
                                  "Final Score: ${controller.score.value}",
                                  style: const TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
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
                                onPressed: () => Get.offAllNamed('/home'),
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

              if (controller.startCountdown.value > 0) {
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

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
