import 'dart:math';

import '../../../../data/models/question_model.dart';
import 'modes/comparison_mode.dart';
import 'modes/even_odd_mode.dart';
import 'modes/math_trap_mode.dart';
import 'modes/pattern_mode.dart';
import 'modes/prime_mode.dart';

enum GameMode { greaterLower, evenOdd, primeCheck, mathTrap, patternBreak }

class QuestionGenerator {
  static QuestionModel generate(int difficulty) {
    final modes = GameMode.values;
    final selectedMode = modes[Random().nextInt(modes.length)];

    switch (selectedMode) {
      case GameMode.greaterLower:
        return ComparisonMode.generate(difficulty);
      case GameMode.evenOdd:
        return EvenOddMode.generate(difficulty);
      case GameMode.primeCheck:
        return PrimeCheckMode.generate(difficulty);
      case GameMode.mathTrap:
        return MathTrapMode.generate(difficulty);
      case GameMode.patternBreak:
        return PatternMode.generate(difficulty);
    }
  }
}
