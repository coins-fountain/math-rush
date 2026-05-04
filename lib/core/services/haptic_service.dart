import 'package:flutter/services.dart';

import 'sound_service.dart';

class HapticService {
  static void correctAnswer() => HapticFeedback.lightImpact();
  static void wrongAnswer() => HapticFeedback.heavyImpact();
  static void levelUp() => HapticFeedback.mediumImpact();
  static void buttonPress() {
    HapticFeedback.selectionClick();
    SoundService.playTap();
  }

  static void criticalWarning() => HapticFeedback.vibrate();
}
