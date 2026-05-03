import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RushTimerBar extends StatefulWidget {
  const RushTimerBar({
    super.key,
    required this.progress, // 0.0 to 1.0
  });

  final double progress;

  @override
  State<RushTimerBar> createState() => _RushTimerBarState();
}

class _RushTimerBarState extends State<RushTimerBar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCritical = widget.progress < 0.20;
    
    // Change color as it gets closer to 0
    Color barColor = AppColors.primary;
    if (widget.progress < 0.25) {
      barColor = AppColors.danger;
    } else if (widget.progress < 0.5) {
      barColor = AppColors.accent;
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        double scale = 1.0;
        if (isCritical) {
          scale = 1.0 + (_pulseController.value * 0.05);
        }

        return Transform.scale(
          scaleY: scale,
          child: Container(
            height: isCritical ? 16 : 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.buttonGray,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isCritical 
                ? [BoxShadow(color: AppColors.danger.withValues(alpha: 0.3), blurRadius: 10 * _pulseController.value, spreadRadius: 2)]
                : [],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widget.progress.clamp(0.0, 1.0),
              child: Opacity(
                opacity: isCritical ? 0.7 + (_pulseController.value * 0.3) : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
