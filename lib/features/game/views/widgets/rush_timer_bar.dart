import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RushTimerBar extends StatelessWidget {
  const RushTimerBar({
    super.key,
    required this.progress, // 0.0 to 1.0
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    // Change color as it gets closer to 0
    Color barColor = AppColors.primary;
    if (progress < 0.25) {
      barColor = AppColors.danger;
    } else if (progress < 0.5) {
      barColor = AppColors.accent;
    }

    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.buttonGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
