import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/game_config.dart';

class ReviveCountdownDialog extends StatelessWidget {
  const ReviveCountdownDialog({
    super.key,
    required this.onRevive,
    required this.onSkip,
  });

  final VoidCallback onRevive;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.2),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'REVIVE?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: GameConfig.reviveCountdownSeconds.toDouble(),
                      end: 0.0,
                    ),
                    duration: const Duration(
                      seconds: GameConfig.reviveCountdownSeconds,
                    ),
                    onEnd: onSkip,
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: CircularProgressIndicator(
                              value: value / GameConfig.reviveCountdownSeconds,
                              strokeWidth: 10,
                              color: AppColors.primary,
                              backgroundColor: AppColors.buttonGray,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Text(
                            value.ceil().toString(),
                            style: const TextStyle(
                              color: AppColors.textMain,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: onRevive,
                    icon: const Icon(Icons.play_circle_fill, size: 28),
                    label: const Text('WATCH TO REVIVE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.primary.withValues(alpha: 0.5),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'NO THANKS',
                      style: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
