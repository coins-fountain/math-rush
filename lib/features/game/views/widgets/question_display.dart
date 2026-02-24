import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class QuestionDisplay extends StatelessWidget {
  const QuestionDisplay({super.key, required this.questionText});

  final String questionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.buttonGray,
        borderRadius: BorderRadius.circular(24),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          questionText,
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
