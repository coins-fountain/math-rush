import 'package:flutter/services.dart';

class HapticService {
  static void correctAnswer() => HapticFeedback.lightImpact();
  static void wrongAnswer() => HapticFeedback.heavyImpact();
  static void levelUp() => HapticFeedback.mediumImpact();
  static void buttonPress() => HapticFeedback.selectionClick();
  static void criticalWarning() => HapticFeedback.vibrate();
}
