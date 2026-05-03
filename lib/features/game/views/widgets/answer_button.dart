import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../models/answer_result.dart';
import '../../controllers/game_controller.dart';

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.buttonGray,
    this.isLeft = true,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLeft;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  final GameController gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Listen to answer results to trigger shake
    ever(gameController.lastAnswerResult, (AnswerResult? result) {
      if (result == AnswerResult.wrong && gameController.lastClickWasLeft.value == widget.isLeft) {
        _controller.forward(from: 0).then((_) => _controller.reverse());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double shakeOffset = 0;
            if (_controller.isAnimating) {
              // Simple horizontal shake logic
              shakeOffset = (0.5 - (0.5 - (_controller.value * 5 % 1)).abs()) * 15 * (widget.isLeft ? -1 : 1);
            }

            return Transform.translate(
              offset: Offset(shakeOffset, _isPressed ? 4.0 : 0.0),
              child: Obx(() {
                Color displayColor = widget.color;
                final result = gameController.lastAnswerResult.value;
                final wasClicked = gameController.lastClickWasLeft.value == widget.isLeft;

                if (result != null && wasClicked) {
                  displayColor = result == AnswerResult.correct ? AppColors.success : AppColors.danger;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: displayColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.textMuted.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: _isPressed
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
