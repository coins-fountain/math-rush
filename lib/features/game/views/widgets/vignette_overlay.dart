import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_controller.dart';

class VignetteOverlay extends GetView<GameController> {
  const VignetteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final timerValue = controller.currentTimerValue.value;
      // Show vignette only when timer is below 25%
      double opacity = 0.0;
      if (timerValue < 0.25) {
        // Map 0.25 -> 0.0 to 0.0 -> 0.6 opacity
        opacity = (0.25 - timerValue) / 0.25 * 0.6;
      }

      if (opacity <= 0) return const SizedBox.shrink();

      return IgnorePointer(
        child: AnimatedOpacity(
          opacity: opacity.clamp(0.0, 0.6),
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
      );
    });
  }
}
